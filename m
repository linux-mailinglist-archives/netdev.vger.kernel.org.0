Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BF2444334
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhKCOSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:18:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:54837 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231131AbhKCOSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:18:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="212253588"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="212253588"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 07:16:07 -0700
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="450079125"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 07:16:03 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1miH3L-003HQz-Ib;
        Wed, 03 Nov 2021 16:15:47 +0200
Date:   Wed, 3 Nov 2021 16:15:47 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH] mwifiex: Add quirk to disable deep sleep with certain
 hardware revision
Message-ID: <YYKZkz3EFfdENhoZ@smile.fi.intel.com>
References: <20211028073729.24408-1-verdre@v0yd.nl>
 <CA+ASDXOrad3b=b8+vwuF6m3+ZcigVaoJySpDXXZOnC3O8CJBSw@mail.gmail.com>
 <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
 <b2aaf6f7-9f22-926a-963b-cfd0d4fca31d@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2aaf6f7-9f22-926a-963b-cfd0d4fca31d@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 02:37:53PM +0100, Jonas Dreßler wrote:
> On 11/3/21 13:25, Jonas Dreßler wrote:

...

> > > > +               if (strncmp(ver_ext->version_str, "ChipRev:20, BB:9b(10.00), RF:40(21)", 128) == 0) {
> > > 
> > > Rather than memorize the 128-size array here, maybe use
> > > sizeof(ver_ext->version_str) ?
> > 
> > Sounds like a good idea, yeah.
> 
> Nevermind, the reason I did this was for consistency in the
> function, right underneath in the same function it also assumes
> a fixed size of 128 characters, so I'd rather use the same
> length.
> 
> > 		memcpy(version_ext->version_str, ver_ext->version_str,
> > 		       sizeof(char) * 128);

Besides sizeof(char)...

> > 		memcpy(priv->version_str, ver_ext->version_str, 128);
> 
> Might be a good idea to #define it as MWIFIEX_VERSION_STR_LENGTH
> in fw.h though...

...I think you simply need a precursor patch that changes this
to sizeof() / #define approach.

-- 
With Best Regards,
Andy Shevchenko


