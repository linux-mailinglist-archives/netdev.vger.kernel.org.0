Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EA436B5FF
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhDZPnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234134AbhDZPnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 11:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A585661175;
        Mon, 26 Apr 2021 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619451741;
        bh=0kclcnTguSSCCuue6c8aJWUctbEWcIhaxM+ax4wq+S4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q0aZJqiA80mSgPWiGf1BXo1eDoI7jAhuuxomIVjttJQzJfoHSMcoGgYmCSVnVhR4q
         S0Vh02ZKR14LC4ucDVm93/ZoeKfaEc73XDBtVmIn49qu6eA8THqbLY3daCwc63S+Sa
         mVcBTDdZyvTodBeXy0vt/SFC0zZ/CSbOqE4izbhL4YYOA9Vb4JqIAVDb7J9o8VBqSn
         fZbJs4g8Vqg9W5dZBEwVQu9GYYswh/ot2ylv+7NsxK6nYT0C+QjX1kXaV0wq8bnBTt
         Ki89ZiYqMSyyeT3/j0a1stIc7MwA92rftQH2YVk+QJlYsWrGyWVcZhHdJy8rW1O7Lw
         qlN3JWaGTPfyw==
Date:   Mon, 26 Apr 2021 08:42:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net-next] net/sched: act_vlan: Fix vlan modify to allow
 zero priority
Message-ID: <20210426084219.4ab4c700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210425105713.GA12968@builder>
References: <20210421084404.GA7262@noodle>
        <20210421121241.3dde83bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210425105713.GA12968@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Apr 2021 13:57:13 +0300 Boris Sukholitko wrote:
> On Wed, Apr 21, 2021 at 12:12:41PM -0700, Jakub Kicinski wrote:
> > On Wed, 21 Apr 2021 11:44:04 +0300 Boris Sukholitko wrote:  
> > > This electronic communication and the information and any files transmitted 
> > > with it, or attached to it, are confidential and are intended solely for 
> > > the use of the individual or entity to whom it is addressed and may contain 
> > > information that is confidential, legally privileged, protected by privacy 
> > > laws, or otherwise restricted from disclosure to anyone else. If you are 
> > > not the intended recipient or the person responsible for delivering the 
> > > e-mail to the intended recipient, you are hereby notified that any use, 
> > > copying, distributing, dissemination, forwarding, printing, or copying of 
> > > this e-mail is strictly prohibited. If you received this e-mail in error, 
> > > please return the e-mail to the sender, delete it from your computer, and 
> > > destroy any printed copy of it.  
> > 
> > Could you please resend without this legal prayer?  
> 
> Please accept my apologies. Apparently the "legal prayer" is added
> automatically to all outgoing Broadcom emails and I have no control over its
> existance.

Perhaps try resending from a personal email account? There are folks at
broadcom who communicate using the corporate address, perhaps they could
help you?

> Is there any way to regard it as a non-netiquette compliant, but
> nevertheless a personal signature? AFAICT, it does not affect the patch
> in question.

If the signature had no implications in legal sense the lawyers
wouldn't ask for it to be included. Code submitted to for inclusion
needs to be licensed under a FOSS license.
