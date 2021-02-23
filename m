Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9400322F00
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhBWQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhBWQps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A141E64E61;
        Tue, 23 Feb 2021 16:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614098707;
        bh=a8YSHLzlydiwPkASPXyrSe607sDaNA2aw/Eai/aA+eI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rMT0U0jR1GXTPdi2cU6qOuIMzAvop7eGlIuQlYkzSGdeFZfVSTyjbDu+YEeOwEZRj
         3YYdMJHVYSOwD16JrJZF0twarFZTrAFRFdGUN4PflyNFwjou6+EY4RVjLHx6q69D8K
         N1qfBLqMGwnp0HYRtFJRh11esgeyB281hpKcY8uvtpeMwFsMf9MsdFMSSZdzQEotMD
         YgdLzjTxmSV3kRj0nSpL0NiPKmMexMPKbwtJ9+9PZAM2kyEz34gL+sKJu9C1Ap5x5h
         XikVn5fjDNa3/6wJbtktsGZ+7nDke4+BdvvUDMdL2rOyhLQNOSlZpf3VbAd0ZugBGM
         kyKQv3pRWtFOQ==
Date:   Tue, 23 Feb 2021 08:45:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Message-ID: <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 18:48:15 +0800 Joakim Zhang wrote:
> In stmmac driver, clocks are all enabled after device probed, this leads
> to more power consumption. This patch set tries to implement clocks
> management, and takes i.MX platform as a example.

net-next is closed now and this is an optimization so please post as
RFC until net-next is open again (see the note at the end of the email).

I'm not an expert on this stuff, but is there a reason you're not
integrating this functionality with the power management subsystem?
I don't think it'd change the functionality, but it'd feel more
idiomatic to fit in the standard Linux framework.



# Form letter - net-next is closed

We have already sent the networking pull request for 5.12 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.12-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
