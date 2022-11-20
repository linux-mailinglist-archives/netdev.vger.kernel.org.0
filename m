Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A72A6316D9
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 23:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiKTWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 17:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKTWaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 17:30:18 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B3015FE4;
        Sun, 20 Nov 2022 14:30:17 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id AFD462AE;
        Sun, 20 Nov 2022 22:30:16 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net AFD462AE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1668983416; bh=etKCjh/3W4labIjyYbdLY0a4N45W3qFVrVuTkExWipU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=N4Tm3rn18zDsvHLQV1phGO+6Q9je5gcfUuz1kN7V8A2R06+0akmtzVdrz9RaoAOJ4
         IMh9F5B9v+RkfFEDJpOcMAkQyx3DMhoz/E+NS8fxONdpaEF44dury18yQEwEZ+PnMj
         FKSzXNEG2m3uQ5wrH1Z0xieWtIU4PhwkswKB622sEO8m5Z3usbTvHV/lVfbUyiEIn1
         MKQI4yM4dvwuG4ZnM9IGEFoMmBtF8EPRcKzigWKFAQkAN9TuNtZu1/68isy8YO8Q5k
         F8JVi9wEoLgUrzogs/pOAIKPbQPD5SXe2RWrg5TVi0EzT4C0kngrvcgfcaVz5wUY2Z
         Lkn+X7WRJJeWA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Nir Levy <bhr166@gmail.com>, grantseltzer@gmail.com,
        linux-doc@vger.kernel.org
Cc:     bhr166@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] Documentation: networking: Update generic_netlink_howto
 URL
In-Reply-To: <20221120220630.7443-1-bhr166@gmail.com>
References: <20221120220630.7443-1-bhr166@gmail.com>
Date:   Sun, 20 Nov 2022 15:30:15 -0700
Message-ID: <878rk5b6o8.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ah...it's not a proper LF URL if it doesn't break every year or so...
this is a networking patch, though, so should go to the folks at netdev;
I'll CC them now.

Thanks,

jon

Nir Levy <bhr166@gmail.com> writes:
> Message-Id: <20221120220630.7443-1-bhr166@gmail.com>

> The documentation refers to invalid web page under www.linuxfoundation.org
> The patch refers to a working URL under wiki.linuxfoundation.org
>
> Signed-off-by: Nir Levy <bhr166@gmail.com>
> ---
>  Documentation/networking/generic_netlink.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/generic_netlink.rst b/Documentation/networking/generic_netlink.rst
> index 59e04ccf80c1..d960dbd7e80e 100644
> --- a/Documentation/networking/generic_netlink.rst
> +++ b/Documentation/networking/generic_netlink.rst
> @@ -6,4 +6,4 @@ Generic Netlink
>  
>  A wiki document on how to use Generic Netlink can be found here:
>  
> - * http://www.linuxfoundation.org/collaborate/workgroups/networking/generic_netlink_howto
> + * https://wiki.linuxfoundation.org/networking/generic_netlink_howto
> -- 
> 2.34.1
