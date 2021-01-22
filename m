Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A6A300958
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbhAVRMV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jan 2021 12:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbhAVRL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 12:11:27 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDC6C06174A;
        Fri, 22 Jan 2021 09:10:45 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4DMm440hJdzQlXV;
        Fri, 22 Jan 2021 18:10:44 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id QNJYTFKJSUwS; Fri, 22 Jan 2021 18:10:40 +0100 (CET)
Date:   Fri, 22 Jan 2021 18:10:36 +0100
From:   Loris Reiff <loris.reiff@liblor.ch>
Subject: Re: [PATCH 2/2] bpf: cgroup: Fix problematic bounds check
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
References: <20210122164232.61770-1-loris.reiff@liblor.ch>
        <20210122164232.61770-2-loris.reiff@liblor.ch>
        <CAKH8qBtOVr_y2r2dSC+p7E1jfehXsh-RUdNLeo3n7zquMzogBw@mail.gmail.com>
In-Reply-To: <CAKH8qBtOVr_y2r2dSC+p7E1jfehXsh-RUdNLeo3n7zquMzogBw@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <1611335290.xzns3v78m5.astroid@localhost.localdomain.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.00 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9E09117CC
X-Rspamd-UID: b2379c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Excerpts from Stanislav Fomichev's message of January 22, 2021 18:04:
> Thanks! I assume this is only an issue if the BPF program is written
> incorrectly.

Yes exactly.
