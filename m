Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46AC68A794
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 02:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjBDBpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 20:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjBDBph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 20:45:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED0CA07C0;
        Fri,  3 Feb 2023 17:45:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C00FDB82C66;
        Sat,  4 Feb 2023 01:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1310EC433D2;
        Sat,  4 Feb 2023 01:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675475132;
        bh=I8U/VjyHJ7l7ZsgbssM9zatOVYxZ0xpzIJmHYCGaKuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F0kc9C7Eb2EPEFzHRsxPhfiXPFMKCSYUFdDT/ZldPRG9NpdlPL96P+4GWTKJ9lFxP
         9/Q2CzvCiOmc5zdfwFPG56Kvpt5AOm0kOv91e9b/bcG/wHA7O+sqmlXw0KX+5f8+5L
         l5O3wIfwxwJd+WQ2O+zlxOcpfx6vLXudtIF3j1Eza2HK2MnX35ARq3Qyxnh40y1hzF
         1JsEvMhH9QNucmedOMXOPFkhhWA28KuQs8Ss7W21VKguiHx1hB8SCK8+xAfDR67gBX
         dMSBmhBLnk+lAee4lOhRMySNkDj3s2tVvGBSNK5h45+4LGImEMQk36MXUKfGQvJvlw
         tfrPLlhaaMzPQ==
Date:   Fri, 3 Feb 2023 17:45:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230203174531.5e3d9446@kernel.org>
In-Reply-To: <Y92kaqJtum3ImPo0@nvidia.com>
References: <20230202091312.578aeb03@kernel.org>
        <Y9vvcSHlR5PW7j6D@nvidia.com>
        <20230202092507.57698495@kernel.org>
        <Y9v2ZW3mahPBXbvg@nvidia.com>
        <20230202095453.68f850bc@kernel.org>
        <Y9v61gb3ADT9rsLn@unreal>
        <Y9v93cy0s9HULnWq@x130>
        <20230202103004.26ab6ae9@kernel.org>
        <Y91pJHDYRXIb3rXe@x130>
        <20230203131456.42c14edc@kernel.org>
        <Y92kaqJtum3ImPo0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 20:18:50 -0400 Jason Gunthorpe wrote:
> Wow, come down to earth a bit here, jeeze.
> 
> You are the maintainer of an open source subcomponent in Linux
> 
> I am the maintainer of an open source subcomponent in Linux
> 
> Gosh, they have some technological differences, but hey so does netdev
> vs NVMe too - are you also upset that NVMe is less pure than netdev
> because all the "crucial" flash management is proprietary?  Or suggest
> that we should rip out all the AWS, GCP and HyperV drivers because the
> hypervisor that creates them is closed source?

Perfectly irrelevant comparisons :/ How many times do I have to say
that all I'm asking is that you stay away from us and our APIs?

> Heck, we both have quite interesting employers that bring their own
> bias's and echo chambers.

My employer has no influence on my opinions and is completely
irrelevant here :/ I hope the same is true for you.

> Dave drew his line for netdev long ago, and I really respect that
> choice and his convictions. But don't act like it is "better" or
> somehow "more Linusy" than every other subsystem in the kernel.

We do have more restrictions for HW access than most subsystems. 
Whether that's better or worse depends on heuristic.

> > I don't think we can expect Linus to take a hard stand on this, but
> > do not expect us to lend you our APIs and help you sell your product.  
> 
> I think Linus has taken a stand. He is working on *Linux* not GNU
> Hurd. The difference is Linux welcomes all HW and all devices. Bring
> your open source kernel code and open source user space and you are
> welcome here.
> 
> Sure the community has lots of different opinions, and there is a
> definite group that leans in direction of wanting more open-ness
> outside the kernel too, but overall Linus has kept consistent and has
> not refused participation of HW on stricter ideological grounds.

I think that's accurate. Only dissent I'd like to register is for use
of "HW" when the devices I'm concerned with run piles and piles of FW.
To avoid misunderstanding prefer the term "device".

> "You are welcome here" is exactly why Linux dominates the industry and
> GNU Hurd is a footnote.
> 
> "help you sell your product" when talking about a fellow open source
> subsystem is an insulting line that has no business on these mailing
> lists.

Well, perhaps I should have s/you/vendors/. I'm not saying that either
of you is sales motivated. At the same time I advise more introspection.

> > Saying that RDMA/RoCE is not proprietary because there is a "standard"
> > is like saying that Windows is an open source operating system because
> > it supports POSIX.  
> 
> That is a very creative definition of proprietary.
> 
> If you said "open source software to operate standards based fixed
> function HW engines" you'd have a lot more accuracy and credibility,
> but it doesn't sound as scary when you say it like that, does it?

Here you go again with the HW :)

Maybe to you it's all the same because you're not interested in network
protocols and networking in general? Apologies if that's a
misrepresentation, I don't really know you. I'm trying to understand
how can you possibly not see the difference, tho.

> RDMA is a alot more open than an NVMe drive, for instance.

Certainly. Still, I don't see the relevance of the openness of NVMe 
to me as a network engineer.

> > My objectives for netdev are:
> >  - give users vendor independence
> >  - give developers the ability to innovate
> > 
> > I have not seen an RDMA implementation which could deliver on either.
> > Merging this code is contrary to my objectives for the project.  
> 
> The things we do in other parts of the kernel in no way degrade these
> activities for netdev. RDMA mirroring the netdev configurations is
> irrelevant to the continued technical development of netdev, or its
> ability to innovate.
> 
> We've never once said "you can't do that" to netdev because of
> something RDMA is doing. I've been strict about that, rdma is on the
> side of netdev and does not shackle netdev.

There were multiple cases when I was trying to refactor some code,
run into RDMA using it in odd ways and had to stop :/

> You've made it very clear you don't like the RDMA technology, but you
> have no right to try and use your position as a kernel maintainer to
> try and kill it by refusing PRs to shared driver code.

For the n-th time, not my intention. RDMA may be more open than NVMe.
Do your thing. Just do it with your own APIs.

> > > To summarize, mlx5_core is doing RoCE traffic processing and directs it to
> > > mlx5_ib driver (a standard rdma stack), in this series we add RoCE ipsec
> > > traffic processing as we do for all other RoCE traffic.  
> > 
> > I already said it. If you wanted to configure IPsec for RoCE you should
> > have added an API in the RDMA subsystem.  
> 
> Did that years ago.
> 
> https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/man/mlx5dv_flow_action_esp.3.md
> 
> HW accelerated IPSEC has been in RDMA and DPDK for a long time now,
> the mlx5 team is trying to catch up netdev because NVIDIA has
> customers interested in using netdev with ipsec and would like to get
> best performance from their HW.
> 
> We always try to do a complete job and ensure that RDMA's use of the
> shared IP/port and netdev use of the shared IP/port are as consistent
> as we can get - and now that it is technically trivial for mlx5 to run
> the RDMA IP traffic inside the HW that matches the netdev flows we
> will do that too.

see above

> It is really paranoid to think we somehow did all the netdev
> enablement just to get something in RDMA. Sorry, there is no
> incredible irreplaceable value there. The netdev stuff was a lot of
> difficult work and was very much done to run traffic originating in
> netdev.
> 
> Real customers have mixed workloads, and I think that's great. You
> should try looking outside the bubble of your peculiar hyperscaler
> employer someday and see what the rest of the industry is doing.

Frankly implying that my horizon is somehow limited to my employer
is insulting. Please stop. I've only worked at Meta since start of
the pandemic, and was a netdev maintainer before that.

> There is a reason every high speed NIC has a RDMA offering now,

Not every, but it's certainly a valuable feature from the commercial
perspective.

> a reason every major cloud has some kind of RDMA based networking
> offering and a reason I've been merging a couple new RDMA drivers
> every year.

Yes, that is a longer and indeed interesting conversation for another
time. I heard a bit about Amazon's and Google's RDMA both of which are
designed in house, so no loss of ability to innovate.

But please don't try to imply that TCP can't scale to high speeds.

> None of that activity takes away from netdev - it is not a zero sum
> game.

Its not a game at all.

> Even more importantly, for Linux, my multivendor open source
> community is every bit as legitimate as yours.

I don't know your community, can't comment.

> I appreciate your political leanings,

You're just baiting me now :)

> and your deep concern for netdev. But I have no idea why you care
> what RDMA does, and reject this absurd notion that the IP address,
> or APIs inside our shared Linux kernel are somehow "yours" alone to
> decide how and when they are used.

I do believe they belong to the netdev community. I don't know where
you'd draw the line otherwise.
