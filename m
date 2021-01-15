Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B702F7084
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbhAOCWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbhAOCWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 21:22:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A3C23AC2;
        Fri, 15 Jan 2021 02:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610677316;
        bh=D1a0q603Sv6OfviKtaDaKW7cbulT/DSIDgzRNV2I2EA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eoBTiIQl6B9Bq2mcugVz+drlJamc3kSz3K3B3jxEUglygyEWBx1naUZJjrV9bmHsL
         ccCZv42JPS6n2EwDoemp76GCfzjskHSHuWxci7G2jDCfb1H7PVNxjlfS7SKII2coiq
         z/xqHzuM/4lZgliXrBUWTSLxwvlRdTsc48zzv/9xOU1pwW3vRR1Hx+a1tGLLpw9Z3h
         JYJL9cAk/nUvondgp3A+3Z8jSsrF6AoRurl2DwWEPdGhHgbk9M6VKczAgkquyr08Hn
         UefV7U34TT7O6oi2zLI4MVVyXUjejdSXu+ycW6C1D0EcrGhkO/vWoUT0qT2fKE9h+o
         kFIDLGA790/bw==
Date:   Thu, 14 Jan 2021 18:21:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     ast@kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH net-next] net: core: use eth_type_vlan in
 tap_get_user_xdp
Message-ID: <20210114182154.132a71ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114074436.6268-1-dong.menglong@zte.com.cn>
References: <20210114074436.6268-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 23:44:36 -0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Replace the check for ETH_P_8021Q and ETH_P_8021AD in
> tap_get_user_xdp with eth_type_vlan.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Similarly to bridge, please convert all the instances in tap in one
patch.
