Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D689432A42D
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379213AbhCBKVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 05:21:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48520 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382771AbhCBKPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:15:04 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lH22Y-0003K9-EC; Tue, 02 Mar 2021 10:14:06 +0000
Date:   Tue, 2 Mar 2021 11:14:04 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 2/4] nsfs: add an ioctl to discover the network
 namespace cookie
Message-ID: <20210302101404.ns3t7oow4a565l7a@wittgenstein>
References: <20210210120425.53438-1-lmb@cloudflare.com>
 <20210210120425.53438-3-lmb@cloudflare.com>
 <20210301100420.slnjvzql6el4jlfj@wittgenstein>
 <CACAyw9_P0o36edN9RiimJBQqBupMWwvq746+Mp1_a=YO3ctfgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACAyw9_P0o36edN9RiimJBQqBupMWwvq746+Mp1_a=YO3ctfgw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 09:47:10AM +0000, Lorenz Bauer wrote:
> On Mon, 1 Mar 2021 at 10:04, Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Hey Lorenz,
> >
> > Just to make sure: is it intentional that any user can retrieve the
> > cookie associated with any network namespace, i.e. you don't require any
> > form of permission checking in the owning user namespace of the network
> > namespace?
> >
> > Christian
> 
> Hi Christian,
> 
> I've decided to drop the patch set for now, but that was my intention, yes. Is
> there a downside I'm not aware of?

It depends on whether this cookie is in any way security or at least
information sensitive. For example, would leaking it between
unprivileged containers with different user+network namespace pairs
allow one container to gain access to information about the other
container that it shouldn't.

Christian
