Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14CB204522
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbgFWASN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 20:18:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:22002 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731442AbgFWASM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 20:18:12 -0400
IronPort-SDR: X+TO4cZ3KGq8H2MIMERXHIlOdSL4mFGeTjDMKYXXhSS6oMq8Mi1UyqpgYHYhoLG+jiVPjlJzk4
 BuIZjzvyLQRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="161989953"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="161989953"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 17:18:10 -0700
IronPort-SDR: aR+Pt1okuh9NpN101ZD+578rDLglXTzdG+gAcEY2ETcj+JfsDQ3a31HX1J0D+YkkRgazo3Ulyp
 +vvkZGPhttKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="282917484"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga007.jf.intel.com with ESMTP; 22 Jun 2020 17:18:10 -0700
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 22 Jun 2020 17:18:10 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.22]) with mapi id 14.03.0439.000;
 Mon, 22 Jun 2020 17:18:09 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 4/9] i40e: detect and log info about pre-recovery mode
Thread-Topic: [net-next 4/9] i40e: detect and log info about pre-recovery
 mode
Thread-Index: AQHWSOMMtMCKLyPfsUWCUoUdRG4SWKjlxOQA//+QaMA=
Date:   Tue, 23 Jun 2020 00:18:08 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D9404498731F8F@ORSMSX112.amr.corp.intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
        <20200622221817.2287549-5-jeffrey.t.kirsher@intel.com>
 <20200622165552.13ebc666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200622165552.13ebc666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, June 22, 2020 16:56
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Kwapulinski, Piotr <piotr.kwapulinski@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Loktionov, Aleksandr <aleksandr.loktionov@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: Re: [net-next 4/9] i40e: detect and log info about pre-recovery mode
> 
> On Mon, 22 Jun 2020 15:18:12 -0700 Jeff Kirsher wrote:
> > +static inline bool i40e_check_fw_empr(struct i40e_pf *pf) {
> 
> > +}
> 
> > +static inline i40e_status i40e_handle_resets(struct i40e_pf *pf) {
> > +	const i40e_status pfr = i40e_pf_loop_reset(pf);
> 
> > +
> > +	return is_empr ? I40E_ERR_RESET_FAILED : pfr; }
> 
> There is no need to use the inline keyword in C sources. Compiler will inline
> small static functions, anyway.
> 
> Same thing in patch 8.
[Kirsher, Jeffrey T] 

I am prepping a v2, are these the only issues?  Want to make sure before send out a v2 and thank you Jakub!
