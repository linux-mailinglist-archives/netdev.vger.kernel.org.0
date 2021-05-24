Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BD938E1D1
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 09:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhEXHgJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 May 2021 03:36:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5745 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhEXHgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 03:36:09 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FpTQw6HGNzmkS6;
        Mon, 24 May 2021 15:31:04 +0800 (CST)
Received: from dggema724-chm.china.huawei.com (10.3.20.88) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 15:34:39 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema724-chm.china.huawei.com (10.3.20.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 15:34:39 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2176.012;
 Mon, 24 May 2021 15:34:39 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "quentin@isovalent.com" <quentin@isovalent.com>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] bpftool: Add sock_release help info for cgroup attach
 command
Thread-Topic: [PATCH] bpftool: Add sock_release help info for cgroup attach
 command
Thread-Index: AQHXUGxZWDgEH59s4U2IxO0jYOh6Qqrxs7+AgACG/cA=
Date:   Mon, 24 May 2021 07:34:39 +0000
Message-ID: <de161c23b4154616ae24fc51bfc16fa2@huawei.com>
References: <20210524071548.115138-1-liujian56@huawei.com>
 <YKtT337G53rMDiAH@kroah.com>
In-Reply-To: <YKtT337G53rMDiAH@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, May 24, 2021 3:21 PM
> To: liujian (CE) <liujian56@huawei.com>
> Cc: ast@kernel.org; daniel@iogearbox.net; andrii@kernel.org; kafai@fb.com;
> songliubraving@fb.com; yhs@fb.com; john.fastabend@gmail.com;
> kpsingh@kernel.org; quentin@isovalent.com; sdf@google.com;
> netdev@vger.kernel.org; bpf@vger.kernel.org
> Subject: Re: [PATCH] bpftool: Add sock_release help info for cgroup attach
> command
> 
> On Mon, May 24, 2021 at 03:15:48PM +0800, Liu Jian wrote:
> > Fixes: db94cc0b4805 ("bpftool: Add support for
> > BPF_CGROUP_INET_SOCK_RELEASE")
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> > ---
> >  tools/bpf/bpftool/cgroup.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> I know I do not take patches without any changelog text, maybe other
> maintainers are more leniant...

Sorry, I will send v2 for the bad habits.  Thank you ~
