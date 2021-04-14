Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E6935FE34
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhDNXJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237058AbhDNXIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:08:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1787061090;
        Wed, 14 Apr 2021 23:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618441703;
        bh=loRDmNqig6rzWmy/dyXWo3LyLZ/2cShQxMRBRYxhBNI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A/fbl1/onE0mMUa1xuJ2FqgzdIVohZcYAssQQgKf1E2iM3FSa4Wqyr/hDLlhzGBK2
         xxcMmXy7dYuKP8ltlxSW7kEcIiVCe2CBcAmj9QidFVfuqct0bcsV1M+RrOUJgugf0c
         biZIcov+5kSVLjnhlsHNS0WLERsSqMrWstliqt8jUcwr2PNjx3CFGrM6/6SUTQU4Hi
         X0obwlNTxN62ug9UwTH1p9ld00ebhJw7O6cxLGmEEsqYeN/iB/dtkmgi6afyGWvH9d
         N36dNzCAHObPV3vWe1TXne64UzrLdJ3Jn7i14r3cdkwlpYZzwPtfjvevbCzTpcvwpr
         0CvAvXWZBdk3Q==
Message-ID: <c8754f7c390bb3887cd751f5422af538fbb79a5d.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: fix ingress_ifindex check in
 mlx5e_flower_parse_meta
From:   Saeed Mahameed <saeed@kernel.org>
To:     wenxu@ucloud.cn
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Date:   Wed, 14 Apr 2021 16:08:22 -0700
In-Reply-To: <1617946428-10944-1-git-send-email-wenxu@ucloud.cn>
References: <1617946428-10944-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-09 at 13:33 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the nft_offload there is the mate flow_dissector with no
> ingress_ifindex but with ingress_iftype that only be used
> in the software. So if the mask of ingress_ifindex in meta is
> 0, this meta check should be bypass.
> 
> Fixes: 6d65bc64e232 ("net/mlx5e: Add mlx5e_flower_parse_meta
> support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

applied to net-mlx5,
Thanks!

