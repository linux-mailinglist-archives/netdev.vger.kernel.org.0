Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB2C2D4E56
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388308AbgLIWvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgLIWvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:51:31 -0500
Date:   Wed, 9 Dec 2020 14:50:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607554251;
        bh=I45NDmN0CflrzyHUD2tHu+gh412DP5MBpk1G2gkSLN0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=moEZHTaSVwUVMN75YBjr7OKqo4GvZnu+FP1VaGakUbl9BHY3EfvSydDEjygPAQ3l6
         GUdgDw5yAFTkfeBIfA4SyPA0kri8aevYsk8AI6c+zIlexY70oh4uRAP/Ztbd+JWpLq
         t3P5pw8wMzTgBM8se+EbIGaZiPZILIbKRFE0XvG4IRsryyy5fEsGmcB1sJ0bB2R0DM
         8I+gS7zH0+wEjdElQyQg+2RcDD/hO9Pq6p/p0sncVT5QNJRg/Xd0nu7cesS3Jf8ChL
         O8Cs/FqGvAaFvNHCoRRLRryWe1wVq3NRg10uf40TjB/0LQuXBdzzBmoWtTajiEo5xB
         dsL4cdAWT4BIA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        netdev <netdev@vger.kernel.org>, skt-results-master@redhat.com,
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
Subject: Re: =?UTF-8?B?4p2M?= FAIL: Test report for kernel 5.10.0-rc6
 (mainline.kernel.org)
Message-ID: <20201209145048.3af1fd9a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CANn89iJVWfb=2i7oU1=D55rOyQnBbbikf+Mc6XHMkY7YX-yGEw@mail.gmail.com>
References: <cki.4066A31294.UNMQ21P718@redhat.com>
        <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
        <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
        <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
        <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
        <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
        <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com>
        <ygnhsg8ek8dr.fsf@nvidia.com>
        <CANn89iJVWfb=2i7oU1=D55rOyQnBbbikf+Mc6XHMkY7YX-yGEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 22:07:54 +0100 Eric Dumazet wrote:
> > Your patch fixed TC geneve tests for me, but some of more complex OVS
> > tests are still failing. I'll try to provide details tomorrow.
> 
> I think I need to study a bit more the original syzbot report.
> 
> Apparently, network header should have been pulled already before
> hitting geneve_rx()
> 
> Jakub, please revert my patch, I need to fix the syzbot issue differently.

Done!
