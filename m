Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43824815F7
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 19:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241181AbhL2SD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 13:03:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhL2SD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 13:03:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CBC361536;
        Wed, 29 Dec 2021 18:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ABDC36AE7;
        Wed, 29 Dec 2021 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640801007;
        bh=16dWv9yAnLvURJrC8UI+OtoeQ7xeLanB2HzdtpzDUfA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EnYBjOfmgf1ciVGW5SwHW3ZM90GO4hdZoordZ8fNTKrHeoZwAiL8S3/9EmwrrJp+R
         61Egro6s2BGOKTT6Xh4p/fmnwY66Kh34UNfdEdN0AKfzWgrfdttJ7DGktVpI9Xxl/N
         pZAp/wg0OH6BmQ1QhQFd33mIo1fEretm2oWMk8rzBj48OdQxMt6Bd9eCIaNNo0vSh+
         joMIUkr04U9Pd1rujSPyUcLQEPFjrSI+sLrcdbBEPU0sIx7kRBMeskTXTnXK9cHXXP
         EXHRWHgIIxxzxNIlAtZgm7c1/a/W0qjNgBAbLXtsT74KScC/zuhiS5FQjypQEB50GB
         wj/wiaQlyLu5A==
Date:   Wed, 29 Dec 2021 10:03:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Loftus, Ciara" <ciara.loftus@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] xsk: Initialise xskb free_list_node
Message-ID: <20211229100326.4f398952@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAADnVQJFu+yvWu9D=mzJ45sF8ncGhfFFUg43Edg_Qzown3pRsg@mail.gmail.com>
References: <20211220155250.2746-1-ciara.loftus@intel.com>
        <CAJ8uoz2-jZTqT_XkP6T2c0VAzC=QcENr2dJrE5ZivUx8Ak_6ZA@mail.gmail.com>
        <PH0PR11MB479171AF2D4CE0B118B47A208E7C9@PH0PR11MB4791.namprd11.prod.outlook.com>
        <CAJ8uoz3HYUO_NK+GCHtDWiczp-pDqpk6V+f5X5KkAJqN70nAnQ@mail.gmail.com>
        <20211221122149.72160edc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQJFu+yvWu9D=mzJ45sF8ncGhfFFUg43Edg_Qzown3pRsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 19:04:10 -0800 Alexei Starovoitov wrote:
> > My $0.02 would be that if all relevant commits form a chain of fixes
> > it doesn't matter much which one you put in the tag. To me your
> > suggestion of going with 199d983bc015 makes most sense since from a
> > cursory look the direct issue doesn't really exist without that commit.
> >
> > Plus we probably don't want 199d983bc015 to be backported until we
> > apply this fix, so it'd be good if "Fixes: 199d983bc015" appeared in
> > linux-next.
> >
> > You can always put multiple Fixes tags on the commit, if you're unsure.  
> 
> It sounds that the fix should get into net and linus tree asap?
> In such a case mabe take it into net directly?

Ack
