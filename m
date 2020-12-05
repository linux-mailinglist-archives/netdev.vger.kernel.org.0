Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64C62CFDB2
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgLESmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:42:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbgLEQ45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 11:56:57 -0500
Date:   Sat, 5 Dec 2020 08:56:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607187366;
        bh=eYK2sVwutlChKihLleNVWiUi78sQBhnha5Lia/JugEk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=vMEN6qm/NY0zywdKx2ToXvTfnuHiO3H2aQZqbvE0CRZ7TVKJ0yvjmIBIONtYwMWba
         YLl7gaW2CRwIsO/xb/4VbCmNjegduBOz8f/uV41Zxdlw7RcE1+A7jSSQYcK81ubKVj
         7jTIHCoR+wk5wCcF+sEJ8KW/VN5cYqeJJVbfzo3AmYCB8akLA7NFgCPUUzO1FQCTQx
         kjT1NMAWQshhIllcbcLtqsitlVu5YmRbjzDtQYozUAozstFMU+3mMSl8p/bK54g5ma
         RKcO5OW7xC9qefs9dh3A2M8rahxLe8kCtew2cYQFjauuNtrxHXYUA8VrqbFDlBqSfR
         Eq5raUj3FwnQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     linux-kernel@vger.kernel.org,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, marcel@holtmann.org,
        johan.hedberg@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jmaloy@redhat.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH 2/7] net: batman-adv: remove unneeded MODULE_VERSION()
 usage
Message-ID: <20201205085604.1e3fcaee@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <4581108.GXAFRqVoOG@sven-edge>
References: <20201202124959.29209-1-info@metux.net>
        <20201202124959.29209-2-info@metux.net>
        <4581108.GXAFRqVoOG@sven-edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 05 Dec 2020 08:06:40 +0100 Sven Eckelmann wrote:
> On Wednesday, 2 December 2020 13:49:54 CET Enrico Weigelt, metux IT consult wrote:
> > Remove MODULE_VERSION(), as it isn't needed at all: the only version
> > making sense is the kernel version.  
> 
> Is there some explanation besides an opinion? Some kind goal which you want to 
> achieve with it maybe?
> 
> At least for us it was an easy way to query the release cycle information via 
> batctl. Which made it easier for us to roughly figure out what an reporter/
> inquirer was using - independent of whether he is using the in-kernel version 
> or a backported version.
> 
> Loosing this source of information and breaking parts of batctl and other 
> tools (respondd, ...) is not the end of the world. But I would at least know 
> why this is now necessary.

No, no, if it breaks your user space we can't do it, let's leave batman
alone, then.

I think this is mostly a clean up. In-tree the kernel version is usually
far more dependable because backports don't include version bumps.

Indeed it would be great if the clear motivation was spelled out in the
cover letter and/or patches.
