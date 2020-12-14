Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDFA2DA026
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408547AbgLNTRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408575AbgLNTHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 14:07:43 -0500
Date:   Mon, 14 Dec 2020 11:07:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607972823;
        bh=Z+m7chx7dQcUeLkkrs9mkTCnY/CP8U29plYh9el7ZdQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=M90mPZ/VRL0TewEbq9x6hOtNcLXH+g/JLNbgx5lUBGY6hf4l2qMEGfFVzkC4BAbR5
         FpLiFrYHiWC+T8MUQ/t9cfpszKSpjfYOPmNkjsSV01iVVbGBt36pa8y75pRhDrQFSx
         zLgzPNXvNkHrQPiElIqloASbMpUO7ifs7rQhuLAjEfFjOfXdiF1tDZUY2ZR6RgsWHi
         4ydcQgZjARym6xnzVve8XYoP7ZfCdPPa8gNeGA0z0zoEIHsuF+Hms7zHcp+r8SXXRi
         SsQuufmgxZFp+XbEvRVVr89VRT4EAvPyCbssViuTB57eczJ6SG74/GBIA9qN8ZThgq
         VYKTMA/XQTuJQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonatan Linik <yonatanlinik@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Willem de Bruijn <willemb@google.com>,
        john.ogness@linutronix.de, Arnd Bergmann <arnd@arndb.de>,
        Mao Wenan <maowenan@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        orcohen@paloaltonetworks.com, Networking <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: Fix use of proc_fs
Message-ID: <20201214110700.538109b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+s=kw3xw-_Q846CigmygetaHXfr0KFHNsmO9a=Ww9Z=G6yT7w@mail.gmail.com>
References: <20201211163749.31956-1-yonatanlinik@gmail.com>
        <20201211163749.31956-2-yonatanlinik@gmail.com>
        <20201212114802.21a6b257@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+s=kw3gmvk7CLu9NyiEwtBQ05eNFsTM2A679arPESVb55E2Xw@mail.gmail.com>
        <20201212135119.0db6723e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+s=kw3xw-_Q846CigmygetaHXfr0KFHNsmO9a=Ww9Z=G6yT7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Dec 2020 11:48:15 +0200 Yonatan Linik wrote:
> > You're right, on a closer look most of the places have a larger #ifdef
> > block (which my grep didn't catch) or are under Kconfig. Of those I
> > checked only TLS looks wrong (good job me) - would you care to fix that
> > one as well, or should I?  
> 
> I can fix that as well, you are talking about tls_proc.c, right?

Yup, thanks!
