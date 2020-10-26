Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332FA29907B
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783106AbgJZPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:06:21 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5650 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783094AbgJZPGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:06:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f96e5f00000>; Mon, 26 Oct 2020 08:06:24 -0700
Received: from reg-r-vrt-018-180.nvidia.com (10.124.1.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 26 Oct 2020 15:06:10 +0000
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com> <877drn20h3.fsf@buslov.dev> <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com> <87362a1byb.fsf@buslov.dev> <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com> <ygnh8sc03s9u.fsf@nvidia.com> <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com> <ygnh4kml9kh3.fsf@nvidia.com> <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com> <ygnh7drdz0nf.fsf@nvidia.com> <0112061b-6890-9f22-bec4-d24a2d67d882@gmail.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Vlad Buslov <vlad@buslov.dev>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-Reply-To: <0112061b-6890-9f22-bec4-d24a2d67d882@gmail.com>
Date:   Mon, 26 Oct 2020 17:06:07 +0200
Message-ID: <ygnhzh4958o0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603724784; bh=bsPE4KDuTYIfH4Qwm6+hIG0dVZJ1iMpOOaW9P6VACLU=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=jaEbT0xQIjA+EJwArJk+YYc99BACnydfcerSBvZpQT3Y29QTHSZ76NW0bf7NuKwBo
         dtoKq32/Xh2SyrcWYs6DbMM1BxIPlXJboG0Q75823fIZ38kresdmW+tmLPuG2ZODWL
         rIeLBXleirRb+C+X0r+aavNpTa5fTmgqycA0raF3tszTIybuWmfdDQKIdyEldKONNq
         bfYMyVf1L64fAEvvzloMzchmRL+EZ+eKh/Vur9mhltpoVnPyRPUhldJkADNbOat6G/
         sHbgNIWm4Bo/5lDjNxLdn8aNnkdlUq6Gr0XaryoRkUyuLB78DYW+rcDpEB5jQO4kUY
         +mgsJnWcyHhxA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 26 Oct 2020 at 16:52, David Ahern <dsahern@gmail.com> wrote:
> On 10/26/20 5:28 AM, Vlad Buslov wrote:
>> Patch to make cookie in filter terse dump optional? That would break
>> existing terse dump users that rely on it (OVS).
>
> Maybe I missed something in the discussions. terse dump for tc has not
> been committed to the tree yet, so there are no users relying on it.

What do you mean? Kernel terse dump flag and implementation have been
committed long time ago and are now present in released kernels.

