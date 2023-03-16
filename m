Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647636BDCC0
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCPXQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCPXQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:16:54 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDB77C3EA;
        Thu, 16 Mar 2023 16:16:47 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id i24so3653291qtm.6;
        Thu, 16 Mar 2023 16:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679008607;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SAIs38N3Vf6Rsk3wVHbbNIhsOc/uxAB2XEYp0vo3k7o=;
        b=AVLaWnjOM0cD4SiJEhCpaX/tPD6gsAeB2c7GILlg3MuCqn93wORf9ogTJnqmuduhID
         J26s57iXZLvW6IFU5Hbl0hnCP6WF6diCMlckAVyVPCvBlqpx+mY5EaWAriSMnYa2CUGW
         XRQ/5AkZFBgLZJqMsuvHEwLJhGAqrMgHFbcg03TwjCpJJUZ709ZvdpI4FxOLaHlIgmrc
         RjqeRk4ekaUjfS4hafQ/beZkeZNmrLv2e8eSkjnSKhqaqSut1Rkxv6YeE3earXAcr2yb
         0OizYIsPfcTq2PK8WWQYFqGEbMWIE1P6e4Nl+T5PG/FCkMPTtflTMkByk9iWoK6/RVVa
         sN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679008607;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAIs38N3Vf6Rsk3wVHbbNIhsOc/uxAB2XEYp0vo3k7o=;
        b=ThaxiuArlMqmbL2Y3d56kXDNC8N7ZYmWfUiy4klZU5hANFBixV182HZEt0h7VXzPQM
         X/85JQw6MD4g0yzy0DcneA4eeE3iXjtp7Du6RlXVkCmH7alR/KycyEDgA34TXLnxvhqr
         Pjy56WvcaER3nPov+vkQp/+OLkUZboNhlMjqG5BxsfMD/zevYKP/H+c8s/cWXgOfcbJ7
         /lgTbgkva3GqimbClWFrvSzuMOaYazOrKtRrgMlZbH6EjF64aaBuvro+uMZVj/Ii6qz6
         aMAb5bVaaMZqXXF3mR/tut7OgMzp6ExC1dXtAQgsp6api4eA557rWEE9Aif1VWkW463C
         0HoA==
X-Gm-Message-State: AO0yUKWDvQYcD6gI8g5gvSLhnkr669UY674cqsAXrf+f1TXbrgqV66Mh
        DyvyNfOaGSB3SDUnGxPspStzRT8bX9k=
X-Google-Smtp-Source: AK7set+TWsTHdracVjbBZOlrQJu7ldp2knn541wF2nUgoe4hVVNB9eywa3e4xMzYT4IUXtI8Cc+Lhw==
X-Received: by 2002:a05:622a:50a:b0:3d4:3d6c:a62b with SMTP id l10-20020a05622a050a00b003d43d6ca62bmr9460134qtx.27.1679008607036;
        Thu, 16 Mar 2023 16:16:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j11-20020ac874cb000000b003b0766cd169sm530841qtr.2.2023.03.16.16.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 16:16:46 -0700 (PDT)
Message-ID: <8da9b24b-966a-0334-d322-269b103f7550@gmail.com>
Date:   Thu, 16 Mar 2023 16:16:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
References: <20230315223044.471002-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315223044.471002-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 15:30, Jakub Kicinski wrote:
> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> ---
>   .../device_drivers/ethernet/intel/e100.rst    |   3 +-
>   .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
>   .../device_drivers/ethernet/intel/ixgb.rst    |   4 +-
>   Documentation/networking/index.rst            |   1 +
>   Documentation/networking/napi.rst             | 231 ++++++++++++++++++
>   include/linux/netdevice.h                     |  13 +-
>   6 files changed, 244 insertions(+), 12 deletions(-)
>   create mode 100644 Documentation/networking/napi.rst
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/e100.rst b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
> index 3d4a9ba21946..371b7e5c3293 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/e100.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
> @@ -151,8 +151,7 @@ NAPI
>   
>   NAPI (Rx polling mode) is supported in the e100 driver.
>   
> -See https://wiki.linuxfoundation.org/networking/napi for more
> -information on NAPI.
> +See :ref:`Documentation/networking/napi.rst <napi>` for more information.
>   
>   Multiple Interfaces on Same Ethernet Broadcast Network
>   ------------------------------------------------------
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
> index ac35bd472bdc..c495c4e16b3b 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
> @@ -399,8 +399,8 @@ operate only in full duplex and only at their native speed.
>   NAPI
>   ----
>   NAPI (Rx polling mode) is supported in the i40e driver.
> -For more information on NAPI, see
> -https://wiki.linuxfoundation.org/networking/napi
> +
> +See :ref:`Documentation/networking/napi.rst <napi>` for more information.
>   
>   Flow Control
>   ------------
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
> index c6a233e68ad6..90ddbc912d8d 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
> @@ -367,9 +367,7 @@ NAPI
>   ----
>   NAPI (Rx polling mode) is supported in the ixgb driver.
>   
> -See https://wiki.linuxfoundation.org/networking/napi for more information on
> -NAPI.
> -
> +See :ref:`Documentation/networking/napi.rst <napi>` for more information.
>   
>   Known Issues/Troubleshooting
>   ============================
> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index 4ddcae33c336..24bb256d6d53 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -73,6 +73,7 @@ Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
>      mpls-sysctl
>      mptcp-sysctl
>      multiqueue
> +   napi
>      netconsole
>      netdev-features
>      netdevices
> diff --git a/Documentation/networking/napi.rst b/Documentation/networking/napi.rst
> new file mode 100644
> index 000000000000..4d87032a7e9e
> --- /dev/null
> +++ b/Documentation/networking/napi.rst
> @@ -0,0 +1,231 @@
> +.. _napi:
> +
> +====
> +NAPI
> +====
> +
> +NAPI is the event handling mechanism used by the Linux networking stack.
> +The name NAPI does not stand for anything in particular.

Did it not stand for New API?

> +
> +In basic operation device notifies the host about new events via an interrupt.
> +The host then schedules a NAPI instance to process the events.
> +Device may also be polled for events via NAPI without receiving
> +an interrupts first (busy polling).

s/an//

> +
> +NAPI processing usually happens in the software interrupt context,
> +but user may choose to use separate kernel threads for NAPI processing.

(called threaded NAPI)

> +
> +All in all NAPI abstracts away from the drivers the context and configuration
> +of event (packet Rx and Tx) processing.
> +
> +Driver API
> +==========
> +
> +The two most important elements of NAPI are the struct napi_struct
> +and the associated poll method. struct napi_struct holds the state
> +of the NAPI instance while the method is the driver-specific event
> +handler. The method will typically free Tx packets which had been
> +transmitted and process newly received packets.
> +
> +.. _drv_ctrl:
> +
> +Control API
> +-----------
> +
> +netif_napi_add() and netif_napi_del() add/remove a NAPI instance
> +from the system. The instances are attached to the netdevice passed
> +as argument (and will be deleted automatically when netdevice is
> +unregistered). Instances are added in a disabled state.
> +
> +napi_enable() and napi_disable() manage the disabled state.
> +A disabled NAPI can't be scheduled and its poll method is guaranteed
> +to not be invoked. napi_disable() waits for ownership of the NAPI
> +instance to be released.

Might add a word that calling napi_disable() twice will deadlock? This 
seems to be a frequent trap driver authors fall into.

> +
> +Datapath API
> +------------
> +
> +napi_schedule() is the basic method of scheduling a NAPI poll.
> +Drivers should call this function in their interrupt handler
> +(see :ref:`drv_sched` for more info). Successful call to napi_schedule()
> +will take ownership of the NAPI instance.
> +
> +Some time after NAPI is scheduled driver's poll method will be
> +called to process the events/packets. The method takes a ``budget``
> +argument - drivers can process completions for any number of Tx
> +packets but should only process up to ``budget`` number of
> +Rx packets. Rx processing is usually much more expensive.

In other words, it is recommended to ignore the budget argument when 
performing TX buffer reclamation to ensure that the reclamation is not 
arbitrarily bounded, however it is required to honor the budget argument 
for RX processing.

> +
> +.. warning::
> +
> +   ``budget`` may be 0 if core tries to only process Tx completions
> +   and no Rx packets.
> +
> +The poll method returns amount of work performed.

returns the amount of work.

> If driver still

If the driver

> +has outstanding work to do (e.g. ``budget`` was exhausted)
> +the poll method should return exactly ``budget``. In that case
> +the NAPI instance will be serviced/polled again (without the
> +need to be scheduled).
> +
> +If event processing has been completed (all outstanding packets
> +processed) the poll method should call napi_complete_done()
> +before returning. napi_complete_done() releases the ownership
> +of the instance.
> +
> +.. warning::
> +
> +   The case of finishing all events and using exactly ``budget``
> +   must be handled carefully. There is no way to report this
> +   (rare) condition to the stack, so the driver must either
> +   not call napi_complete_done() and wait to be called again,
> +   or return ``budget - 1``.
> +
> +   If ``budget`` is 0 napi_complete_done() should never be called.

Can we detail when budget may be 0?

> +
> +Call sequence
> +-------------
> +
> +Drivers should not make assumptions about the exact sequencing
> +of calls. The poll method may be called without driver scheduling
> +the instance (unless the instance is disabled). Similarly if
> +it's not guaranteed that the poll method will be called, even
> +if napi_schedule() succeeded (e.g. if the instance gets disabled).

You lost me there, it seems to me that what you mean to say is that:

- drivers should ensure that past the point where they call 
netif_napi_add(), any software context referenced by the NAPI poll 
function should be fully set-up

- it is not guaranteed that the NAPI poll function will not be called 
once netif_napi_disable() returns

> +
> +As mentioned in the :ref:`drv_ctrl` section - napi_disable() and subsequent
> +calls to the poll method only wait for the ownership of the instance
> +to be released, not for the poll method to exit. This means that
> +drivers should avoid accessing any data structures after calling
> +napi_complete_done().
> +
> +.. _drv_sched:
> +
> +Scheduling and IRQ masking
> +--------------------------
> +
> +Drivers should keep the interrupts masked after scheduling
> +the NAPI instance - until NAPI polling finishes any further
> +interrupts are unnecessary.
> +
> +Drivers which have to mask the interrupts explicitly (as opposed
> +to IRQ being auto-masked by the device) should use the napi_schedule_prep()
> +and __napi_schedule() calls:
> +
> +.. code-block:: c
> +
> +  if (napi_schedule_prep(&v->napi)) {
> +      mydrv_mask_rxtx_irq(v->idx);
> +      /* schedule after masking to avoid races */
> +      __napi_schedule(&v->napi);
> +  }
> +
> +IRQ should only be unmasked after successful call to napi_complete_done():
> +
> +.. code-block:: c
> +
> +  if (budget && napi_complete_done(&v->napi, work_done)) {
> +    mydrv_unmask_rxtx_irq(v->idx);
> +    return min(work_done, budget - 1);
> +  }
> +
> +napi_schedule_irqoff() is a variant of napi_schedule() which takes advantage
> +of guarantees given by being invoked in IRQ context (no need to
> +mask interrupts). Note that PREEMPT_RT forces all interrupts
> +to be threaded so the interrupt may need to be marked ``IRQF_NO_THREAD``
> +to avoid issues on real-time kernel configurations.
> +
> +Instance to queue mapping
> +-------------------------
> +
> +Modern devices have multiple NAPI instances (struct napi_struct) per
> +interface. There is no strong requirement on how the instances are
> +mapped to queues and interrupts. NAPI is primarily a polling/processing
> +abstraction without many user-facing semantics. That said, most networking
> +devices end up using NAPI is fairly similar ways.

s/is/in/

> +
> +NAPI instances most often correspond 1:1:1 to interrupts and queue pairs
> +(queue pair is a set of a single Rx and single Tx queue).

correspond to.

> +
> +In less common cases a NAPI instance may be used for multiple queues
> +or Rx and Tx queues can be serviced by separate NAPI instances on a single
> +core. Regardless of the queue assignment, however, there is usually still
> +a 1:1 mapping between NAPI instances and interrupts.
> +
> +It's worth noting that the ethtool API uses a "channel" terminology where
> +each channel can be either ``rx``, ``tx`` or ``combined``. It's not clear
> +what constitutes a channel, the recommended interpretation is to understand
> +a channel as an IRQ/NAPI which services queues of a given type. For example
> +a configuration of 1 ``rx``, 1 ``tx`` and 1 ``combined`` channel is expected
> +to utilize 3 interrupts, 2 Rx and 2 Tx queues.
> +
> +User API
> +========
> +
> +User interactions with NAPI depend on NAPI instance ID. The instance IDs
> +are only visible to the user thru the ``SO_INCOMING_NAPI_ID`` socket option.
> +It's not currently possible to query IDs used by a given device.
> +
> +Software IRQ coalescing
> +-----------------------
> +
> +NAPI does not perform any explicit event coalescing by default.
> +In most scenarios batching happens due to IRQ coalescing which is done
> +by the device. There are cases where software coalescing is helpful.
> +
> +NAPI can be configured to arm a repoll timer instead of unmasking
> +the hardware interrupts as soon as all packets are processed.
> +The ``gro_flush_timeout`` sysfs configuration of the netdevice
> +is reused to control the delay of the timer, while
> +``napi_defer_hard_irqs`` controls the number of consecutive empty polls
> +before NAPI gives up and goes back to using hardware IRQs.
> +
> +Busy polling
> +------------
> +
> +Busy polling allows user process to check for incoming packets before
> +device interrupt fires.

the device

> As is the case with any busy polling it trades
> +off CPU cycles for lower latency (in fact production uses of NAPI busy
> +polling are not well known).

Did not this originate via Intel at the request of financial companies 
doing high speed trading? Have they moved entirely away from busy 
polling nowadays?

> +
> +User can enable busy polling by either setting ``SO_BUSY_POLL`` on
> +selected sockets or using the global ``net.core.busy_poll`` and
> +``net.core.busy_read`` sysctls. An io_uring API for NAPI busy polling
> +also exists.
> +
> +IRQ mitigation
> +---------------
> +
> +While busy polling is supposed to be used by low latency applications,
> +a similar mechanism can be used for IRQ mitigation.
> +
> +Very high request-per-second applications (especially routing/forwarding
> +applications and especially applications using AF_XDP sockets) may not
> +want to be interrupted until they finish processing a request or a batch
> +of packets.
> +
> +Such applications can pledge to the kernel that they will perform a busy
> +polling operation periodically, and the driver should keep the device IRQs
> +permanently masked. This mode is enabled by using the ``SO_PREFER_BUSY_POLL``
> +socket option. To avoid the system misbehavior the pledge is revoked
> +if ``gro_flush_timeout`` passes without any busy poll call.
> +
> +The NAPI budget for busy polling is lower than the default (which makes
> +sense given the low latency intention of normal busy polling). This is
> +not the case with IRQ mitigation, however, so the budget can be adjusted
> +with the ``SO_BUSY_POLL_BUDGET`` socket option.
> +
> +Threaded NAPI
> +-------------
> +
> +Use dedicated kernel threads rather than software IRQ context for NAPI
> +processing. 

Uses

> The configuration is per netdevice and will affect all
> +NAPI instances of that device. Each NAPI instance will spawn a separate
> +thread (called ``napi/${ifc-name}-${napi-id}``).
> +
> +It is recommended to pin each kernel thread to a single CPU, the same
> +CPU as services the interrupt. Note that the mapping between IRQs and
> +NAPI instances may not be trivial (and is driver dependent).
> +The NAPI instance IDs will be assigned in the opposite order
> +than the process IDs of the kernel threads.

Device drivers may opt for threaded NAPI behavior by default by calling 
dev_set_threaded(.., true)
-- 
Florian

