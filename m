Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA88602340
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 06:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJREaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 00:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJRE3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 00:29:55 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7A3474C1
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 21:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666067392; x=1697603392;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z2ImgZ6jOyFdqGGYMqexARW20pfR1XGA2hzd5/UsJKE=;
  b=WKTX6yc7r63N6Up7W0SgVK7vpMj7bCiINHUgmqQ0w643PAkiIyaavc30
   gds1ZuJq6ELGpHOTQHeSnozIKhGiFti5URoQgiEpF44UDq8yU+6OUNVF6
   6owx3MtDEnUJO06xAeERbNEXA4tfVgZ6O65QPpJB7323FDYEIbIOcL9Hc
   kYUAeQSZhCCsAqqJhOBskMbOYPLkN0KNqBgpC9VJQVLK0ZnfaGzxVoArf
   vokfQvk7eMEeEpMOar/xN2hZIWPi6/LaL2+jzEKzU7a9KjOgEdjOG2XSU
   5nS82B2ZOhQZ3BFCCnMBdHuIAHAJ0g6bQ4pwaZ377vcJcOrOuMEq26OLg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="332532973"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="332532973"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 21:29:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="717754718"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="717754718"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.66.89.220]) ([10.66.89.220])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 21:29:48 -0700
Message-ID: <eb68e77a-518e-3b3d-4c63-2a06390cce43@linux.intel.com>
Date:   Tue, 18 Oct 2022 09:59:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH V3 net-next] net: wwan: t7xx: Add port for modem logging
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Moises Veleta <moises.veleta@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
References: <20221003095725.978129-1-m.chetan.kumar@linux.intel.com>
 <CAHNKnsT9EpOCd2Rj=5dQO5a2JrsHuyZQUG9apbrxHTehe37yug@mail.gmail.com>
 <192037d6-3b4d-d059-283b-3fa5094d5465@linux.intel.com>
 <CAHNKnsSvQNwjttQQPjKJ5aEtm6rfddrjKjd1TafcoyH1L51m-w@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <CAHNKnsSvQNwjttQQPjKJ5aEtm6rfddrjKjd1TafcoyH1L51m-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/18/2022 5:29 AM, Sergey Ryazanov wrote:
>   On Mon, Oct 17, 2022 at 1:16 PM Kumar, M Chetan
> <m.chetan.kumar@linux.intel.com> wrote:
>> On 10/16/2022 9:35 PM, Sergey Ryazanov wrote:
>>>>> On Mon, Oct 3, 2022 at 8:29 AM <m.chetan.kumar@linux.intel.com> wrote:
>>>>>> The Modem Logging (MDL) port provides an interface to collect modem
>>>>>> logs for debugging purposes. MDL is supported by the relay interface,
>>>>>> and the mtk_t7xx port infrastructure. MDL allows user-space apps to
>>>>>> control logging via mbim command and to collect logs via the relay
>>>>>> interface, while port infrastructure facilitates communication between
>>>>>> the driver and the modem.
>>>>>
>>>>> [skip]
>>>>>
>>>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
>>>>>> index dc4133eb433a..702e7aa2ef31 100644
>>>>>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>>>>>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>>>>>> @@ -122,6 +122,11 @@ struct t7xx_port {
>>>>>>           int                             rx_length_th;
>>>>>>           bool                            chan_enable;
>>>>>>           struct task_struct              *thread;
>>>>>> +#ifdef CONFIG_WWAN_DEBUGFS
>>>>>> +       void                            *relaych;
>>>>>> +       struct dentry                   *debugfs_dir;
>>>>>> +       struct dentry                   *debugfs_wwan_dir;
>>>>>
>>>>> Both of these debugfs directories are device-wide, why did you place
>>>>> these pointers in the item port context?
>>
>> I guess it was kept inside port so that it could be accessed directly
>> from port context.
>>
>> Thanks for pointing it out. I think we should move out the complete
>> #ifdef CONFIG_WWAN_DEBUGFS block of port container.
> 
> Moving out debugfs directory pointers sounds like a good idea.
> Introduction of any new debugfs knob will be a much easier if these
> pointers are available in some device-wide state container. But the
> relaych pointer looks like a logging port specific element. Why should
> it be moved out?

t7xx_port is a common port container. keeping relaych pointer inside 
port container is like having relaych pointer for all port instance 
(AT/MBIM) though it is not required for others. So planning to move out.

You suggest to keep it or move out ?

> 
>> I am planning to add trace.h file and put changes under it.
> 
> The word 'trace' usually used for entities related to use of the
> kernel tracing framework, i.e. driver itself tracing. If you really
> need this dedicated header, can we entitle it like 'mdm_log' or
> 'logging' or something like that? >
>> Below is the new code changes [1]. I am yet to verify.
>> Please share your comments.
>>
>> [1]
>> --- a/drivers/net/wwan/t7xx/t7xx_pci.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_pci.h
>> @@ -24,6 +24,7 @@
>>    #include <linux/spinlock.h>
>>    #include <linux/types.h>
>>
>> +#include "t7xx_port_trace.h"
>>    #include "t7xx_reg.h"
>>
>>    /* struct t7xx_addr_base - holds base addresses
>> @@ -59,6 +60,7 @@ typedef irqreturn_t (*t7xx_intr_callback)(int irq,
>> void *param);
>>     * @md_pm_lock: protects PCIe sleep lock
>>     * @sleep_disable_count: PCIe L1.2 lock counter
>>     * @sleep_lock_acquire: indicates that sleep has been disabled
>> + * @trace: relayfs and debugfs data struct
>>     */
>>    struct t7xx_pci_dev {
>>          t7xx_intr_callback      intr_handler[EXT_INT_NUM];
>> @@ -78,6 +80,7 @@ struct t7xx_pci_dev {
>>          spinlock_t              md_pm_lock;             /* Protects PCI resource lock */
>>          unsigned int            sleep_disable_count;
>>          struct completion       sleep_lock_acquire;
>> +       struct t7xx_trace       trace;
>>    };
>>
>>    enum t7xx_pm_id {
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h
>> b/drivers/net/wwan/t7xx/t7xx_port.h
>> index 702e7aa2ef31..dc4133eb433a 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>> @@ -122,11 +122,6 @@ struct t7xx_port {
>>          int                             rx_length_th;
>>          bool                            chan_enable;
>>          struct task_struct              *thread;
>> -#ifdef CONFIG_WWAN_DEBUGFS
>> -       void                            *relaych;
>> -       struct dentry                   *debugfs_dir;
>> -       struct dentry                   *debugfs_wwan_dir;
>> -#endif
>>    };
>>
>>    struct sk_buff *t7xx_port_alloc_skb(int payload);
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> index 894b1d11b2c9..3377573568c6 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
>> @@ -35,6 +35,7 @@
>>    #include "t7xx_modem_ops.h"
>>    #include "t7xx_port.h"
>>    #include "t7xx_port_proxy.h"
>> +#include "t7xx_port_trace.h"
>>    #include "t7xx_state_monitor.h"
>>
>>    #define Q_IDX_CTRL                    0
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> index 81d059fbc0fb..c537f5b5ff60 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
>> @@ -87,9 +87,6 @@ struct ctrl_msg_header {
>>    extern struct port_ops wwan_sub_port_ops;
>>    extern struct port_ops ctl_port_ops;
>>
>> -#ifdef CONFIG_WWAN_DEBUGFS
>> -extern struct port_ops t7xx_trace_port_ops;
>> -#endif
>>
>>    void t7xx_port_proxy_reset(struct port_proxy *port_prox);
>>    void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
>>
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_trace.h
>> @@ -0,0 +1,21 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2022 Intel Corporation.
>> + */
>> +
>> +#ifndef __T7XX_PORT_TRACE_H__
>> +#define __T7XX_PORT_TRACE_H__
>> +
>> +struct t7xx_trace {
>> +#ifdef CONFIG_WWAN_DEBUGFS
>> +        void                            *relaych;
>> +        struct dentry                   *debugfs_dir;
>> +        struct dentry                   *debugfs_wwan_dir;
>> +#endif
>> +};
> 
> The relaych pointer is port specific, so it can be left in the port
> structure. We do not need to keep the debugfs_dir pointer. It is only
> needed during debugfs initialization to create the modem-specific
> subdirectory. So it can be a local variable. There is only one
> debugfs_wwan_dir pointer left, which can be placed somewhere in the
> t7xx_modem structure.

Ok. Will drop debugfs_dir and use local var instead.

> 
>> +#ifdef CONFIG_WWAN_DEBUGFS
>> +extern struct port_ops t7xx_trace_port_ops;
>> +#endif
>> +
>> +#endif /* __T7XX_PORT_TRACE_H__ */
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port_trace.c
>> b/drivers/net/wwan/t7xx/t7xx_port_trace.c
>> index 3f740db318a8..1f5224fb0e5d 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port_trace.c
>> +++ b/drivers/net/wwan/t7xx/t7xx_port_trace.c
>> @@ -10,6 +10,7 @@
>>
>>    #include "t7xx_port.h"
>>    #include "t7xx_port_proxy.h"
>> +#include "t7xx_port_trace.h"
>>    #include "t7xx_state_monitor.h"
>>
>>    #define T7XX_TRC_SUB_BUFF_SIZE                131072
>> @@ -51,19 +52,19 @@ static struct rchan_callbacks relay_callbacks = {
>>
>>    static void t7xx_trace_port_uninit(struct t7xx_port *port)
>>    {
>> -       struct rchan *relaych = port->relaych;
>> +       struct t7xx_trace *trace = &port->t7xx_dev->trace;
>>
>> -       if (!relaych)
>> +       if (!trace->relaych)
>>                  return;
>>
>> -       relay_close(relaych);
>> -       debugfs_remove_recursive(port->debugfs_dir);
>> -       wwan_put_debugfs_dir(port->debugfs_wwan_dir);
>> +       relay_close(trace->relaych);
>> +       debugfs_remove_recursive(trace->debugfs_dir);
>> +       wwan_put_debugfs_dir(trace->debugfs_wwan_dir);
>>    }
>>
>>    static int t7xx_trace_port_recv_skb(struct t7xx_port *port, struct
>> sk_buff *skb)
>>    {
>> -       struct rchan *relaych = port->relaych;
>> +       struct rchan *relaych = port->t7xx_dev->trace.relaych;
>>
>>          if (!relaych)
>>                  return -EINVAL;
>> @@ -75,33 +76,34 @@ static int t7xx_trace_port_recv_skb(struct t7xx_port
>> *port, struct sk_buff *skb)
>>
>>    static void t7xx_port_trace_md_state_notify(struct t7xx_port *port,
>> unsigned int state)
>>    {
>> +       struct t7xx_trace *trace = &port->t7xx_dev->trace;
>>          struct rchan *relaych;
>>
>> -       if (state != MD_STATE_READY || port->relaych)
>> +       if (state != MD_STATE_READY || trace->relaych)
>>                  return;
>>
>> -       port->debugfs_wwan_dir = wwan_get_debugfs_dir(port->dev);
>> -       if (IS_ERR(port->debugfs_wwan_dir))
>> +       trace->debugfs_wwan_dir = wwan_get_debugfs_dir(port->dev);
>> +       if (IS_ERR(trace->debugfs_wwan_dir))
>>                  return;
>>
>> -       port->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
>> port->debugfs_wwan_dir);
>> -       if (IS_ERR_OR_NULL(port->debugfs_dir)) {
>> -               wwan_put_debugfs_dir(port->debugfs_wwan_dir);
>> +       trace->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
>> trace->debugfs_wwan_dir);
>> +       if (IS_ERR_OR_NULL(trace->debugfs_dir)) {
>> +               wwan_put_debugfs_dir(trace->debugfs_wwan_dir);
>>                  dev_err(port->dev, "Unable to create debugfs for trace");
>>                  return;
>>          }
>>
>> -       relaych = relay_open("relay_ch", port->debugfs_dir,
>> T7XX_TRC_SUB_BUFF_SIZE,
>> +       relaych = relay_open("relay_ch", trace->debugfs_dir,
>> T7XX_TRC_SUB_BUFF_SIZE,
>>                               T7XX_TRC_N_SUB_BUFF, &relay_callbacks, NULL);
>>          if (!relaych)
>>                  goto err_rm_debugfs_dir;
>>
>> -       port->relaych = relaych;
>> +       trace->relaych = relaych;
>>          return;
>>
>>    err_rm_debugfs_dir:
>> -       debugfs_remove_recursive(port->debugfs_dir);
>> -       wwan_put_debugfs_dir(port->debugfs_wwan_dir);
>> +       debugfs_remove_recursive(trace->debugfs_dir);
>> +       wwan_put_debugfs_dir(trace->debugfs_wwan_dir);
>>          dev_err(port->dev, "Unable to create trace port %s",
>> port->port_conf->name);
>>    }
> 

-- 
Chetan
