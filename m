Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B07487084
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344841AbiAGCfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344722AbiAGCfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 21:35:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2DAC061245;
        Thu,  6 Jan 2022 18:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71AF7B824B6;
        Fri,  7 Jan 2022 02:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E93C36AE3;
        Fri,  7 Jan 2022 02:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641522951;
        bh=NqA0ikPfiDIzAtaD0ixY97u913wwvnwb/YE4uucy6KE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZPZK8FUJLey+yrYPnMELLXHipFVEjyivvMSdc1mml4QVY9cvvPG+HF1OEoh+vAyJm
         p3G9JvioU/T/L0V/RY4yIhflykRCee9YgvUDFD+HFS+FeIdd9wAnRoDalfruxqWHIV
         1XWumpqINWHbERSd32SspV9Ko3mskSkQjYogWKDcqK3JarrXcuGhZhc/sAg6RAkJCk
         vTVX/oOTKB6C23MNZNCsbIMiNBlvF5VWRizktLpDYrzGinEcPtuB3EEztCM8ta3hbL
         P4vO8muwc4QlK2Y3aR/X8S0oGS8VviOqHnrxCSvz4nYsC0qntwG9p5KwzGIKsQ9QIl
         CL5QRBux3KwNw==
Date:   Thu, 6 Jan 2022 18:35:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     yan2228598786@gmail.com
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Benjamin <yan2228598786@gmail.com>
Subject: Re: [PATCH] tcp: tcp_send_challenge_ack delete useless param `skb`
Message-ID: <20220106183540.6826f285@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106003245.15339-1-yan2228598786@gmail.com>
References: <20220106003245.15339-1-yan2228598786@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jan 2022 08:32:45 +0800 Benjamin.Yim yan2228598786@gmail.com
wrote:
> From: Benjamin <yan2228598786@gmail.com>
> 
> After this parameter is passed in, there is no usage, and deleting it will
>  not bring any impact.
> 
> Signed-off-by: Benjamin <yan2228598786@gmail.com>

This one did not make it to patchwork or lore.

Please resend. Perhaps the reason was the odd looking From header:

From: Benjamin.Yim yan2228598786@gmail.com

Maybe it should have <> brackets? Please also use your full name for
the patch author and sign-off - should you be "Benjamin Yim"?
