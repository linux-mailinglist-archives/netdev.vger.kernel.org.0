Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952EF4E88ED
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 18:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiC0Qop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 12:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiC0Qon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 12:44:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4013BE66;
        Sun, 27 Mar 2022 09:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KD1fEyed96fRjqn2/46aqrMkivPtndc4nSosvuAzczI=; b=HbHoovih9aG2FvRmJzvI289Mer
        NiQeSZAtZnZzQEMqY1ag5FdvnCf9g1TkOA2AQE97n5Els6723Q3sXPOFtypJ7NS/8tGRnC9/cnNkt
        WPKl7ebTeIwtUW7//tG031t2NslPrGupv/psvtLhMLNq3Ja4FJm4/yDdvXhtqPQ0X+K4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nYVyl-00CuAP-70; Sun, 27 Mar 2022 18:42:59 +0200
Date:   Sun, 27 Mar 2022 18:42:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net 09/13] docs: netdev: make the testing requirement
 more stringent
Message-ID: <YkCUEwZI0jUmamPg@lunn.ch>
References: <20220327025400.2481365-1-kuba@kernel.org>
 <20220327025400.2481365-10-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327025400.2481365-10-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 07:53:56PM -0700, Jakub Kicinski wrote:
> These days we often ask for selftests so let's update our
> testing requirements.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/netdev-FAQ.rst | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
> index 85a0af5dca65..26110201f301 100644
> --- a/Documentation/networking/netdev-FAQ.rst
> +++ b/Documentation/networking/netdev-FAQ.rst
> @@ -196,11 +196,15 @@ as possible alternative mechanisms.
>  
>  What level of testing is expected before I submit my change?
>  ------------------------------------------------------------
> -If your changes are against ``net-next``, the expectation is that you
> -have tested by layering your changes on top of ``net-next``.  Ideally
> -you will have done run-time testing specific to your change, but at a
> -minimum, your changes should survive an ``allyesconfig`` and an
> -``allmodconfig`` build without new warnings or failures.
> +At the very minimum your changes must survive an ``allyesconfig`` and an
> +``allmodconfig`` build with ``W=1`` set without new warnings or failures.

Doesn't the patchwork buildbot also have C=1 ? You have been pointing
out failures for C=1, so it probably should be documented here.

	 Andrew
