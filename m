Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F203E2D4D81
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388380AbgLIWXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388259AbgLIWXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:23:38 -0500
Date:   Wed, 9 Dec 2020 14:22:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607552577;
        bh=ViCxzEw/T1ZQS8KrPRfAAn6bHOFrINs6a4Xk6EqMPoE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=IE0XwkVAkDoKrCEp3/SpVIh+eRnZzfV/mnN75MD83IgWqMiJb5C68vVd8od1Xcx01
         BDITIlap3GS9Thl1uuhbGwXaSL0pHP4EirO9PPiOuVV/weTbu1bd6K9GvoCwugl8uN
         0f8K+Jdi4oQo3EyF5zlTZoXxWYDKBPoy6MvjfL9xI4xre0DKqVYxRa5hEnxFXPuZbK
         n4FgM2NM3CawyTyDreOvEHJ1WExqRwji0LOVHE/gwbqh+kzuXayCEe/F7YWpr4T3km
         LH0F1EACEHG3WedyFb0qJ/c3PnkV/XVqHhcy89N2nC5ZExzczgiqf6y+bK6XaUFEfc
         1AMDQlyeVgDAg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
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
Subject: Re: =?UTF-8?B?4p2M?= FAIL: Test report for kernel 5.10.0-rc6
 (mainline.kernel.org)
Message-ID: <20201209142256.3e4a08fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <ygnhsg8ek8dr.fsf@nvidia.com>
References: <cki.4066A31294.UNMQ21P718@redhat.com>
        <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
        <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
        <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
        <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
        <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
        <CANn89iK+fU7LGH--JXx_FLxawr7rs1t-crLGtkbPAXsoiZMi8A@mail.gmail.com>
        <ygnhsg8ek8dr.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 22:54:40 +0200 Vlad Buslov wrote:
> > Yes, I think the patch I sent should fix this, ETH_P_ARP should not be
> > dropped ;)
> >
> > I am testing this before offical patch submission.
> 
> Your patch fixed TC geneve tests for me, but some of more complex OVS
> tests are still failing. I'll try to provide details tomorrow.

Does a revert of Eric's patch fix it? For OvS is could also well be:
9c2e14b48119 ("ip_tunnels: Set tunnel option flag when tunnel metadata is present")
