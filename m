Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5411B2EF1
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 09:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfIOHQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 03:16:47 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:41429 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbfIOHQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 03:16:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id F09A529BB;
        Sun, 15 Sep 2019 03:16:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 03:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YMCMpl
        H0JiWLNiHw65cdXFG1KN+r2CF4IGQzNLb1LiA=; b=JSVM5yYQTipZjLN4qh7DOf
        OYhTkwhE5nnm4j1907JqQSON2vZFMTbjZT354UH75/dl62yB5wfwplqPHO8/OMns
        k22JMTCG9/tVyDvTxDfpjYFIkLWJ7mFyanBstETgFVuc1PYHZ3Rxj01Y9jFPbu8o
        K1BY1BeFIxtPRKTPyfhbLxPDL0c89+xF9OzhQ+OIqPOZ2zrCbNKEROV87/wAXccd
        l08O7EYunOt0EzsCiPW2O+eqju+xIMRLBGmiFPAZCkof0C84WPXdmDaAjkuq78OC
        +NjYBQVXOsi+yxRm/40/7G9S4yrwcLbvwkswXfWR2SRd7e06R1nhb/WOvrHpT9ng
        ==
X-ME-Sender: <xms:WeV9XR85zryvBifVomKzRWDXxZYcFPfDk5PMrsTxehtZeCUsazN0iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:WeV9Xa1CWL-Zw1htx_M9TEsP2vla9nemfKqpUSf5gh_AGY3kvSTGWw>
    <xmx:WeV9XWTbqJHMen4yDRPdCftuhy0taGJ1biwyExYY5UZCul7e92SDvg>
    <xmx:WeV9XdAi36_Su70FgEtfsFemNW2687mlt5YbrX5MOyO68Ld4vvkW3A>
    <xmx:XOV9Xajg2E7R8vC-JtocYvVRt_gEotyxEumMp6Gqjwzg_u79Kkl9Ng>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E39880061;
        Sun, 15 Sep 2019 03:16:41 -0400 (EDT)
Date:   Sun, 15 Sep 2019 10:16:39 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch iproute2-next 2/2] devlink: extend reload command to add
 support for network namespace change
Message-ID: <20190915071639.GA8776@splinter>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914065757.27295-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914065757.27295-2-jiri@resnulli.us>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 08:57:57AM +0200, Jiri Pirko wrote:
> diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
> index 1804463b2321..0e1a5523fa7b 100644
> --- a/man/man8/devlink-dev.8
> +++ b/man/man8/devlink-dev.8
> @@ -25,6 +25,13 @@ devlink-dev \- devlink device configuration
>  .ti -8
>  .B devlink dev help
>  
> +.ti -8
> +.BR "devlink dev set"
> +.IR DEV
> +.RI "[ "
> +.BI "netns { " PID " | " NAME " | " ID " }
> +.RI "]"
> +
>  .ti -8
>  .BR "devlink dev eswitch set"
>  .IR DEV
> @@ -92,6 +99,11 @@ Format is:
>  .in +2
>  BUS_NAME/BUS_ADDRESS
>  
> +.SS devlink dev set  - sets devlink device attributes
> +
> +.TP
> +.BI "netns { " PID " | " NAME " | " ID " }

This looks like leftover from previous version?

> +
>  .SS devlink dev eswitch show - display devlink device eswitch attributes
>  .SS devlink dev eswitch set  - sets devlink device eswitch attributes
>  
> -- 
> 2.21.0
> 
