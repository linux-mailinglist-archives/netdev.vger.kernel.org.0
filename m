Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953FE460038
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 17:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbhK0Qhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 11:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbhK0Qfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 11:35:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4056C061574;
        Sat, 27 Nov 2021 08:32:23 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638030740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GZvVDx4SLV0ZlxNGlpAB1UsnTh8jqn1OEreuU3ILtTg=;
        b=HwkYuxv1h2ZXPoA1nfTCif/nvj8TPr0pUiU/vE+AH+24EigR4NE+XntT5FXaJdK6WBa+c+
        BKMdBtNYHqrXxB9iC+M2nhn4N9/T5iuySl9fbcIomlIFXmBk7rWICH7AqSH899dD1eY0bF
        z/JZh+40gtTkw9rPrI7x1jJd6OfzumSDu9ALRtHpoY/itgUelAc9+Nw8l4ts1i+dz7BdJC
        SUk6R7AaNKuliSOHJYUPLE7uy0KqXu/DGox+C0Xj+roT3Yk6gmjOspdtNZggB831Z45Ujl
        be8EdxTvdcMpvUBAJjWGgrkdk2ixSlYIKKR3mpQnP9kHS/WSa/UCTAE5kgPxSA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638030740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GZvVDx4SLV0ZlxNGlpAB1UsnTh8jqn1OEreuU3ILtTg=;
        b=Oxmr03AAbIVvBd1mhQevKZRDjNDhNI3O5WrXCS9B7STwvVNuyB1iGLFYIQBoUaGIrl6bfZ
        Lzi8pn8ZnAui5SDg==
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] Update non-RT users of migrate_disable().
Date:   Sat, 27 Nov 2021 17:31:58 +0100
Message-Id: <20211127163200.10466-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While browsing through code I noticed outdated code/ documentation
regarding migrate_disable() on non-PREEMPT_RT kernels.

Sebastian

