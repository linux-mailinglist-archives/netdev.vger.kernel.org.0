Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF10450B25
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbhKORUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237217AbhKORTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 12:19:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16AC463260;
        Mon, 15 Nov 2021 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636996419;
        bh=ngzPuNtY5WbHieysOtfiqNgfI0jysu9lBmr1CVb4PGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MEysJ75+k4eZDu4tp7aJgKH1Eit2Oxu051MtDwCsrFjgyxPj4KBUxpfcgwBemg7DE
         yyHGtbGFDIAypvLaEajT0lbkcPGirCgxpSS+qMH1SN8OSUEXRO5fzfl3F9SktBeqOs
         zZaGPaiwaQk1WxS9E0qp4/tUY7fnNFr/YjZLLgXq3Yj2xUeuJQmS6Oq63eQ90KCwwP
         oRojhBeRp/3n86LiRI6yg9nBEHgjqJKZpiNLHVFHqwUKek5vyQ53O3LexBMb5a1SOl
         H26iWfBCVhnUy1KXDaJRjjh0nOU3IEJkuBsmh+Mfi91H8DSyZn/dBP27BAN3Tu0M+4
         NF0orkk2F8dGQ==
Date:   Mon, 15 Nov 2021 09:13:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii@kernel.org,
        quentin@isovalent.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2021-11-15
Message-ID: <20211115091338.5e1d6316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115162008.25916-1-daniel@iogearbox.net>
References: <20211115162008.25916-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 17:20:08 +0100 Daniel Borkmann wrote:
>                 -c -MMD -o $@ $<

>                 -c -MMD $< -o $@

Out of curiosity did you switch the order on purpose?
