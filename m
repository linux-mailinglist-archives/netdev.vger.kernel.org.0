Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C52219F7C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 14:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgGIMAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 08:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgGIMAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 08:00:02 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562AEC061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 05:00:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d10so751418pls.5
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 05:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aS3jVgNixUAZWn5i2euhSd/DQlWGFdWfgDzJKo3EQoA=;
        b=Tt6V26dTlyvzVDDHTLxtjLsZ1SXPCMcf0ATDHaM7CrsU+KwLGLqXIlc/pg7+yL72tS
         BUA3R06o3aDiPHzZz8UaCKhlLnJ0oepvDJn5fwTx8yHRbw5QliVFTOF16xPJrUL3voGe
         gy7CfwgWliEMcvVuhzCwJOkVqPffIp7qGhuobw0w5TMi03xApFelCkdQzI+fcOcLc9Kq
         MPJ/CtBEJm5hUXFPj35mZJndejzLUHQ3/tHpEW8bvi5SZ1MHIyLQFy5Jm6TN1jGhFejM
         BuDA2NppApZxQjM6pr8FZYaIaQofNY0dWankoh8fVYAEE4i5k6sualE+f0umR3CRnYIz
         lEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aS3jVgNixUAZWn5i2euhSd/DQlWGFdWfgDzJKo3EQoA=;
        b=bhz1RHkFHN9Fh8ztg4bAbbTBP2H4OWCMKA0sIUEIf4g0TdfYH3OznSJG5piDBxiyn8
         ABhQRKZzC2WqU9lkGX9usBdmonTu29iHOvKqQUALPTTLF6wEIn6uFauJwBwC1nk9Z9ay
         qeAYjgMKvmy3ZHAPmqxf4ryZE1JOAZkUQI1rU0xMdOc3gBP+L7VPbnggZzucczxd4cnB
         5ibTPb6Rkhx2bgt1/iPekfibrHMjXxkkFdAPq8uDiKp2QzynChc3L06alk2iP2Ql6t1n
         maqmSkGIq8ho+nPe2r1CntQH6fjV3HcP1FzyeuLD009u0DUxpJRT5GcSkm2deK1m05vY
         VlkA==
X-Gm-Message-State: AOAM532TUGRANyLM1mdXw6c6GqdtjbqxmddKnFPlv9QvDFGgV+O6vUJy
        eyujPFCN4MGXWCnL/MLz5cg=
X-Google-Smtp-Source: ABdhPJwYXFoKiD6sH2pCZpb2nvc5HPoOJEvvQNaGXzTCRnS3d5s7WVEv5ib3lNOCWRpjbX3/xP5E4A==
X-Received: by 2002:a17:902:7083:: with SMTP id z3mr28568058plk.156.1594296001687;
        Thu, 09 Jul 2020 05:00:01 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e15sm2584653pgt.17.2020.07.09.05.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 05:00:00 -0700 (PDT)
Date:   Thu, 9 Jul 2020 04:59:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, sorganov@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH] docs: networking: timestamping: add section for stacked
 PHC devices
Message-ID: <20200709115958.GB776@hoboy>
References: <20200708205621.1463971-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708205621.1463971-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 11:56:21PM +0300, Vladimir Oltean wrote:
> The concept of timestamping DSA switches / Ethernet PHYs is becoming
> more and more popular, however the Linux kernel timestamping code has
> evolved quite organically and there's layers upon layers of new and old
> code that need to work together for things to behave as expected.
> 
> Add this chapter to explain what the overall goals are.

This is great.  I have one correction and a few formatting and style
suggestions, below.  With the correction in place,

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

> Loosely based upon this email discussion plus some more info:
> https://lkml.org/lkml/2020/7/6/481
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  Documentation/networking/timestamping.rst | 149 ++++++++++++++++++++++
>  1 file changed, 149 insertions(+)
> 
> diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> index 1adead6a4527..14df58c24e8c 100644
> --- a/Documentation/networking/timestamping.rst
> +++ b/Documentation/networking/timestamping.rst
> @@ -589,3 +589,152 @@ Time stamps for outgoing packets are to be generated as follows:
>    this would occur at a later time in the processing pipeline than other
>    software time stamping and therefore could lead to unexpected deltas
>    between time stamps.
> +
> +3.2 Special considerations for stacked PTP Hardware Clocks
> +----------------------------------------------------------
> +
> +There are situations when there may be more than one PHC (PTP Hardware Clock)
> +in the data path of a packet. The kernel has no explicit mechanism to allow the
> +user to select which PHC to use for timestamping Ethernet frames. Instead, the
> +assumption is that the outermost PHC is always the most preferable, and that
> +kernel drivers collaborate towards achieving that goal. Currently there are 3
> +cases of stacked PHCs, detailed below:
> +
> +- DSA (Distributed Switch Architecture) switches.

For readability, please start a new paragraph here.

     These are Ethernet switches
> +  which have one of their ports connected to an (otherwise completely unaware)
> +  host Ethernet interface, and perform the role of a port multiplier with
> +  optional forwarding acceleration features.  Each DSA switch port is visible
> +  to the user as a standalone (virtual) network interface, however network I/O
> +  is performed under the hood indirectly through the host interface.

new paragraph.

> +  When a DSA switch is attached to a host port, PTP synchronization has to
> +  suffer, since the switch's variable queuing delay introduces a path delay
> +  jitter between the host port and its PTP partner. For this reason, some DSA
> +  switches include a timestamping clock of their own, and have the ability to
> +  perform network timestamping on their own MAC, such that path delays only
> +  measure wire and PHY propagation latencies. Timestamping DSA switches are
> +  supported in Linux and expose the same ABI as any other network interface
> +  (save for the fact that the DSA interfaces are in fact virtual in terms of
> +  network I/O, they do have their own PHC).  It is typical, but not mandatory,
> +  for all interfaces of a DSA switch to share the same PHC.

new paragraph.

     By design, PTP
> +  timestamping with a DSA switch does not need any special handling in the
> +  driver for the host port it is attached to.  However, when the host port also
> +  supports PTP timestamping, DSA will take care of intercepting the
> +  ``.ndo_do_ioctl`` calls towards the host port, and block attempts to enable
> +  hardware timestamping on it. This is because the SO_TIMESTAMPING API does not
> +  allow the delivery of multiple hardware timestamps for the same packet, so
> +  anybody else except for the DSA switch port must be prevented from doing so.

new paragraph.

> +  In code, DSA provides for most of the infrastructure for timestamping
> +  already, in generic code: a BPF classifier (``ptp_classify_raw``) is used to
> +  identify PTP event messages (any other packets, including PTP general
> +  messages, are not timestamped), and provides two hooks to drivers:
> +
> +    - ``.port_txtstamp()``: A clone of the timestampable skb to be transmitted,
> +      before actually transmitting it. Typically, a switch will have a PTP TX

"A clone of the ..."  is not a sentence.

> +      timestamp register (or sometimes a FIFO) where the timestamp becomes
> +      available. There may be an IRQ that is raised upon this timestamp's
> +      availability, or the driver might have to poll after invoking
> +      ``dev_queue_xmit()`` towards the host interface. Either way, in the
> +      ``.port_txtstamp()`` method, the driver only needs to save the clone for
> +      later use (when the timestamp becomes available). Each skb is annotated
> +      with a pointer to its clone, in ``DSA_SKB_CB(skb)->clone``, to ease the
> +      driver's job of keeping track of which clone belongs to which skb.
> +
> +   - ``.port_rxtstamp()``: The original (and only) timestampable skb is
> +     provided to the driver, for it to annotate it with a timestamp, if that is
> +     immediately available, or defer to later. On reception, timestamps might
> +     either be available in-band (through metadata in the DSA header, or
> +     attached in other ways to the packet), or out-of-band (through another RX
> +     timestamping FIFO). Deferral on RX is typically necessary when retrieving
> +     the timestamp needs a sleepable context. In that case, it is the
> +     responsibility of the driver to call ``netif_rx_ni()`` on the freshly

responsibility of the *DSA* driver

> +     timestamped skb.
> +
> +
> +- Ethernet PHYs.

new paragraph.

     These are devices that typically fulfill a Layer 1 role in the
> +  network stack, hence they do not have a representation in terms of a network
> +  interface as DSA switches do. However, PHYs may be able to detect and
> +  timestamp PTP packets, for performance reasons: timestamps taken as close as
> +  possible to the wire have the potential to yield a more stable and precise
> +  synchronization.
> +  A PHY driver that supports PTP timestamping must create a ``struct
> +  mii_timestamper`` and add a pointer to it in ``phydev->mii_ts``. The presence
> +  of this pointer will be checked by the networking stack.

new paragraph.

> +  Since PHYs do not have network interface representations, the timestamping
> +  and ethtool ioctl operations for them need to be mediated by their respective
> +  MAC driver. Therefore, as opposed to DSA switches, modifications need to be
> +  done to each individual MAC driver for PHY timestamping support. This
> +  entails:
> +
> +    - Checking, in ``.ndo_do_ioctl``, whether
> +      ``phy_has_hwtstamp(netdev->phydev)`` is true or not. If it is, then the MAC
> +      driver should not process this request but instead pass it on to the PHY
> +      using ``phy_mii_ioctl()``.
> +
> +    - Checking, before delivering received skb's up the network stack (using
> +      ``napi_gro_receive`` or similar), whether ``skb_defer_rx_timestamp(skb)``
> +      is necessary or not - and if it is, don't call ``napi_gro_receive`` at all.

Actually, only drivers that use the traditional netif_rx() will need
to call skb_defer_rx_timestamp().

In the specific case of napi_gro_receive, we have:

napi_gro_receive
 napi_skb_finish
  gro_normal_one
   gro_normal_list
    netif_receive_skb_list_internal
     if (!skb_defer_rx_timestamp(skb))
      ...

The stack automatically also checks skb_defer_rx_timestamp() in other
cases, for example:

netif_receive_skb
 ret = netif_receive_skb_internal(skb);
  if (skb_defer_rx_timestamp(skb))
   return NET_RX_SUCCESS;

> +      If ``CONFIG_NETWORK_PHY_TIMESTAMPING`` is enabled, and
> +      ``skb->dev->phydev->mii_ts`` exists, its ``.rxtstamp()`` hook will be
> +      called now, to determine, using logic very similar to DSA, whether deferral
> +      for RX timestamping is necessary.  Again like DSA, it becomes the
> +      responsibility of the PHY driver to send the packet up the stack when the
> +      timestamp is available.
> +
> +    - On TX, special intervention from the MAC driver might or might not be
> +      needed. The function that calls the ``mii_ts->txtstamp()`` hook is named
> +      ``skb_clone_tx_timestamp()``. This function can either be called directly
> +      (case in which explicit MAC driver support is indeed needed), but the
> +      function also piggybacks from the ``skb_tx_timestamp()`` call, which many
> +      MAC drivers already perform for software timestamping purposes. Therefore,
> +      if a MAC supports software timestamping, it does not need to do anything
> +      further at this stage.
> +
> +
> +- MII bus snooping devices.

new paragraph.

     These perform the same role as timestamping
> +  Ethernet PHYs, save for the fact that they are discrete devices and can
> +  therefore be used in conjunction with any PHY even if it doesn't support
> +  timestamping. In Linux, they are discoverable and attachable to a ``struct
> +  phy_device`` through Device Tree, and for the rest, they use the same mii_ts
> +  infrastructure as those. See
> +  Documentation/devicetree/bindings/ptp/timestamper.txt for more details.
> +
> +One caveat with stacked PHCs, especially with DSA (but not only) - since that
> +doesn't require any modification to MAC drivers, so it is more difficult to
> +ensure correctness of all possible code paths - is that they uncover bugs which
> +were impossible to trigger before the existence of stacked PTP clocks.
> +One example has to do with this line of code, already presented earlier::
> +
> +      skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +
> +Any TX timestamping logic, be it a plain MAC driver, a DSA switch driver, a PHY
> +driver or a MII bus snooping device driver, should set this flag.
> +But a MAC driver that is unaware of PHC stacking might get tripped up by
> +somebody other than itself setting this flag, and deliver a duplicate
> +timestamp.
> +For example, a typical driver design for TX timestamping might be to split the
> +transmission part into 2 portions:
> +
> +1. "TX": checks whether PTP timestamping has been previously enabled through
> +   the ``.ndo_do_ioctl`` ("``priv->hwtstamp_tx_enabled == true``") and the
> +   current skb requires a TX timestamp ("``skb_shinfo(skb)->tx_flags &
> +   SKBTX_HW_TSTAMP``"). If this is true, it sets the
> +   "``skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS``" flag. Note: as
> +   described above, in the case of a stacked PHC system, this condition should
> +   never trigger, as this MAC is certainly not the outermost PHC. But this is
> +   not where the typical issue is.  Transmission proceeds with this packet.
> +
> +2. "TX confirmation": Transmission has finished. The driver checks whether it
> +   is necessary to collect any TX timestamp for it. Here is where the typical
> +   issues are: the MAC driver takes a shortcut and only checks whether
> +   "``skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS``" was set. With a stacked
> +   PHC system, this is incorrect because this MAC driver is not the only entity
> +   in the TX data path who could have enabled SKBTX_IN_PROGRESS in the first
> +   place.
> +
> +The correct solution for this problem is for MAC drivers to have a compound
> +check in their "TX confirmation" portion, not only for
> +"``skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS``", but also for
> +"``priv->hwtstamp_tx_enabled == true``". Because the rest of the system ensures
> +that PTP timestamping is not enabled for anything other than the outermost PHC,
> +this enhanced check will avoid delivering a duplicated TX timestamp to user
> +space.
> -- 
> 2.25.1
> 
