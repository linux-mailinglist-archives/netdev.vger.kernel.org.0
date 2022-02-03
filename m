Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B5F4A8839
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbiBCQBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbiBCQBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:01:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC190C061714;
        Thu,  3 Feb 2022 08:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AEDD611CB;
        Thu,  3 Feb 2022 16:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DADC340E8;
        Thu,  3 Feb 2022 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643904071;
        bh=5kczdKTMoX76feLuZmuxkNuEpdZUqjoDwEN1wHNC5BU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVdx8bk/OQBNl2g1PkMWk6VFuj0hmsWgrVvbPP1vJvc6cDQhklsFrfubykXMx8+mb
         wr9cGovrUFHNbB5cwQgGz2Oc6kvKPPQ3YgLctdF//TqN86XtkTHAOR9vPMbkiBum8s
         BfDOmKqxEKqiHrYQ0TRCGuO8oWrwIfRoCEbYJPxSnynrun01OP1SzidkqNVop5IJsp
         3wqGZo4+gxCB2s9wttN75GTGwm9yrssHxxP84D6ycxFZt9a4HTxp9wgWupKqDdloA0
         U3Lmbrk/6F3B5EbrQQlgDNXavpszHWFe8twEVDoWEtrkQzoFOu/HE1+w9luDRKxl3E
         kc+GzJZP571wQ==
Date:   Thu, 3 Feb 2022 17:01:04 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of
 standalone ports
Message-ID: <20220203170104.1cca571d@thinkpad>
In-Reply-To: <20220203135606.z37vulus7rjimx5y@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
        <20220131154655.1614770-2-tobias@waldekranz.com>
        <20220201170634.wnxy3s7f6jnmt737@skbuf>
        <87a6fabbtb.fsf@waldekranz.com>
        <20220201201141.u3qhhq75bo3xmpiq@skbuf>
        <8735l2b7ui.fsf@waldekranz.com>
        <20220203135606.z37vulus7rjimx5y@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 15:56:06 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Tue, Feb 01, 2022 at 10:22:13PM +0100, Tobias Waldekranz wrote:
> > No worries. I have recently started using get_maintainers.pl to auto
> > generate the recipient list, with the result that the cover is only sent
> > to the list. Ideally I would like send-email to use the union of all
> > recipients for the cover letter, but I haven't figured that one out yet.  
> 
> Maybe auto-generating isn't the best solution? Wait until you need to
> post a link to https://patchwork.kernel.org/project/netdevbpf/, and
> get_maintainers.pl will draw in all the BPF maintainers for you...
> The union appears when you run get_maintainer.pl on multiple patch
> files. I typically run get_maintainer.pl on *.patch, and adjust the
> git-send-email list from there.
> 
> > I actually gave up on getting my mailinglists from my email provider,
> > now I just download it directly from lore. I hacked together a script
> > that will scrape a public-inbox repo and convert it to a Maildir:
> > 
> > https://github.com/wkz/notmuch-lore
> > 
> > As you can tell from the name, it is tailored for plugging into notmuch,
> > but the guts are pretty generic.  
> 
> Thanks, I set that up, it's syncing right now, I'm also going to compare
> the size of the git tree vs the maildir I currently have.

Hi Vladimir, please let me know the results.
Marek
