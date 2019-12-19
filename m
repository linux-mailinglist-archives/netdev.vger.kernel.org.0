Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF112583E
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLSAKH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Dec 2019 19:10:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:62892 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbfLSAKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 19:10:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 16:10:07 -0800
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="210268231"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.200])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 16:10:06 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191218.151221.1979818977536859260.davem@davemloft.net>
References: <20191218224448.8066-1-andre.guedes@intel.com> <20191218224448.8066-2-andre.guedes@intel.com> <20191218.151221.1979818977536859260.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>, andre.guedes@intel.com
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ether: Add ETH_P_AVTP macro
Message-ID: <157671420675.49129.8232568416859420600@aguedesl-mac01.jf.intel.com>
User-Agent: alot/0.8.1
Date:   Wed, 18 Dec 2019 16:10:06 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Quoting David Miller (2019-12-18 15:12:21)
> From: Andre Guedes <andre.guedes@intel.com>
> Date: Wed, 18 Dec 2019 14:44:48 -0800
> 
> > This patch adds the ETH_P_AVTP macro which defines the Audio/Video
> > Transport Protocol (AVTP) ethertype assigned to 0x22F0, according to:
> > 
> > http://standards-oui.ieee.org/ethertype/eth.txt
> > 
> > AVTP is the transport protocol utilized in Audio/Video Bridging (AVB),
> > and it is defined by IEEE 1722 standard.
> > 
> > Note that we have ETH_P_TSN macro defined with the number assigned to
> > AVTP. However, there is no "TSN" ethertype. TSN is not a protocol, but a
> > set of features to deliver networking determinism, so ETH_P_TSN can be a
> > bit misleading. For compatibility reasons we should keep it around.
> > This patch re-defines it using the ETH_P_AVTP macro to make it explicit.
> > 
> > Signed-off-by: Andre Guedes <andre.guedes@intel.com>
> 
> Likewise, let's see an in-kernel user first.

I don't think we are going to see an in-kernel user for these ethertypes since
these protocols are implemented in user-space. For instance, we have AVTP
plugins in upstream ALSA [1] and GStreamer [2] that implement AVB. The plugins
are currently using ETH_P_TSN for convenience to send/receive AVTP packets.

Regards,

Andre

[1] https://github.com/alsa-project/alsa-plugins/blob/master/aaf/pcm_aaf.c#L283

[2] https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/ext/avtp/gstavtpsink.c#L245
