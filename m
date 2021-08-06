Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3CC3E20D7
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 03:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243197AbhHFBUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 21:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhHFBUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 21:20:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D3D611BF;
        Fri,  6 Aug 2021 01:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628212808;
        bh=ZQAfVXDCblHS9zVYXhszqIzMOBPQzESm3sNj2JFZmAQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NEBVC2X20n1pTKrkiETIqjfiTQA5GbK1gYJk3B2E8I6CaslJTP5/i+ESl84sDzJJ5
         Vg6zlhTCYS/n97xxDkrR0Ay8n4XfDkjR18KJmDyqjpUN7CTZ6yK/wV/5OGtbMbBjmi
         xyU2jS0VVqek1CiFHg2oQDkNhlHqsIhCcXMEfQW0KHBRNGsYDplc5eWgpN4102+Too
         XibgiGPT9zDIPQz4tTroY4XyHi5Z8o1Rdcqhrn9GHPUc4I0FP7SA1WSeIZz2vzPd1R
         SPZUBd8MzoNBoxiUs+2utdYCxvB8PGOogMgkpBwQzPYq8If4w09g7UiojWQuz4ed70
         CzPH/ND81e+1A==
Date:   Thu, 5 Aug 2021 18:20:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <alexander.duyck@gmail.com>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <linuxarm@openeuler.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <thomas.petazzoni@bootlin.com>,
        <hawk@kernel.org>, <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 4/4] net: hns3: support skb's frag page
 recycling based on page pool
Message-ID: <20210805182006.66133c8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1628161526-29076-5-git-send-email-linyunsheng@huawei.com>
References: <1628161526-29076-1-git-send-email-linyunsheng@huawei.com>
        <1628161526-29076-5-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 19:05:26 +0800 Yunsheng Lin wrote:
> This patch adds skb's frag page recycling support based on
> the frag page support in page pool.
> 
> The performance improves above 10~20% for single thread iperf
> TCP flow with IOMMU disabled when iperf server and irq/NAPI
> have a different CPU.
> 
> The performance improves about 135%(14Gbit to 33Gbit) for single
> thread iperf TCP flow IOMMU is in strict mode and iperf server
> shares the same cpu with irq/NAPI.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

This patch does not apply cleanly to net-next, please rebase 
if you're targeting that tree.
