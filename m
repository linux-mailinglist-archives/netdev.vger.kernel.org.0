Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BF62DB877
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgLPBgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:36:03 -0500
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:39080 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgLPBgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 20:36:02 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id 8C4CC8195C;
        Wed, 16 Dec 2020 04:35:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1608082520; bh=ox/5CkOm2k8D24Kavof+L3UZuPtQ5hNrYwo5IIXSXXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuV7RuZyM5/b4/d7VqnwgSBaMowFY2GalAmJWX8/zUEWByzLjorfFuuMH+fox/J83
         nCG93CQyeHIIVEVEbpmem48avXNkP75OQC6b4nkwKDB4C81NYFY9cTJoGgLzAnKVP2
         R0oAGmm3o8WhYYRro7f3ZP0UQq/k1Tj2Ep0py1N9D1wyg09/e9TgCd95j8LGpLa2c+
         ZUnG6qByAxEbmgwIsaqjIvOjY94GALWjpbi6r/0mf+JAnRp2FaxeslRYhgpEbqSNOU
         dOO3RDiiBChB7hbe79AofDsp2UnlfNjQkDvAAOScRUxD7d1bUowyDTzEeSDmKcGIoV
         BvynJgb1zg54A==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org, andrew@lunn.ch,
        Markus.Elfring@web.de, thesven73@gmail.com,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] lan743x: fix for potential NULL pointer dereference with bare card
Date:   Wed, 16 Dec 2020 04:35:04 +0300
Message-ID: <1721393.xWxZJfhTyO@metabook>
In-Reply-To: <20201215171242.622435e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201215161252.8448-1-sbauer@blackbox.su> <160807555409.8012.8873780215201516945.git-patchwork-notify@kernel.org> <20201215171242.622435e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, December 16, 2020 4:12:42 AM MSK Jakub Kicinski wrote:
> On Tue, 15 Dec 2020 23:39:14 +0000 patchwork-bot+netdevbpf@kernel.org
> 
> wrote:
> > Hello:
> > 
> > This patch was applied to bpf/bpf.git (refs/heads/master):
> > 
> > On Tue, 15 Dec 2020 19:12:45 +0300 you wrote:
> > > This is the 4th revision of the patch fix for potential null pointer
> > > dereference with lan743x card.
> > > 
> > > The simpliest way to reproduce: boot with bare lan743x and issue
> > > "ethtool ethN" command where ethN is the interface with lan743x card.
> > > Example:
> > > 
> > > $ sudo ethtool eth7
> > > dmesg:
...
> > > [...]
> > 
> > Here is the summary with links:
> >   - [v4] lan743x: fix for potential NULL pointer dereference with bare
> >   card
> >   
> >     https://git.kernel.org/bpf/bpf/c/e9e13b6adc33
> > 
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> Heh the bot got confused, I think.
> 
> What I meant when I said "let's wait for the merge window" was that
> the patch will not hit upstream until the merge window. It's now in
> Linus's tree. I'll make a submission of stable patches to Greg at the
> end of the week and I'll include this patch.
> 
> Thanks!

I think, firstly the bot was confused by me :-\
I should have asked you what exactly did you mean with "let's wait for the 
merge window"...
That's completely my fault, sorry for that.

                                Regards,
                                        Sergej.



