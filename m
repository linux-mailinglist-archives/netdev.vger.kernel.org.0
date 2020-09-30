Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B670027E62A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgI3KEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbgI3KEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 06:04:11 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E575B2074A;
        Wed, 30 Sep 2020 10:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601460250;
        bh=h3lII9feFo679GlwDGoMdyES0Cx9PhK0dx4EC+u43mw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mPp9Qt4jVqc7g8fnbJdvP/BqMl2zkPohuK5zvWekWfrfyziFflkAkQP49IGtDhmfH
         7ezSrbZXNETkOlz4uZo8EA5WMNfR9j658SDpzZT4z5fYgAzSQOQsWo/gwOu2uQ4c/e
         nnzH+dMia5mm3/8pEQFzNINdodGyxGISI3gs2Vjo=
Date:   Wed, 30 Sep 2020 13:04:06 +0300
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
Message-ID: <20200930100406.GN3094@unreal>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
 <20200928102008.32568-1-srini.raju@purelifi.com>
 <20200930051602.GJ3094@unreal>
 <875z7velk2.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z7velk2.fsf@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 11:05:49AM +0300, Kalle Valo wrote:
> Leon Romanovsky <leon@kernel.org> writes:
>
> >> --- /dev/null
> >> +++ b/drivers/net/wireless/purelifi/Kconfig
> >> @@ -0,0 +1,38 @@
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +config WLAN_VENDOR_PURELIFI
> >> +	bool "pureLiFi devices"
> >> +	default y
> >
> > "N" is preferred default.
> >
> >> +	help
> >> +	  If you have a pureLiFi device, say Y.
> >> +
> >> +	  Note that the answer to this question doesn't directly affect the
> >> +	  kernel: saying N will just cause the configurator to skip all the
> >> +	  questions about these cards. If you say Y, you will be asked for
> >> +	  your specific card in the following questions.
> >
> > The text above makes no sense. Of course, it makes a lot of sense to
> > disable this device for whole world.
>
> This is a standard text for all vendor "groups", the actual driver
> should be selected in a separate config. This text has been copied from
> NET_VENDOR_ groups and used by all WLAN_VENDOR configs (or at least that
> was the original plan).

OK, Thanks.

>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
