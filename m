Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3D647E13E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347653AbhLWKTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhLWKTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 05:19:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D49EC061401;
        Thu, 23 Dec 2021 02:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=VHzQbI+tDjPBjgZdxLqZI7T6VrPoD6xS4Gsf5ogXyeQ=; b=CaxRVHjVl67BAiv245QvOsbIPP
        MCMjB5jQ9KMoUqIIaFjEtbqXpE4X1u8jh/CdFVSONFc4M3pms5yVPIKYPG2OfrDqhp7Wmm0LnHP+W
        aP0jFQ7yzxiOEKY+chDWQQOSfktAiaf1XMhwm56eCApPqaepQtelsXUdEV8cBBarArBA8wXLceU0n
        O2SZ7hPGOKlk6MinIml4LuovCgxiN5Qze4LA12QeK2QxV4cpqcBUsmzLv4CszhZqX+YmCI0oENxWA
        bneOIGZqn3rUBlE56BPQc0zq9WLc3sGSp1t5r3otTWXSOQ21RjXt/NvTOPlK9wM4wt1qL6Z+SxXVt
        JXLPcVCg==;
Received: from [46.183.103.8] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0LBk-00CTku-Fk; Thu, 23 Dec 2021 10:19:08 +0000
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
Subject: improve the eBPF documentation v2
Date:   Thu, 23 Dec 2021 11:19:02 +0100
Message-Id: <20211223101906.977624-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series first splits the eBPF introductions from the
instruction set document to then drop the classic BPF
documentation from this file to focus on eBPF and to
cleanup the structure and rendering of this file a bit.

Changes since v1:
 - rename intro.rst to classic_vs_extended.rst
 - keep the class vs eBPF tabls in classic_vs_extended.rst
 - a few more editorial tidyups
 - move the packet access instructions last in instruction-set.rst

Diffstat:
 classic_vs_extended.rst |  376 +++++++++++++++++++++++++++++++++++
 index.rst               |    1 
 instruction-set.rst     |  514 ++++++++++++++----------------------------------
 3 files changed, 527 insertions(+), 364 deletions(-)
