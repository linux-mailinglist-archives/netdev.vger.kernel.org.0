Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F261633395A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 11:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhCJKCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 05:02:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45271 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231897AbhCJKBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 05:01:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 098A25C0143;
        Wed, 10 Mar 2021 05:01:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 05:01:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ieduxa
        tBKUrPjGdVkc7/0qqVIY7beKmebjG/5/jERa8=; b=dO0JUpSGJXBbbbKeyFDNJO
        OF49Q3BEsMvY1T4Mg+W7Z9nRdIZITv641ZagxW/sCg2toMIWCOnlnLRwQK7eAMqJ
        w8ngeTvXxGpaRqClzFBIs2XypUISFVyFaAMC7+TGAsEhtuDduofVgUSW25jme9ml
        FX1CbbaQSKeuFIt2Qj7a5MxYLTugfGBbAc6yceF49NeKbw0EOI/aXOewU1aNWauk
        SwENz3P2K37PXTsC4y5U9AscTAEP00VCAuRuoCCLe9t1y/Nu46HTViNpICJPH6gX
        kPsK7YPUGlsdL7Mr4IfcPxjkgSOnVPYdVCzqy0GcyeXczUdnGul5XJ1ISLDVocSg
        ==
X-ME-Sender: <xms:CZlIYNBSo4kJXtCD7T364ycTyGY8OskY72VOiN7oEBQ5Za-SlkcRZw>
    <xme:CZlIYLg-p1YvLiJmUTzzXULVpFIo-CPAA_KxbpZ73M5MHNxGVceQsrf5TwwZNUdM3
    xzxC0q1Arbnc0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CZlIYIlcj4DkGkc6FcXbn2gpk8VMqS5-H7X1fObxFuyV67Py0Fr66w>
    <xmx:CZlIYHzoXOuO-YbWpF7m4HDBdB8uvc3qh28mYJAsLgnoxm94VAdTRQ>
    <xmx:CZlIYCQpAsZ1AOdRXAEsngBf9Uca9sxDOhbeD3FFXPFFuDebcym5pQ>
    <xmx:CplIYFIHosTDgYzxS01ec2weHFNKcKOrr1zmXpDBpImU5i9O0X1F2Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF4411080064;
        Wed, 10 Mar 2021 05:01:44 -0500 (EST)
Date:   Wed, 10 Mar 2021 12:01:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevsim: fib: Remove redundant code
Message-ID: <YEiZBYmEu2xK8V7i@shredder.lan>
References: <1615343727-96723-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615343727-96723-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:35:27AM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/netdevsim/fib.c:874:5-8: Unneeded variable: "err". Return
> "0" on line 889.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/netdevsim/fib.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
> index 46fb414..db794f9 100644
> --- a/drivers/net/netdevsim/fib.c
> +++ b/drivers/net/netdevsim/fib.c
> @@ -871,8 +871,6 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
>  
>  static int nsim_fib_event(struct nsim_fib_event *fib_event)

Can you change to 'static void' ?

>  {
> -	int err = 0;
> -
>  	switch (fib_event->family) {
>  	case AF_INET:
>  		nsim_fib4_event(fib_event->data, &fib_event->fen_info,
> @@ -886,7 +884,7 @@ static int nsim_fib_event(struct nsim_fib_event *fib_event)
>  		break;
>  	}
>  
> -	return err;
> +	return 0;
>  }
>  
>  static int nsim_fib4_prepare_event(struct fib_notifier_info *info,
> -- 
> 1.8.3.1
> 
