Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B691A4FEB0
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 03:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFXBwB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 23 Jun 2019 21:52:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:54742 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfFXBwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 21:52:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jun 2019 18:52:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,410,1557212400"; 
   d="scan'208";a="359411805"
Received: from pgsmsx101.gar.corp.intel.com ([10.221.44.78])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jun 2019 18:51:58 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.96]) by
 PGSMSX101.gar.corp.intel.com ([169.254.1.223]) with mapi id 14.03.0439.000;
 Mon, 24 Jun 2019 09:51:58 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: linux-next: Fixes tag needs some work in the net tree
Thread-Topic: linux-next: Fixes tag needs some work in the net tree
Thread-Index: AQHVKg160YmtwNARk0KEtCAotjVl8aaqCfJA
Date:   Mon, 24 Jun 2019 01:51:56 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC8147282FB@PGSMSX103.gar.corp.intel.com>
References: <20190624074716.44b749d3@canb.auug.org.au>
In-Reply-To: <20190624074716.44b749d3@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi all,
> 
> In commit
> 
>   d0bb82fd6018 ("net: stmmac: set IC bit when transmitting frames with
> HW timestamp")
> 
> Fixes tag
> 
>   Fixes: f748be531d70 ("net: stmmac: Rework coalesce timer and fix
> multi-queue races")
> 
> has these problem(s):
> 
>   - Subject does not match target commit subject
>     Just use
> 	git log -1 --format='Fixes: %h ("%s")'
> 
> Fixes: f748be531d70 ("stmmac: support new GMAC4")
> 
> or did you mean
> 
> Fixes: 8fce33317023 ("net: stmmac: Rework coalesce timer and fix multi-
> queue races")
> 

Sorry for the confusion, what I meant is:
Fixes: 8fce33317023 ("net: stmmac: Rework coalesce timer and fix multi-
queue races")

Regards,
Weifeng

> --
> Cheers,
> Stephen Rothwell
