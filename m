Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945333E5C73
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbhHJOCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236686AbhHJOCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 10:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E06D9600CD;
        Tue, 10 Aug 2021 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604121;
        bh=2X2FfQTItSOe1HgmV1lGWAz1F4CFriJWOSrHqlK+mdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XrXAXflx3roisEZL9HRH0ZjFfJReCyJ1mEylsRBb5EJqwOEBQDikCNPcsR5mxsOCR
         Z47lulbBJj+XDVCuJaI9QrsFNzqzcNO5TexLkzH+f8Hv0fP7OlbbPPId9KxbRIEnRc
         JTOmfpZ5VscAPld2LX7GWP6w6PvsEX9itLX2nHzPjMhxohrrD/Ttsh+T8V/pGdm08R
         GItYpvJYF1d73ZnKs2kIhhzdL331y14aLm0U0Qmp1NCSHvczDqMuaB0qGGD+hBZemq
         hjacoUh8k0IsxNXqoDPpxu6+ect+9hqaRbytC/i2KcA11U9SSDSjbPPYS/8D0MNDyZ
         4A2Pd7YuAO9ig==
Date:   Tue, 10 Aug 2021 07:01:59 -0700
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
Subject: Re: [PATCH net-next v2 0/4] add frag page support in page pool
Message-ID: <20210810070159.367e680e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Aug 2021 10:46:18 +0800 Yunsheng Lin wrote:
> enable skb's page frag recycling based on page pool in
> hns3 drvier.

Applied, thanks!
