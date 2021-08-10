Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBDF3E5E31
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbhHJOnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241137AbhHJOnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C80D860F02;
        Tue, 10 Aug 2021 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628606589;
        bh=ozD8cwZNKn3odTH+KqEJhMRr1mfhtpueWtbLeeuQTmE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mLjCOt7dgwO3Zw6T1I+BApb8RKELVC4ldw0jU3X52uRYEIQL2zkrQg440QC/WFMDe
         nW5UTk4L3ZqdynsL7GZZ3lsdQQSnV8AKzUtAQPlY4QcqwT0GvPLa78U93zPZZ6S+M7
         rwANNXfmInPEaG2qoYobRKdfc941y5vYjHTfHPwOumy5R7NTQE7U0t6xpDokyF9Fhc
         X7tqZRWmk6YlYmXf0p7zvhAPaBaUCCuqw2Ab7Wz7ciP8Ouw7d6QpS2e0jR5MybIRo8
         53ezwlvnSoOKt2C7QIr3LndUAFzQUceqfk36RdN/37xp9bZZzPmS/EuRkZW7JE1Phu
         6REpU9Y8oDpHQ==
Date:   Tue, 10 Aug 2021 07:43:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, brouer@redhat.com,
        davem@davemloft.net, alexander.duyck@gmail.com,
        linux@armlinux.org.uk, mw@semihalf.com, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, akpm@linux-foundation.org,
        peterz@infradead.org, will@kernel.org, willy@infradead.org,
        vbabka@suse.cz, fenghua.yu@intel.com, guro@fb.com,
        peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, yhs@fb.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, chenhao288@hisilicon.com,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH net-next v2 0/4] add frag page support in page pool
Message-ID: <20210810074306.6cbd1a73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1eb903a5-a954-e405-6088-9b9209703f5e@redhat.com>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
        <20210810070159.367e680e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1eb903a5-a954-e405-6088-9b9209703f5e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 16:23:52 +0200 Jesper Dangaard Brouer wrote:
> On 10/08/2021 16.01, Jakub Kicinski wrote:
> > On Fri, 6 Aug 2021 10:46:18 +0800 Yunsheng Lin wrote:  
> >> enable skb's page frag recycling based on page pool in
> >> hns3 drvier.  
> > 
> > Applied, thanks!  
> 
> I had hoped to see more acks / reviewed-by before this got applied.
> E.g. from MM-people as this patchset changes struct page and page_pool 
> (that I'm marked as maintainer of). 

Sorry, it was on the list for days and there were 7 or so prior
versions, I thought it was ripe. If possible, a note that review 
will come would be useful.

> And I would have appreciated an reviewed-by credit to/from Alexander
> as he did a lot of work in the RFC patchset for the split-page tricks.

I asked him off-list, he said something I interpreted as "code is okay,
but the review tag is not coming".
