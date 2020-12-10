Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710A02D558A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388083AbgLJIgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:36:03 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7274 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388080AbgLJIf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 03:35:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd1ddc30000>; Thu, 10 Dec 2020 00:35:15 -0800
Received: from reg-r-vrt-018-180.nvidia.com (10.124.1.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Thu, 10 Dec 2020 08:35:10 +0000
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com> <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com> <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com> <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com> <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org> <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com> <ygnhsg8ek8dr.fsf@nvidia.com> <20201209142256.3e4a08fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        netdev <netdev@vger.kernel.org>, <skt-results-master@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
Subject: Re: =?utf-8?Q?=E2=9D=8C?= FAIL: Test report for kernel 5.10.0-rc6
 (mainline.kernel.org)
In-Reply-To: <20201209142256.3e4a08fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Thu, 10 Dec 2020 10:35:08 +0200
Message-ID: <ygnhpn3ijbyb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607589315; bh=dYMgR5JWbpwXgDhYbH3fiEwS2fQQ7c524CzZ7SVuMsg=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=JZ2EdYfz9SJtdih01reTtRj4HC8irGydgEg3Si+iyGTfHHGXFViMnO6vojVdYmgOH
         6RnKad1NQ0/fNClECgZhIU0J3VJIVWKm8Dv8RjoqZTf4AWWyYhVsjpEHf3bpC8wC0G
         4Wz5IwYtKQ44urke+xmcrVY6sNgJZrmtiPqwaMUyPfyA0QvGiNnduxMUD9QwU10eax
         upolgd1oTe0mUn7wnLTfK1xStGDaX/DERKfqvsCuXVc13SuNqlytn72sh5P/yX7Ulg
         jOS43Zf/SpIAlk/aHlpdIMHYytCmsESzjRIL6J4K1ZRX3LHHZcAjuy9Ueyfe2hvG2J
         Y3SktEAXEJDZA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 10 Dec 2020 at 00:22, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 9 Dec 2020 22:54:40 +0200 Vlad Buslov wrote:
>> > Yes, I think the patch I sent should fix this, ETH_P_ARP should not be
>> > dropped ;)
>> >
>> > I am testing this before offical patch submission.
>> 
>> Your patch fixed TC geneve tests for me, but some of more complex OVS
>> tests are still failing. I'll try to provide details tomorrow.
>
> Does a revert of Eric's patch fix it? For OvS is could also well be:
> 9c2e14b48119 ("ip_tunnels: Set tunnel option flag when tunnel metadata is present")

The tests pass with Eric's commit reverted.

