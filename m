Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7584097EB
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbhIMPxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244949AbhIMPxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 11:53:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E47660FC1;
        Mon, 13 Sep 2021 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631548326;
        bh=M8x3WoJty67LjoQsNC1A0PS9DP75fGoueCiDQ+i1TEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z7gsYlm6JRj3VhO7cu90aoVVlTnLuXv7EWIuiaKiNYC7oMsncjSnym3kJJnl4X+rV
         05gIOfVYfZ9pYedV2SBjR71hms6PfMyQ2pHt4hMX0Fu+O61CWj+3BwlVe/FOsrk3Tl
         pGJM/qiI6cahYwLspBhfvMGiw2sl72PffO/Sppgkwl+3n9v1RjEnz70ogqaprUlfYf
         NfjXV94PeainCTvS6tzT6VOhFkWZi9lYQongjiNXYK7AdkS1Wbjl2s/E2/SiqAuLX3
         KSvYsqexTVBnpxyd8frr/TLjwcFXXbgDNfQlgAHr+Qgc7wiiy8Bro+r/ZSHUONVQks
         6xcDv5wonPiNw==
Date:   Mon, 13 Sep 2021 08:52:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhenggy <zhenggy@chinatelecom.cn>
Cc:     ncardwell@google.com, netdev@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ycheng@google.com, qitiepeng@chinatelecom.cn,
        wujianguo@chinatelecom.cn, liyonglong@chinatelecom.cn
Subject: Re: [PATCH v3] tcp: fix tp->undo_retrans accounting in
 tcp_sacktag_one()
Message-ID: <20210913085205.531d435a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1630314010-15792-1-git-send-email-zhenggy@chinatelecom.cn>
References: <1630314010-15792-1-git-send-email-zhenggy@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 05:00:10 -0400 zhenggy wrote:
> Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
> time") may directly retrans a multiple segments TSO/GSO packet without
> split, Since this commit, we can no longer assume that a retransmitted
> packet is a single segment.
> 
> This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
> that use the actual segments(pcount) of the retransmitted packet.
> 
> Before that commit (10d3be569243), the assumption underlying the
> tp->undo_retrans-- seems correct.
> 
> Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
> 

Please remove this empty line. There should be no empty lines between
tags.

> Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>

Please fix the data on your system and repost. I'm pretty sure this
wasn't posted on Aug 30th.
