Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18445239C2E
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 23:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgHBVfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 17:35:32 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:43140 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgHBVfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 17:35:32 -0400
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id A289A2E14D5;
        Mon,  3 Aug 2020 00:35:30 +0300 (MSK)
Received: from unknown (unknown [::1])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id bKAelsdSuu-ZRsSV0xG;
        Mon, 03 Aug 2020 00:35:30 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596404130; bh=7qIAgVBmjj+WaM3ROfUyEJ6axdUSA1+b0g8ckx+8pow=;
        h=Message-Id:Cc:Subject:In-Reply-To:Date:References:To:From;
        b=xk0j1DJ5OyIZCnQ7oTeDDEQMi1q5Qvab5nDpFw7+flNc3BucgoqkK9sxMFmxBkTA5
         bIxD9G93xhJqKyOXQBBspShcX3t9JdxJr5GNIF8n+7tPKpLydcBNbmsZbVNTLovjzh
         aON0kH5+EfBMgo8ulaOC+nT2jsWf4Cz19oTUYQwk=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
X-Yandex-Sender-Uid: 1120000000093952
Received: by sas1-1199a7868807.qloud-c.yandex.net with HTTP;
        Mon, 03 Aug 2020 00:35:27 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Cc:     "sdf@google.com" <sdf@google.com>
In-Reply-To: <20200802213026.78731-1-zeil@yandex-team.ru>
References: <20200802213026.78731-1-zeil@yandex-team.ru>
Subject: Re: [PATCH bpf-next v4 0/2] bpf: cgroup skb improvements for bpf_prog_test_run
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Mon, 03 Aug 2020 00:35:27 +0300
Message-Id: <71711596403951@mail.yandex-team.ru>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, forgot to bump version in cover letter subject. I will resend it.

03.08.2020, 00:30, "Dmitry Yakunin" <zeil@yandex-team.ru>:
> This patchset contains some improvements for testing cgroup/skb programs
> through BPF_PROG_TEST_RUN command.
>
> v2:
>   - fix build without CONFIG_CGROUP_BPF (kernel test robot <lkp@intel.com>)
>
> v3:
>   - fix build without CONFIG_IPV6 (kernel test robot <lkp@intel.com>)
>
> v4:
>   - remove cgroup storage related commits for future rework (Daniel Borkmann)
>
> v5:
>   - check skb length before access to inet headers (Eric Dumazet)
>
> Dmitry Yakunin (2):
>   bpf: setup socket family and addresses in bpf_prog_test_run_skb
>   bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb
>
>  net/bpf/test_run.c | 39 ++++++++++++++++++++++--
>  tools/testing/selftests/bpf/prog_tests/skb_ctx.c | 5 +++
>  2 files changed, 42 insertions(+), 2 deletions(-)
>
> --
> 2.7.4
