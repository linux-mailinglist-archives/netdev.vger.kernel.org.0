Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97EC4BB073
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiBRD7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:59:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiBRD7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:59:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4C4FD08;
        Thu, 17 Feb 2022 19:58:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17913B82555;
        Fri, 18 Feb 2022 03:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5FCC340E9;
        Fri, 18 Feb 2022 03:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645156732;
        bh=+7Hj7oyxrzQUnw7hd9+0M8yasZ77tgOV/E6/yQXbfmk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s+fBTWBf3qpXV+6haVc5lJRA8IeZKKJCDxPDj1MRzrFLwzMpV8Lhn/r72LpYKBGNj
         TUvWbY2CivWrR/U+aF13ng/f3XvQDi1WLTO7t0URG39A7mISq2dWKrVWQS1nUph8WU
         fN7ADlbGO3TfdzY9tp+/6Y0mJvYZxUFdyjB1IyG4+xODruBJEM/E6N6yMgxv1JU6qn
         69hbKgTW25IRM2ggDm8i10oKbafLMyo/ItK6PR9omnJ/B/JcNTq/I64QLnnALyE/ra
         WwRA5qmj+mdbYRPiD/s9spbHkng7vcW5FUDREXtvLaMZIKZ3M1DNVmPGwXUhz/+s5q
         MkWcDIaerJuBA==
Date:   Thu, 17 Feb 2022 19:58:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        patchwork-bot+netdevbpf@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: confused pw-bot. Re: pull-request: bpf-next 2022-02-17
Message-ID: <20220217195850.05b6e939@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQLK-Y+eTBrqTjKoSE2FHf2U0yDWJ1PXG1=_MAb9WnkFYg@mail.gmail.com>
References: <20220217232027.29831-1-daniel@iogearbox.net>
        <164514875640.23246.1698080683417187339.git-patchwork-notify@kernel.org>
        <20220217174650.5bcea25a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQLK-Y+eTBrqTjKoSE2FHf2U0yDWJ1PXG1=_MAb9WnkFYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 18:20:07 -0800 Alexei Starovoitov wrote:
> On Thu, Feb 17, 2022 at 5:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 18 Feb 2022 01:45:56 +0000 patchwork-bot+netdevbpf@kernel.org
> > wrote:  
> > > Hello:
> > >
> > > This pull request was applied to bpf/bpf.git (master)  
> >
> > :/ gave me a scare. No, it's not pushed, yet, still building.  

Pushed now.

> Wow. pw-bot gots things completely wrong :)
> 
> It replied to Daniel's bpf-next PR with:
> "
> This pull request was applied to bpf/bpf.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> Here is the summary with links:
>   - pull-request: bpf-next 2022-02-17
>     https://git.kernel.org/bpf/bpf/c/7a2fb9128515
> "
> that link points to my bpf PR that Jakub landed 8 hours earlier
> into net tree.
> 
> I ffwded bpf tree half an hour ago.
> I guess that's what confused the bot.
> 
> Konstanin, please take a look.

Presumably PRs should be quite trivial thing to handle since:

  for you to fetch changes up to d24d2a2b0a81dd5e9bb99aeb4559ec9734e1416f:
                                 ^^^^^^^^^^^^
                                 this
ends up:

commit a3fc4b1d09d99cdb6a7dbba5a753db15a10b2e9c
Merge: 2aed49da6c08 d24d2a2b0a81 <= here
                    ^^^^^^^^^^^^
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Thu Feb 17 17:23:51 2022

    Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
    
    Daniel Borkmann says:
    
    ====================
    bpf-next 2022-02-17


I'm curious if there's something I'm missing, or it's simply a matter 
of the unrelenting finiteness of a working day :)
