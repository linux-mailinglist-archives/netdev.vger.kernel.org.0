Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1040302A
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347091AbhIGVVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243883AbhIGVVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2FA760F70;
        Tue,  7 Sep 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049610;
        bh=y4MtEnAQkUBnqYlXn4+fKLJaWh4I7BtXMyuW9PWLfww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=If6Kbrxe394FEqFourgXMcvZWy0yI9xpdyfHKjbizjMD0CEKWmgCZqbHfXb+QwqJ2
         8pYoRxiORmKOG2l5vOHr5lFa5Acoy3TpK7l+wEbhlHiG+IzNaUa8kbztIK5GFuflEP
         MnH9wMC5OlGBHFBO9wcjjzlbSTkq9tg/qAinyEJpVvOi+qODZe8bdPRuuzikSlkIpg
         FoceSoWEOUswi3wZkKEu+tWhz6WIxbtsRGlrmbDJYzJ9dmzsDx4bTpP/UtREmWGSwA
         iRvV2NULlYcsdDztPsypqzQa2gs9qQNk3kOuUH3cOAXHPv3xWtFaaLxrqcXGFRr5Cn
         +F6MSbRFm/yVA==
Date:   Tue, 7 Sep 2021 14:20:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marco Elver <elver@google.com>,
        syzbot <syzbot+8322c0f0976fafa0ae88@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bp@alien8.de, davem@davemloft.net,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] net build error (3)
Message-ID: <20210907142008.333c8a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <73b64f16-a8d0-cd1e-c08f-dbc3cf493e5a@gmail.com>
References: <000000000000cdb6a905cb069738@google.com>
        <CANpmjNP2JEyFO_d9Dxkw5h6WQL70AhDsxkyoFTizvo+n3Ct3Tg@mail.gmail.com>
        <73b64f16-a8d0-cd1e-c08f-dbc3cf493e5a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Sep 2021 13:56:15 -0700 Florian Fainelli wrote:
> On 9/3/2021 1:14 AM, Marco Elver wrote:
> > #syz fix: x86/setup: Explicitly include acpi.h
> > 
> > On Thu, 2 Sept 2021 at 19:34, syzbot
> > <syzbot+8322c0f0976fafa0ae88@syzkaller.appspotmail.com> wrote:  
> 
> David, Jakub can you cherry pick that change into net/master, today's 
> net/master tree was still failing to build because of this.
> 
> Thanks!

I posted a PR earlier today, I'll forward our trees as soon as Linus
pulls.
