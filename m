Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B331453369
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhKPOBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:01:21 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:43038 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236972AbhKPOBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1637071103; x=1668607103;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QowfK6lC7OtKEtHi/XsDP4k8Yh+I7P+hRoVD2rZgP8k=;
  b=QJnquHeq09Qt6VpPciGdFsoG4bjxNFHZUjFMVH2O2K/uOO1l+gmrIqY4
   Nq8lQ8sFqrxf1WpkiUE8bMCFeT9xNMzNZM8sQ/Zt5yNGrsal69FRRlBJV
   T9bHfKiwaOrLgJaXmFpBbftAQaNkMNEv5O8beisrrIsTyMo3/o5L7SAJz
   HXRsdwH1o3GXPqnVwtar65elSiuq60oA3QZxXtGxHnykSmnwkmBMPfO1P
   i7mpVM9XI4P2S+DzuRQZNG4+QAgJKO+yWOt+1GPQOts91+o/N67zxdEyi
   JspwaEO/gF/J0x/zjjsF5dhzHOFNsafY3M4BkkWctAJSd176dt53D0XDa
   w==;
X-IronPort-AV: E=Sophos;i="5.87,239,1631570400"; 
   d="scan'208";a="20492169"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 16 Nov 2021 14:58:22 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 16 Nov 2021 14:58:22 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 16 Nov 2021 14:58:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1637071102; x=1668607102;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QowfK6lC7OtKEtHi/XsDP4k8Yh+I7P+hRoVD2rZgP8k=;
  b=ZtY6UPcXE7+ed5iEmzLsAD4UCq9jplRHfwBzqrej6e9yet2mejHEKi+Q
   FKmrtNowmzN8rbcf4Ph0OjbDF2RoslYEYVMH3stMWDUED1GG5BZdSsWdQ
   EfmsAVnrsIT6rOj008K3e/1n1PE3cm7dQPLXNj4oJVGjU+ykR6F9U6D3U
   cL/6ifURiC/xH1+DpKhAsUPr8S9cbwUH41hsYMXvdgfhgtxRC7zBaLjuo
   nrdvuWojboRvEud7TUq1+GmzCHvCa1zxg20E+NGMluubIsd7MMHiQxBHG
   oRGinYDXVwIcNMNiUkHbVFRH5SdfC/BTaM8srOwWx8WNSiLwBPsbUoD5k
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,239,1631570400"; 
   d="scan'208";a="20492168"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 16 Nov 2021 14:58:22 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 195A1280065;
        Tue, 16 Nov 2021 14:58:22 +0100 (CET)
Message-ID: <e38eb4ca0a03c60c8bbeccbd8126ffc5bf97d490.camel@ew.tq-group.com>
Subject: Re: [PATCH net 0/4] Fix bit timings for m_can_pci (Elkhart Lake)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 16 Nov 2021 14:58:19 +0100
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-15 at 10:18 +0100, Matthias Schiffer wrote:
> This series fixes two issues we found with the setup of the CAN
> controller of Intel Elkhart Lake CPUs:
> 
> - Patch 1 fixes an incorrect reference clock rate, which caused the
>   configured and the actual bitrate always to differ by a factor of 2.
> - Patches 2-4 fix a deviation between the driver and the documentation.
>   We did not actually see issues without these patches, however we did
>   only superficial testing and may just not have hit the specific
>   bittiming values that violate the documented limits.
> 
> 
> Matthias Schiffer (4):
>   can: m_can: pci: fix incorrect reference clock rate
>   Revert "can: m_can: remove support for custom bit timing"
>   can: m_can: make custom bittiming fields const
>   can: m_can: pci: use custom bit timings for Elkhart Lake
> 
>  drivers/net/can/m_can/m_can.c     | 24 ++++++++++++----
>  drivers/net/can/m_can/m_can.h     |  3 ++
>  drivers/net/can/m_can/m_can_pci.c | 48 ++++++++++++++++++++++++++++---
>  3 files changed, 65 insertions(+), 10 deletions(-)
> 

I just noticed that m_can_pci is completely broken on 5.15.2, while
it's working fine on 5.14.y.

I assume something simliar to [1] will be necessary in m_can_pci as
well, however I'm not really familiar with the driver. There is no
"mram_base" in m_can_plat_pci, only "base". Is using "base" with
iowrite32/ioread32 + manual increment the correct solution here?


[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=99d173fbe8944861a00ebd1c73817a1260d21e60

