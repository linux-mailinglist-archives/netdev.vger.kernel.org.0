Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB973483704
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbiACSgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbiACSgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:36:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AF1C061761;
        Mon,  3 Jan 2022 10:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=wk3KhHMV4lZeSivBj3jKfjwwWW4Nlc9rCKddeJFkp5Y=; b=3i5XVv7qNe4ZmvEuG0rdKdJZqi
        wUTqvlUbcpRHtjGAjWZP7ODSsue3ZHhI+H6gvRdPUEk0skJ3bTmOeJJqPCJ6AhbBWAXGYUD+WA7NW
        1vskliYNd+JuEh4L2SkqcgVL9/8sIdKplzORXz7J8zpXVyquCq7/muhcYQuMFRPQlQFiAeY6QEJgo
        kqRDUwPr9vvSs1yv1W80xh64Kq8R85Sgo2hRdRLH9DuOyAqVpWl6jCItsGkANPihB9dmWs2ousPW4
        P+d1iREB0Ols3DvcpBS4r39VLH2SOW3nSGT1FZxtORIi529czijA8yQ3yUagV2IcjbFVRT6eRYZYJ
        qjaesabg==;
Received: from [2001:4bb8:184:3f95:b8f7:97d6:6b53:b9be] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4SBc-009qQs-TK; Mon, 03 Jan 2022 18:36:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: more eBPF instruction set documentation improvements
Date:   Mon,  3 Jan 2022 19:35:50 +0100
Message-Id: <20220103183556.41040-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series adds further improves the eBPF instruction set documentation.
Mostly it adds descriptions to the various tables as requested by
Alexei, but there are a few other minor tidyups as well.

Diffstat:
 instruction-set.rst |  156 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 91 insertions(+), 65 deletions(-)
