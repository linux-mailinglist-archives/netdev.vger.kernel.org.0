Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989171785C7
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgCCWkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:40:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgCCWkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 17:40:45 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C9712072A;
        Tue,  3 Mar 2020 22:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583275244;
        bh=v7vFcwr5pMyUMACZBzCSBhaMZIJ9/S2FdllZ8czhOAk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hvO5MvTQR7YBcgwEQRdsyjRjuhMEO5YirGeSEwBmqkuK8GJ/aozsjvQy3FNb29u24
         oz+dutSxWdAA1xOP3XIjYLs+f0+Dbc26IDNApiiBf860n+9zSPE0txVe6IbuB1LTTw
         UqhsSodfYkiFw7QxptWl8PPj8gMBfa3g7Eqrss/4=
Date:   Tue, 3 Mar 2020 14:40:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200303144042.226dda27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87pndt4268.fsf@toke.dk>
References: <20200228223948.360936-1-andriin@fb.com>
        <87mu8zt6a8.fsf@toke.dk>
        <CAEf4BzZGn9FcUdEOSR_ouqSNvzY2AdJA=8ffMV5mTmJQS-10VA@mail.gmail.com>
        <87imjms8cm.fsf@toke.dk>
        <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
        <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
        <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
        <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
        <87pndt4268.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Mar 2020 21:24:31 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> I can see how the bpf_link abstraction helps by providing a single
> abstraction for all the tracing-type attachments that are fd-based
> anyway; but I think I agree with Daniel that maybe it makes more sense
> to keep it to those? I.e., I'm not sure what bpf_link adds to XDP
> program attachment? The expected_prev_fd field to replace a program
> could just as well be provided by extending the existing netlink API?

+1
