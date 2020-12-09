Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951AC2D4C47
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbgLIUz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:55:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14453 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729804AbgLIUz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 15:55:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd139970001>; Wed, 09 Dec 2020 12:54:47 -0800
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 9 Dec 2020 20:54:42 +0000
References: <cki.4066A31294.UNMQ21P718@redhat.com> <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com> <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com> <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com> <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com> <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org> <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
In-Reply-To: <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com>
Date:   Wed, 9 Dec 2020 22:54:40 +0200
Message-ID: <ygnhsg8ek8dr.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607547287; bh=mE9KAPYArifMWST5mxBKcbC+LI/egUE1GlqKJdGdC+4=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=QKzYEujc4Vh7J/AMwpce9x3n0Sid28rJ22SWBL0mGvPrjXkgyWpFVUVqw5GuoaRwc
         CNkiu0I9IjJ+/NRCHks8nKg8WF/egYv+CpjIa07ht3nH3ucMZjHWOcsjF0PAtuhxtp
         14bhwtOerIOOIEm8FPEMfyb5U6vdPt5USyufPtQRRe2skpBsTCZtOfidMnwtO8Vflp
         Q1uX0LLSRB+UvsZ0lQsq1KWoYZFOgDHbGQwrxCX4wcm73RHFXJnGTVLwDcKF1bItys
         YHD96/z0EpKGoNX1beWQcNgHHNfW+watqe6VTbX3NYvz080CJl9ToGEGMoYDmTnPZe
         EtBFEVa/9QlbA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 09 Dec 2020 at 20:50, Eric Dumazet <edumazet@google.com> wrote:
> On Wed, Dec 9, 2020 at 7:34 PM Saeed Mahameed <saeed@kernel.org> wrote:
>>
>> On Wed, 2020-12-09 at 19:05 +0100, Eric Dumazet wrote:
>> > On Wed, Dec 9, 2020 at 6:35 PM Eric Dumazet <edumazet@google.com>
>> > wrote:
>> > > Hmm... maybe the ECN stuff has always been buggy then, and nobody
>> > > cared...
>> > >
>> >
>> > Wait a minute, maybe this part was not needed,
>> >
>> > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
>> > index
>> > 8ae9ce2014a4a3ba7b962a209e28d1f65d4a83bd..896a7eb61d70340f69b9d3be0f7
>> > 95fbaab1458dd
>> > 100644
>> > --- a/drivers/net/geneve.c
>> > +++ b/drivers/net/geneve.c
>> > @@ -270,7 +270,7 @@ static void geneve_rx(struct geneve_dev *geneve,
>> > struct geneve_sock *gs,
>> >                         goto rx_error;
>> >                 break;
>> >         default:
>> > -               goto rx_error;
>> > +               break;
>> >         }
>> >         oiph = skb_network_header(skb);
>> >         skb_reset_network_header(skb);
>> >
>> >
>> > > On Wed, Dec 9, 2020 at 6:20 PM Jakub Kicinski <kuba@kernel.org>
>> > > wrote:
>> > > > Eric, could this possibly be commit 4179b00c04d1 ("geneve: pull
>> > > > IP
>> > > > header before ECN decapsulation")?
>> > > >
>>
>> We've bisected an issue in our CI to this patch, something about geneve
>> TC offload traffic not passing, I don't have all the details, Maybe
>> Vlad can chime in.
>>
>
> Yes, I think the patch I sent should fix this, ETH_P_ARP should not be
> dropped ;)
>
> I am testing this before offical patch submission.
>
> Thanks !

Hi Eric,

Your patch fixed TC geneve tests for me, but some of more complex OVS
tests are still failing. I'll try to provide details tomorrow.

Regards,
Vlad

