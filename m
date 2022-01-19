Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D649E4932E0
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 03:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350921AbiASCXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 21:23:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39076 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238636AbiASCXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 21:23:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 749FC61506;
        Wed, 19 Jan 2022 02:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95225C340E1;
        Wed, 19 Jan 2022 02:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642559002;
        bh=QgEW3xNpdwDtRw5/e6ekKpsxXoSw5KoB6xPzyK+YHXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OhmLDUWaf8LoEyRPSk/EsOH5OEwhnmZWAyeTOykXMXfGYQH3cZvYYLGQmTtqEPnl/
         EKDhSNUmBsRbXtI2UztIC2waV203H2ESGv5Huf2aDyEM0EdPpRc7KCFXTvIr5RU6Ug
         U4qRgO6WN38PxEMuPAgZ7GIoPkFLouQDQyO5mLLB0MUvb+PiGDJ3WCzdrIXPaJArAc
         DCqXh36eItgfXsPtKL6cFNPuG2DNPF6K+k8dPqJJzgFb9S6d40RBcpVjSIZfSGX8OH
         HauLIysJzfuStJCnArwwE+ou0SG/npC6QZTtSawKVQMAypN2T+SiEB4XqK30jEjfEI
         0Z11krahN6ctg==
Date:   Tue, 18 Jan 2022 18:23:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xu xin <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xu.xin16@zte.com.cn, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] ipv4: Namespaceify min_adv_mss sysctl knob
Message-ID: <20220118182321.194b57ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220119020427.929626-1-xu.xin16@zte.com.cn>
References: <20220118112148.3e1acad4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220119020427.929626-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 02:04:27 +0000 xu xin wrote:
> > > From: xu xin <xu.xin16@zte.com.cn>
> > > 
> > > Different netns have different requirement on the setting of min_adv_mss
> > > sysctl that the advertised MSS will be never lower than. The sysctl
> > > min_adv_mss can indirectly affects the segmentation efficiency of TCP.
> > > 
> > > So enable min_adv_mss to be visible and configurable inside the netns.
> > > 
> > > Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>  
> > 
> > CGEL ZTE, whatever it is, is most definitely not a person so it can't
> > sign off patches. Please stop adding the CGEL task, you can tell us
> > what it stands for it you want us to suggest an alternative way of
> > marking.  
> 
> CGEL ZTE is a team(or project) focusing on Embedded Linux System. With
> the support of the team, I can devote myself to the development and 
> maintenance of the kernel and related patch work.
> 
> I'm not sure how to mark it here accurately. I am willing to hear your
> suggestions.

What I've seen done in the past is adding the name of your team/project
after your name, in parenthesis, so it'd be something like:

Signed-off-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>

Similarly for your other colleagues, for example:

Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Some Intel, Oracle and VMware employees follow a similar pattern.
