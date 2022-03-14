Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95FD4D8E03
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbiCNUSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbiCNUSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:18:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8483533EB0;
        Mon, 14 Mar 2022 13:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=cVkMS+Fa/xX+53DYlYjjDSiEa2X0IZrbhmQUrlvfDEQ=;
        t=1647289053; x=1648498653; b=KtVidyiYVztZ3NXubBweyD1NC0Fn+O7jZDRixv4xg9ZhcaS
        u9YhCMjF1oLxKSTkeugbFT63Q0mqCPHv5kboBQcmwxZ/PxfmJkp/E62It2fQe5zLoJKblSUUDv7qb
        gbM9pOHnLU1SoFhIjZcYmDpOSL5Zt5EcQD5YO9Nu663Ml8kesOvTSZcp1642BVfXkapI5udE32555
        paaz/Dk0W3/R8TzenT0xS8HetwEgm+2vdAniAiltRmOw3/jlFkQ2D1rsRrfsF2FwTiDURi7UBOE/W
        +5HPpM796hTknuJOzl+Wtn2V0gAY4DT24fwEhVZSG1h2SMUeRtSG4FQAptyX16tg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nTr8E-00DD64-TF;
        Mon, 14 Mar 2022 21:17:31 +0100
Message-ID: <6d37b8c3415b88ff6da1b88f0c6dfb649824311c.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2022-03-11
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Mon, 14 Mar 2022 21:17:30 +0100
In-Reply-To: <20220314113738.640ea10b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
         <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
         <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <87sfrkwg1q.fsf@tynnyri.adurom.net>
         <20220314113738.640ea10b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-14 at 11:37 -0700, Jakub Kicinski wrote:
> On Mon, 14 Mar 2022 20:21:53 +0200 Kalle Valo wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> > 
> > > On Fri, 11 Mar 2022 17:06:25 -0800 Jakub Kicinski wrote:  
> > > > Seems to break clang build.  
> > > 
> > > No, sorry just some new warnings with W=1, I think.  
> > 
> > I have not installed clang yet. You don't happen to have the warnings
> > stored someplace? I checked the patchwork tests and didn't see anything
> > there.
> 
> Yeah.. patchwork build thing can't resolve conflicts. I wish there was
> a way to attach a resolution to the PR so that the bot can use it :S
> 

That'd be on thing - but OTOH ... maybe you/we could somehow attach the
bot that processes things on the netdev patchwork also to the wireless
one? It's on the same patchwork instance already, so ...

But I do't know who runs it, how it runs, who's paying for it, etc.

johannes
