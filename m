Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC89DCEB2
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394322AbfJRSuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbfJRSuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 14:50:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 128BE20640;
        Fri, 18 Oct 2019 18:50:01 +0000 (UTC)
Date:   Fri, 18 Oct 2019 14:49:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yonghong Song <yhs@fb.com>, YueHaibing <yuehaibing@huawei.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Fix build error without CONFIG_NET
Message-ID: <20191018144959.11aee74b@gandalf.local.home>
In-Reply-To: <20191018184629.GD26267@pc-63.home>
References: <20191018090344.26936-1-yuehaibing@huawei.com>
        <ee9a06ec-33a0-3b39-92d8-21bd86261cc2@fb.com>
        <20191018142025.244156f8@gandalf.local.home>
        <20191018184629.GD26267@pc-63.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 20:46:29 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> It's related to bpf-next, so only bpf-next is appropriate here. We'll
> take it.

OK, thanks!

-- Steve
