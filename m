Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E48315C8F
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhBJBsx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Feb 2021 20:48:53 -0500
Received: from mga04.intel.com ([192.55.52.120]:51519 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhBJBrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 20:47:36 -0500
IronPort-SDR: GbO0KKdzdtyRkBxJEWMSpRr0mCGya8aMpvNd5/mhwLTJ7gjDRBv06kUbHUOvyEgO2ttLBL3ZHc
 Y4IMnpABJwPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="179438962"
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="179438962"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 17:46:48 -0800
IronPort-SDR: VwV9tN20w9Co4NJOFoUs63/jmgJQCVI+eY5nEubICaY/tvpsaBUl98E4XqbvVbsi1d60hP8Tkm
 0ISb7kmfidUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="375177282"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 09 Feb 2021 17:46:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Feb 2021 17:46:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Feb 2021 17:46:47 -0800
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.002;
 Tue, 9 Feb 2021 17:46:47 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Punit Agrawal <punit1.agrawal@toshiba.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "daichi1.fukui@toshiba.co.jp" <daichi1.fukui@toshiba.co.jp>,
        "nobuhiro1.iwamatsu@toshiba.co.jp" <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Corinna Vinschen <vinschen@redhat.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: RE: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS
 WRAP" log message
Thread-Topic: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS
 WRAP" log message
Thread-Index: AQHW/00Ea3dgcbxX60mwhrS/nkhIh6pQnn8g
Date:   Wed, 10 Feb 2021 01:46:46 +0000
Message-ID: <c5d7ccb5804b46eea2ef9fe29c66720f@intel.com>
References: <20210210013448.2116413-1-punit1.agrawal@toshiba.co.jp>
In-Reply-To: <20210210013448.2116413-1-punit1.agrawal@toshiba.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
> Sent: Tuesday, February 09, 2021 5:35 PM
> To: netdev@vger.kernel.org
> Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; daichi1.fukui@toshiba.co.jp;
> nobuhiro1.iwamatsu@toshiba.co.jp; Corinna Vinschen <vinschen@redhat.com>;
> Keller, Jacob E <jacob.e.keller@intel.com>; Brown, Aaron F
> <aaron.f.brown@intel.com>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Subject: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS WRAP" log
> message
> 
> From: Corinna Vinschen <vinschen@redhat.com>
> 
> commit 2643e6e90210e16c978919617170089b7c2164f7 upstream
> 
> TSAUXC.DisableSystime is never set, so SYSTIM runs into a SYS WRAP
> every 1100 secs on 80580/i350/i354 (40 bit SYSTIM) and every 35000
> secs on 80576 (45 bit SYSTIM).
> 
> This wrap event sets the TSICR.SysWrap bit unconditionally.
> 
> However, checking TSIM at interrupt time shows that this event does not
> actually cause the interrupt.  Rather, it's just bycatch while the
> actual interrupt is caused by, for instance, TSICR.TXTS.
> 
> The conclusion is that the SYS WRAP is actually expected, so the
> "unexpected SYS WRAP" message is entirely bogus and just helps to
> confuse users.  Drop it.
> 
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> Acked-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> Hi,
> 
> A customer reported that the following message appears in the kernel
> logs every 1100s -
> 
>     igb 0000:01:00.1: unexpected SYS WRAP
> 
> As the systems have large uptimes the messages are crowding the logs.
> 
> The message was dropped in
> commit 2643e6e90210e16c ("igb: Remove incorrect "unexpected SYS WRAP" log
> message")
> in v4.14.
> 
> Please consider applying to patch to v4.4 and v4.9 stable kernels - it
> applies cleanly to both the trees.
> 
> Thanks,
> Punit
> 

It makes sense to me for htis to apply to those stable trees as well.

Thanks,
Jake

