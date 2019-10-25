Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAB6E53B8
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388649AbfJYSUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:20:01 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:42145 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388583AbfJYSTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:19:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1A6426C37;
        Fri, 25 Oct 2019 14:19:44 -0400 (EDT)
Received: from imap36 ([10.202.2.86])
  by compute4.internal (MEProxy); Fri, 25 Oct 2019 14:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm1; bh=Wc5pFB9cFV9X8b0ifj+g9eVrc/4oE6D
        JhMyg+0grg+A=; b=h5LuZvGoQneswISPn5LfGnXktKYCXhY0IP7WCgc/4mTmocu
        X9jWEmVb3M1G5W+kvKDwrWdYXbW4YiLWq5+1d4atIY+TSuTTQa43qLmhsDhIEJcP
        PIQ8w7NVJ5yKwZF9+zXNEKkmrTfG+kHCDDZ7YDIs6I+dMo8/z0RCONyZ+bs/G3b6
        xqYLdJ9im6RQaFzST0mmBp8Z1IWi+zyITweywFNzHkUMuYaCZgzx29+4rGgm1SeK
        2QCObX+BHFJJ9zuL3blaxWFH/YaWPpgiNlFMuBqgIqSpx2TKJEE/3EFq2uTkTonp
        7puC40w6ux0cNvHnizqDy5Axaf/dr63MgTxqqdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Wc5pFB
        9cFV9X8b0ifj+g9eVrc/4oE6DJhMyg+0grg+A=; b=mAMY3yQgFyL7v0JkB+Z5Xt
        Q0Phu/uVD2DDV/vumrI0ksP6fVHYfkkKefUjgJLfBSsyykYQlPs3vd9uT0uZ+B15
        xCb1JwNzkWsDZDkiMFZC6uOKnZ33exN7HxXyoalqe+qK59Dv8XYuVNaU4aaqnm2W
        nUa30n2/qR6CZbkhOGTJUiYzwnRxd/FLnhRCuhJFzxMKAQd+PF94iZEDWRYGBjRp
        hv4TsxwcZQ6n2Zq/4H6p9B/NQTDpFqV7V7L7mPrWJh5yrRL3i+zWaS5amfKAEKhh
        uZlpyOdwe/1New6zXP+X9QDBRhvultLuRAlmSExbfwbIO6i5up+zFrb7mLkIm0Rg
        ==
X-ME-Sender: <xms:vzyzXWP1TAy8NlAYydIdzKPpjZYvNdjKUxcmnlEF9aioEQ_vwwUMAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleefgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfeehmdenucfjughrpefofgggkfgjfhffhffvufgtsehttdertder
    redtnecuhfhrohhmpedfffgrnhhivghlucgiuhdfuceougiguhesugiguhhuuhdrgiihii
    eqnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiiinecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:vzyzXfVU8BDegvBYwVqciXIqkWyZ0qujezU-IPQnrTKJ3zlYJOWbiw>
    <xmx:vzyzXY3LXYaskd0cuydPDSE-E_Zo-pEnAj9NrP_n4K75ujq5Qi5E3A>
    <xmx:vzyzXQsUbLSYfRzJou2vZ9OJY9EfR2nbp5Zj53X3iQ-AVI_y2qRoMA>
    <xmx:wDyzXeQS53tOFMoQUhRoVWYGDBNyn0RJd-3--PaPttBbWonqXsfcsw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3B0EC188005C; Fri, 25 Oct 2019 14:19:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-470-gedfae93-fmstable-20191021v4
Mime-Version: 1.0
Message-Id: <f0f1d230-ad0f-49bd-a901-8b262e0441dc@www.fastmail.com>
In-Reply-To: <BXB3R6AZT2LR.2DHP9YCMGCTYJ@dlxu-fedora-R90QNFJV>
References: <BXB3R6AZT2LR.2DHP9YCMGCTYJ@dlxu-fedora-R90QNFJV>
Date:   Fri, 25 Oct 2019 11:19:14 -0700
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Peter Zijlstra" <peterz@infradead.org>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Andrii Nakryiko" <andriin@fb.com>, mingo@redhat.com,
        acme@kernel.org, "Alexei Starovoitov" <ast@fb.com>,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Kernel Team" <kernel-team@fb.com>, "Jiri Olsa" <jolsa@redhat.com>
Subject: Re: [PATCH bpf-next 1/5] perf/core: Add PERF_FORMAT_LOST read_format
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping :)
