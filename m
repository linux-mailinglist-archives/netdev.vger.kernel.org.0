Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CE86C540D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjCVSsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjCVSsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:48:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE9049D8;
        Wed, 22 Mar 2023 11:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=Hi6cW9mbgSQ8QrMeqRCkrBq4Y0ODL140WKXwW2zZRPc=; b=CIa1BvQ9jOGSVPp89geAsoktmp
        0G+7IMk+qrq7pW+Wx/eKAnQbmR4FXbofMWbRaLSffYk+neEgKOzKiNz6F9FjeYFXacEgr8M8NkSFh
        pqGLIYIGiue8jsciiESDriYfhk4yHl6wVeCZXrvryglUhyl1CxB5CCwO//fDd6kUtsomeGgDmylcP
        wtAvA3+NkJIWwS48lnDhAeuDdmFKDDL7OYc7AGbBPJsgefxX9gWoOFtDwXIUnqKtgw9xc0+akVo+9
        aI8F5slZ6kdjUq4ZbWv5kBDVCazwUFxpjzzGkUY+wS58fphaHcy8yAwLHirGuw8KmiYKspMqsIY6z
        INImj2gw==;
Received: from [2601:1c2:980:9ec0::21b4]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pf3V4-00H4G6-1a;
        Wed, 22 Mar 2023 18:47:54 +0000
Message-ID: <697d9ed8-a9bd-cfc9-35a0-c1d8649a571a@infradead.org>
Date:   Wed, 22 Mar 2023 11:47:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3] docs: networking: document NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>, corbet@lwn.net,
        jesse.brandeburg@intel.com, mkl@pengutronix.de,
        linux-doc@vger.kernel.org, stephen@networkplumber.org,
        romieu@fr.zoreil.com
References: <20230322053848.198452-1-kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230322053848.198452-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I have a few comments for your consideration.

On 3/21/23 22:38, Jakub Kicinski wrote:
> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://lore.kernel.org/all/20230315223044.471002-1-kuba@kernel.org/
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz> # for ctucanfd-driver.rst
> Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> v3: rebase on net-next (to avoid ixgb conflict)
>     fold in grammar fixes from Stephen
> v2: https://lore.kernel.org/all/20230321050334.1036870-1-kuba@kernel.org/
>     remove the links in CAN and in ICE as well
>     improve the start of the threaded NAPI section
>     name footnote
>     internal links from the intro to sections
>     various clarifications from Florian and Stephen
> 
> CC: corbet@lwn.net
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: pisa@cmp.felk.cvut.cz
> CC: mkl@pengutronix.de
> CC: linux-doc@vger.kernel.org
> CC: f.fainelli@gmail.com
> CC: stephen@networkplumber.org
> CC: romieu@fr.zoreil.com
> ---
>  .../can/ctu/ctucanfd-driver.rst               |   3 +-
>  .../device_drivers/ethernet/intel/e100.rst    |   3 +-
>  .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
>  .../device_drivers/ethernet/intel/ice.rst     |   4 +-
>  Documentation/networking/index.rst            |   1 +
>  Documentation/networking/napi.rst             | 251 ++++++++++++++++++
>  include/linux/netdevice.h                     |  13 +-
>  7 files changed, 266 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/networking/napi.rst


> diff --git a/Documentation/networking/napi.rst b/Documentation/networking/napi.rst
> new file mode 100644
> index 000000000000..4f848d86750c
> --- /dev/null
> +++ b/Documentation/networking/napi.rst
> @@ -0,0 +1,251 @@
> +.. _napi:
> +
> +====
> +NAPI
> +====
> +
> +NAPI is the event handling mechanism used by the Linux networking stack.
> +The name NAPI no longer stands for anything in particular [#]_.
> +
> +In basic operation device notifies the host about new events via an interrupt.

                     {a | the} device

> +The host then schedules a NAPI instance to process the events.
> +Device may also be polled for events via NAPI without receiving

A device may also be
The device may also be
Devices may also be

> +interrupts first (:ref:`busy polling<poll>`).
> +
> +NAPI processing usually happens in the software interrupt context,
> +but there is an option to use :ref:`separate kernel threads<threaded>`
> +for NAPI processing.
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
> +handler. The method will typically free Tx packets that have been
> +transmitted and process newly received packets.
> +
> +.. _drv_ctrl:
> +
> +Control API
> +-----------
> +

[snip]

> +
> +Datapath API
> +------------
> +
> +napi_schedule() is the basic method of scheduling a NAPI poll.
> +Drivers should call this function in their interrupt handler
> +(see :ref:`drv_sched` for more info). A successful call to napi_schedule()
> +will take ownership of the NAPI instance.
> +
> +Later, after NAPI is scheduled, the driver's poll method will be
> +called to process the events/packets. The method takes a ``budget``
> +argument - drivers can process completions for any number of Tx
> +packets but should only process up to ``budget`` number of
> +Rx packets. Rx processing is usually much more expensive.
> +
> +In other words, it is recommended to ignore the budget argument when
> +performing TX buffer reclamation to ensure that the reclamation is not
> +arbitrarily bounded, however, it is required to honor the budget argument

               bounded; however
or
               bounded. However

> +for RX processing.
> +
> +.. warning::
> +
> +   The ``budget`` argument may be 0 if core tries to only process Tx completions
> +   and no Rx packets.
> +
> +The poll method returns the amount of work done. If the driver still
> +has outstanding work to do (e.g. ``budget`` was exhausted)
> +the poll method should return exactly ``budget``. In that case,

So it return the original 'budget' parameter value that was passed in to it?

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
> +   If the ``budget`` is 0 napi_complete_done() should never be called.
> +
> +Call sequence
> +-------------
> +

[snip]
> +
> +.. _drv_sched:
> +
> +Scheduling and IRQ masking
> +--------------------------
> +

[snip]

> +
> +Instance to queue mapping
> +-------------------------
> +
> +Modern devices have multiple NAPI instances (struct napi_struct) per
> +interface. There is no strong requirement on how the instances are
> +mapped to queues and interrupts. NAPI is primarily a polling/processing
> +abstraction without specific user-facing semantics. That said, most networking
> +devices end up using NAPI in fairly similar ways.
> +
> +NAPI instances most often correspond 1:1:1 to interrupts and queue pairs
> +(queue pair is a set of a single Rx and single Tx queue).
> +
> +In less common cases a NAPI instance may be used for multiple queues
> +or Rx and Tx queues can be serviced by separate NAPI instances on a single
> +core. Regardless of the queue assignment, however, there is usually still
> +a 1:1 mapping between NAPI instances and interrupts.
> +
> +It's worth noting that the ethtool API uses a "channel" terminology where
> +each channel can be either ``rx``, ``tx`` or ``combined``. It's not clear
> +what constitutes a channel, the recommended interpretation is to understand

                      channel;

> +a channel as an IRQ/NAPI which services queues of a given type. For example,
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

[snip]

> +
> +.. _poll:
> +
> +Busy polling
> +------------
> +
> +Busy polling allows user process to check for incoming packets before

                allows a user process
or
                allows user processes

> +the device interrupt fires. As is the case with any busy polling it trades
> +off CPU cycles for lower latency (in fact production uses of NAPI busy

I would drop "in fact".

> +polling are not well known).
> +
> +Busy polling is enabled by either setting ``SO_BUSY_POLL`` on
> +selected sockets or using the global ``net.core.busy_poll`` and
> +``net.core.busy_read`` sysctls. An io_uring API for NAPI busy polling
> +also exists.
> +
> +IRQ mitigation
> +---------------
> +

[snip]

and in any case:
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.
-- 
~Randy
