Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F1947445D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhLNOEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhLNOEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:04:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06EEC06173F;
        Tue, 14 Dec 2021 06:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=VqYovDH3Z3x9g3qdiHOsjCVSdJhRCUd9MY5YGW/ZIbQ=; b=U26mEnlM+tRg+YaeBhS88fUQVM
        eN9rr2BRhEjQqHOtNZ0NFgc1ePKMsjNBrC7GGxknfxCS5xwul4xZAKcT2AxqJv1ZkhECWvV2VarDy
        KDL9V7AybdNdheWYTPYwADeaacwfOhF2gXMAbwd0sAPvX+7XMe9kUHeVpOdS06ZkQT91cEVW4I8Mw
        hWeG9XpaJpqUqtQ2o1f1TlpSb9iKu7vZjmdvVZW/kMEHrBqrfLdsVX3nEthiRfmx6f4/2QPfwF3PM
        EcxcwmUxK19+/G8neagCiJAbZm2fE3xldp4ia8P3Wiu9/qf6veYNrv5qw9QsL+mIwlF537u3kd3bU
        W2hxSZYA==;
Received: from [2001:4bb8:180:a1c8:4ccb:3bf7:77a2:141f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx8PU-00DlVF-CQ; Tue, 14 Dec 2021 14:04:05 +0000
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
Subject: improve the eBPF documentation
Date:   Tue, 14 Dec 2021 15:03:58 +0100
Message-Id: <20211214140402.288101-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series first splits the eBPF introductions from the
instruction set document to then drop the classic BPF
documentation from this file to focus on eBPF and to
cleanup the structure and rendering of this file a bit.

Diffstat:
 index.rst           |    1 
 instruction-set.rst |  510 +++++++++++++++-------------------------------------
 intro.rst           |  238 ++++++++++++++++++++++++
 3 files changed, 387 insertions(+), 362 deletions(-)
