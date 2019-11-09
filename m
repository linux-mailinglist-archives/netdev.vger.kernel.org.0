Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B01AF5C2D
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbfKIACH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 19:02:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:56561 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730810AbfKIACG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:02:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 16:02:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="377906935"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2019 16:02:05 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 8 Nov 2019 16:02:04 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 16:02:04 -0800
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Fri, 8 Nov 2019 16:02:04 -0800
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net 2/2] ixgbe: need_wakeup flag might
 not be set for Tx
Thread-Topic: [Intel-wired-lan] [PATCH net 2/2] ixgbe: need_wakeup flag might
 not be set for Tx
Thread-Index: AQHVlm8DrMV30n3NPk2b3kL+lk2n0KeB9NLw
Date:   Sat, 9 Nov 2019 00:02:04 +0000
Message-ID: <290022e664f04723bdcada76e1c1bd7a@intel.com>
References: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com>
 <1573243090-2721-2-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1573243090-2721-2-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzU3NTc2Y2UtMzFlNy00NzdiLWEyNGUtZDBlOWM2ODJiNjRmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRGdFNHFuVHFmVEV0YU9ya2p3NCtGbVRxb2k5cG5Eb2IzZ1JCKzZKSmxZbUo4U0k0RUhJZnVWeUF0MUErbkJyXC8ifQ==
dlp-reaction: no-action
dlp-version: 11.0.400.15
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Magnus Karlsson
> Sent: Friday, November 8, 2019 11:58 AM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org
> Cc: maciejromanfijalkowski@gmail.com; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net 2/2] ixgbe: need_wakeup flag might
> not be set for Tx
> 
> The need_wakeup flag for Tx might not be set for AF_XDP sockets that are
> only used to send packets. This happens if there is at least one outstanding
> packet that has not been completed by the hardware and we get that
> corresponding completion (which will not generate an interrupt since
> interrupts are disabled in the napi poll loop) between the time we stopped
> processing the Tx completions and interrupts are enabled again. In this case,
> the need_wakeup flag will have been cleared at the end of the Tx
> completion processing as we believe we will get an interrupt from the
> outstanding completion at a later point in time. But if this completion
> interrupt occurs before interrupts are enable, we lose it and should at that
> point really have set the need_wakeup flag since there are no more
> outstanding completions that can generate an interrupt to continue the
> processing. When this happens, user space will see a Tx queue
> need_wakeup of 0 and skip issuing a syscall, which means will never get into
> the Tx processing again and we have a deadlock.
> 
> This patch introduces a quick fix for this issue by just setting the
> need_wakeup flag for Tx to 1 all the time. I am working on a proper fix for
> this that will toggle the flag appropriately, but it is more challenging than I
> anticipated and I am afraid that this patch will not be completed before the
> merge window closes, therefore this easier fix for now. This fix has a
> negative performance impact in the range of 0% to 4%. Towards the higher
> end of the scale if you have driver and application on the same core and issue
> a lot of packets, and towards no negative impact if you use two cores, lower
> transmission speeds and/or a workload that also receives packets.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


