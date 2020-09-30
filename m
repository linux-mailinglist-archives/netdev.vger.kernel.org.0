Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3827E5BA
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 11:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgI3Jzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 05:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbgI3Jza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 05:55:30 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00862075F;
        Wed, 30 Sep 2020 09:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601459730;
        bh=rjvpk8NGHsZnXAbXtQ4alzl+Jo4neTXTEg6IzFfFFNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoR+pW6VJMYs5pAjcYy5QL4WFi0ngovU1/riIz4CE2WcSlfJyHc2CxBs5mhMVkkVv
         qffygP/VLDJgEaVvJ3blRaopgY9z2xL+V0dX4SVItKvRi6Tm7Jbt5UTUDdJfTyk2vO
         +TBsKHaczkabH/KiVhlCzKZRN+bxCYvNDuVWKHu8=
Date:   Wed, 30 Sep 2020 12:55:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Srinivasan Raju <srini.raju@purelifi.com>,
        mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Message-ID: <20200930095526.GM3094@unreal>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
 <20200928102008.32568-1-srini.raju@purelifi.com>
 <20200930051602.GJ3094@unreal>
 <87d023elrc.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d023elrc.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 11:01:27AM +0300, Kalle Valo wrote:
> Leon Romanovsky <leon@kernel.org> writes:
>
> >> diff --git a/drivers/net/wireless/purelifi/Kconfig
> > b/drivers/net/wireless/purelifi/Kconfig
> >> new file mode 100644
> >> index 000000000000..ff05eaf0a8d4
> >> --- /dev/null
> >> +++ b/drivers/net/wireless/purelifi/Kconfig
> >> @@ -0,0 +1,38 @@
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +config WLAN_VENDOR_PURELIFI
> >> +	bool "pureLiFi devices"
> >> +	default y
> >
> > "N" is preferred default.
>
> In most cases that's true, but for WLAN_VENDOR_ configs 'default y'
> should be used. It's the same as with NET_VENDOR_.

I would like to challenge it, why is that?
Why do I need to set "N", every time new vendor upstreams its code?

Thanks

>
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
