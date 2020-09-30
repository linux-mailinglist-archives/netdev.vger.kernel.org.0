Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7453E27E644
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgI3KMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI3KMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:12:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53250C061755;
        Wed, 30 Sep 2020 03:12:02 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNZ5I-00DgIQ-L9; Wed, 30 Sep 2020 12:11:40 +0200
Message-ID: <1449cdbe49b428b7d16a199ebc4c9aef73d6564c.camel@sipsolutions.net>
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Leon Romanovsky <leon@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Srinivasan Raju <srini.raju@purelifi.com>,
        mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 30 Sep 2020 12:11:24 +0200
In-Reply-To: <20200930095526.GM3094@unreal> (sfid-20200930_115542_649430_AD2127A0)
References: <20200924151910.21693-1-srini.raju@purelifi.com>
         <20200928102008.32568-1-srini.raju@purelifi.com>
         <20200930051602.GJ3094@unreal> <87d023elrc.fsf@codeaurora.org>
         <20200930095526.GM3094@unreal> (sfid-20200930_115542_649430_AD2127A0)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 12:55 +0300, Leon Romanovsky wrote:
> On Wed, Sep 30, 2020 at 11:01:27AM +0300, Kalle Valo wrote:
> > Leon Romanovsky <leon@kernel.org> writes:
> > 
> > > > diff --git a/drivers/net/wireless/purelifi/Kconfig
> > > b/drivers/net/wireless/purelifi/Kconfig
> > > > new file mode 100644
> > > > index 000000000000..ff05eaf0a8d4
> > > > --- /dev/null
> > > > +++ b/drivers/net/wireless/purelifi/Kconfig
> > > > @@ -0,0 +1,38 @@
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +config WLAN_VENDOR_PURELIFI
> > > > +	bool "pureLiFi devices"
> > > > +	default y
> > > 
> > > "N" is preferred default.
> > 
> > In most cases that's true, but for WLAN_VENDOR_ configs 'default y'
> > should be used. It's the same as with NET_VENDOR_.
> 
> I would like to challenge it, why is that?
> Why do I need to set "N", every time new vendor upstreams its code?

You don't. The WLAN_VENDOR_* settings are not supposed to affect the
build, just the Kconfig visibility.

johannes

