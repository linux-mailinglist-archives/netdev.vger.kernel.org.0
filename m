Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF827E6F2
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgI3KpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3KpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 06:45:04 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E212074A;
        Wed, 30 Sep 2020 10:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601462703;
        bh=gGzRaDxmnzYQQAp4vf2ECSVh//FBu7bCpbe1lpzOsj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FNMBVYGLa/mPrIp1u0ApI3K1m/Yfbp7KHz6L/PC12vti2RR0l8aTJzkm2c8uVooQH
         +Dl0pN/nAql2WAYqQbc4QHlNRiiLBy1x7UJcxnygxkNU3pM76Qgal+OcvXwHY8KGG+
         Pus+8wqfET9Ak1nVj+Sn/G5rnvGaYJTL/xD4aToI=
Date:   Wed, 30 Sep 2020 13:44:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Srinivasan Raju <srini.raju@purelifi.com>,
        mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Message-ID: <20200930104459.GO3094@unreal>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
 <20200928102008.32568-1-srini.raju@purelifi.com>
 <20200930051602.GJ3094@unreal>
 <87d023elrc.fsf@codeaurora.org>
 <20200930095526.GM3094@unreal>
 <1449cdbe49b428b7d16a199ebc4c9aef73d6564c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1449cdbe49b428b7d16a199ebc4c9aef73d6564c.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 12:11:24PM +0200, Johannes Berg wrote:
> On Wed, 2020-09-30 at 12:55 +0300, Leon Romanovsky wrote:
> > On Wed, Sep 30, 2020 at 11:01:27AM +0300, Kalle Valo wrote:
> > > Leon Romanovsky <leon@kernel.org> writes:
> > >
> > > > > diff --git a/drivers/net/wireless/purelifi/Kconfig
> > > > b/drivers/net/wireless/purelifi/Kconfig
> > > > > new file mode 100644
> > > > > index 000000000000..ff05eaf0a8d4
> > > > > --- /dev/null
> > > > > +++ b/drivers/net/wireless/purelifi/Kconfig
> > > > > @@ -0,0 +1,38 @@
> > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > +config WLAN_VENDOR_PURELIFI
> > > > > +	bool "pureLiFi devices"
> > > > > +	default y
> > > >
> > > > "N" is preferred default.
> > >
> > > In most cases that's true, but for WLAN_VENDOR_ configs 'default y'
> > > should be used. It's the same as with NET_VENDOR_.
> >
> > I would like to challenge it, why is that?
> > Why do I need to set "N", every time new vendor upstreams its code?
>
> You don't. The WLAN_VENDOR_* settings are not supposed to affect the
> build, just the Kconfig visibility.

Which is important to me, I'm keeping .config as minimal as possible
to simplify comparison between various builds.

Thanks
