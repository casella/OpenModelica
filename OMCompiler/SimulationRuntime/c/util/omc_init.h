/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-2014, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF THE BSD NEW LICENSE OR THE
 * GPL VERSION 3 LICENSE OR THE OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
 * RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
 * ACCORDING TO RECIPIENTS CHOICE.
 *
 * The OpenModelica software and the OSMC (Open Source Modelica Consortium)
 * Public License (OSMC-PL) are obtained from OSMC, either from the above
 * address, from the URLs: http://www.openmodelica.org or
 * http://www.ida.liu.se/projects/OpenModelica, and in the OpenModelica
 * distribution. GNU version 3 is obtained from:
 * http://www.gnu.org/copyleft/gpl.html. The New BSD License is obtained from:
 * http://www.opensource.org/licenses/BSD-3-Clause.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, EXCEPT AS
 * EXPRESSLY SET FORTH IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE
 * CONDITIONS OF OSMC-PL.
 *
 */

#ifndef _OMC_INIT_H
#define _OMC_INIT_H

#include "../openmodelica.h"

#if defined(OM_HAVE_PTHREADS)
#include <pthread.h>
DLLDirection extern pthread_key_t mmc_thread_data_key;
DLLDirection extern pthread_once_t mmc_init_once;
#else
static const int mmc_thread_data_key = 1;
#if defined(OMC_MODEL_PREFIX)
#define OMC_MAIN_THREADDATA_NAME globalThreadData_##OMC_MODEL_PREFIX
#else
#define OMC_MAIN_THREADDATA_NAME globalThreadData_UnknownModel
#endif
DLLDirection extern threadData_t *OMC_MAIN_THREADDATA_NAME;
static inline void* pthread_getspecific(int key)
{
  assert(key==mmc_thread_data_key);
  return NULL;
}
#endif

DLLDirection extern void mmc_init();
DLLDirection extern void mmc_init_nogc();

#endif
