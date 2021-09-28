Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD0141A453
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbhI1A5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhI1A5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 20:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 184AB611CE;
        Tue, 28 Sep 2021 00:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632790565;
        bh=Hm/Wj9PE5z58tT4ALTqj5FVxuHO8s34gYJbDIZ0MFhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GbNe0epshlkMxQnUa+L+A7JAvGSUj2f4m83qDi5i9r53yHm6/HJedN174x7wnHU65
         aCzX9FF6b5Chpgp4/+1krfZFj2B5bhpfog1A7RWtOv7ZT08y7JZvBLmFbYy8DWbODj
         MllJtzQUjrnrwKucExPOhTC/Rhdhy4P83/T2EbY0wZDIXDeCLEsrRVU2W2/z7mkQ06
         I6oMF9vk+c4n8M9oI7e8cdv6tR9Irl6Rt+iHcI0WA5Rjbvn46+HThMALe8H+M9eGwD
         bqw9p1C2KhbNcCTSvZe5UZYSRuaFILCH2RwCxiiG6w0xrl33d+Pl2zibIbKlekKrV9
         1pk/qet0xN3fw==
Date:   Mon, 27 Sep 2021 17:56:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net_sched: Use struct_size() and
 flex_array_size() helpers
Message-ID: <20210927175604.66ec0cff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210927221849.GA188050@embeddedor>
References: <20210927221849.GA188050@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Sep 2021 17:18:49 -0500 Gustavo A. R. Silva wrote:
> Make use of the struct_size() and flex_array_size() helpers instead of
> an open-coded version, in order to avoid any potential type mistakes
> or integer overflows that, in the worse scenario, could lead to heap
> overflows.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Does not apply to net-next, please rebase & resend. Thanks!
