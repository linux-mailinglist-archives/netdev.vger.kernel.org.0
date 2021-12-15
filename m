Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F02475D15
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244592AbhLOQNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:13:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39904 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244629AbhLOQM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:12:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB1FE619AF
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A34C36AE1;
        Wed, 15 Dec 2021 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639584778;
        bh=vHtc3XjYUIpVHxpMFHGRjm/XuIsMa/i1pf02RKwdF2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eg17/PtKGtP+z3Q6Yjvkloc8UpLb1usLpvM/m3hpH1MgB9+OgEiDSQFLFkKEqBLoD
         eAMs/k8hAru27HELmj3PcpxMRlHKmJS3il70OR7R8EHjbIfol+mrNIB2ZXDXC/CgUB
         9+xtPggEmQE+kO8Mye2I7AdG9lV+cTDWP6aakaqkQ/oxwmC867bHMk8N3k7wXARjnP
         bzKrW8Y1WIn9Rkygq/lOhepShcm6/C0n/tFRej6YN9xzE/tF7tmgxhUqj+QlEsobFf
         +F+yf+Grju1WQFR+HC1Ka2HpZfuIBnZCn5IQuuOp2ymxWyc/lZAYOC4sO/uDnq+9qE
         Aqy8Hrz1o4XCQ==
Date:   Wed, 15 Dec 2021 08:12:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next v3 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
Message-ID: <20211215081256.6f61d92d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMDZJNXF6C8xc-PDUq6rRSKyq0Eg6ywhY1SPuqNvYcO2S4ocZQ@mail.gmail.com>
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
        <20211210023626.20905-3-xiangxia.m.yue@gmail.com>
        <CAMDZJNXF6C8xc-PDUq6rRSKyq0Eg6ywhY1SPuqNvYcO2S4ocZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 09:34:15 +0800 Tonghao Zhang wrote:
> Do you have any comment=EF=BC=9FWe talk about this patchset in this threa=
d.
> Should I resend this patchset with more commit message ?

Patch 1 LGTM, minor nits on patch 2, I'd side with Jamal=20
in the discussion.
