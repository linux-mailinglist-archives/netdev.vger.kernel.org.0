Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB71E3488
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgE0BPM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 21:15:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:46337 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgE0BPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:15:11 -0400
IronPort-SDR: P9xhDPQlgQYzb5gJZK0vq9+pHfFdEWH44IeVL+1JEsNqYAgfrKIA7oPiB4OkQnJA8l7y3gL6bT
 slX3J96RMurA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 18:15:10 -0700
IronPort-SDR: QWinxi8I/J+IBwUFXoHWO/jsOK5g2LG7Aj4mfS7Ne7TOsyY3GMhUornQxX0YupLyrWSwYyEZmj
 3tzqqndJO46g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="414018142"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2020 18:15:10 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 26 May 2020 18:15:10 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX116.amr.corp.intel.com ([169.254.7.25]) with mapi id 14.03.0439.000;
 Tue, 26 May 2020 18:15:10 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
Subject: RE: linux-next: build warning after merge of the net-next tree
Thread-Topic: linux-next: build warning after merge of the net-next tree
Thread-Index: AQHWMpGs2FQHjjcR3ke+g8+izxT9Nqi7Is4A
Date:   Wed, 27 May 2020 01:15:09 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986D9CE3@ORSMSX112.amr.corp.intel.com>
References: <20200525224004.799f54d4@canb.auug.org.au>
In-Reply-To: <20200525224004.799f54d4@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Sent: Monday, May 25, 2020 05:40
> To: David Miller <davem@davemloft.net>; Networking
> <netdev@vger.kernel.org>
> Cc: Linux Next Mailing List <linux-next@vger.kernel.org>; Linux Kernel Mailing
> List <linux-kernel@vger.kernel.org>; Lifshits, Vitaly <vitaly.lifshits@intel.com>;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Subject: linux-next: build warning after merge of the net-next tree
> 
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (sparc64
> defconfig) produced this warning:
> 
> drivers/net/ethernet/intel/e1000e/netdev.c:137:13: warning: 'e1000e_check_me'
> defined but not used [-Wunused-function]  static bool e1000e_check_me(u16
> device_id)
>              ^~~~~~~~~~~~~~~
> 
> Introduced by commit
> 
>   e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> 
> CONFIG_PM_SLEEP is not set for this build.
> 
[Kirsher, Jeffrey T] 

Vitaly informed me that he has a fix that he will be sending me, I will make sure to expedite it.
