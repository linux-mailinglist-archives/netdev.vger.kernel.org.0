Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DEA2A4FB2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgKCTGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgKCTGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:06:18 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 506C32074B;
        Tue,  3 Nov 2020 19:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604430377;
        bh=O4tzWsceM+EicjZDWWaCFCmvVgWSvK/e5QxW68BvAEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gjL36NCstFyCcg4iSzkApJpED4wi8whZrV6dHqpkxE4LgXmNzTH5nhmjhbBxoS+Xv
         +RdmJbD4waCm3t8hAX3/GkeiuEd5/iCELGhzw1PGn0nNNg7tRCXxPQYrt/V+eRCaKh
         aT76FGPIJD/heUQQ1Hh0S2nBMPNQONOmAA6Du5cs=
Date:   Tue, 3 Nov 2020 11:06:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <vpai@akamai.com>, <Joakim.Tjernlund@infinera.com>,
        <xiyou.wangcong@gmail.com>, <johunt@akamai.com>,
        <jhs@mojatatu.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <john.fastabend@gmail.com>,
        <eric.dumazet@gmail.com>, <dsahern@gmail.com>
Subject: Re: [PATCH stable] net: sch_generic: fix the missing new qdisc
 assignment bug
Message-ID: <20201103110614.49116c3c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
References: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 11:25:38 +0800 Yunsheng Lin wrote:
> commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> 
> When the above upstream commit is backported to stable kernel,
> one assignment is missing, which causes two problems reported
> by Joakim and Vishwanath, see [1] and [2].
> 
> So add the assignment back to fix it.
> 
> 1. https://www.spinics.net/lists/netdev/msg693916.html
> 2. https://www.spinics.net/lists/netdev/msg695131.html
> 
> Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
