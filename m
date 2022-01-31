Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1436C4A4E7C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355254AbiAaSgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350350AbiAaSgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:36:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3850C06173B;
        Mon, 31 Jan 2022 10:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=tkcprD8q11wXEGoerUYRF6c0fmz23cMaQlku1S7qzJQ=; b=z4oifJJcA+AfLejma51hwzeRhr
        afYtw/NmVqdqeDHk4ge0IQ3Nm1oOLe0ZNGazRMW1w8cxI+hDmklVvxYeYOhY9Lo/jN+m/drar8q4v
        xIpcxCIFxtXLqN1BgEHGUsEbWTOgN9GwRHidg6d1rr0lIPmFFb4S/va/OqH1IHS+wSq94X0b+0TXB
        l9QwcFW5u8W+wUGL5UwF8kS69/n4HI2LdqJmX5LiI3kIteB6wR/OgQnxdcYGodmHwPgwPXFCi62lr
        oFJk9G/GZzHm/HdIkpPfEA3VJUs+viCFpA9s+zQY/xAoi/VVOSBeQOYB1WxuawfCYBt8XwVvWnP7i
        bxstiZaQ==;
Received: from [2001:4bb8:191:327d:83ae:cf0e:db3c:eb79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEbXd-00AOqz-MM; Mon, 31 Jan 2022 18:36:42 +0000
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
Subject: event more eBPF instruction set documentation improvements
Date:   Mon, 31 Jan 2022 19:36:33 +0100
Message-Id: <20220131183638.3934982-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series adds further improves the eBPF instruction set documentation.
It documents the byte swap instructions and polishes up the load and
store section.

Diffstat:
 instruction-set.rst |  215 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 151 insertions(+), 64 deletions(-)
