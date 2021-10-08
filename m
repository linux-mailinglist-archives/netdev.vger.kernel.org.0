Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B724273CD
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 00:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243563AbhJHWiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 18:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243505AbhJHWiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 18:38:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8642560F92;
        Fri,  8 Oct 2021 22:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633732580;
        bh=5TkGu593n6AXbhZ3jIJSi0bLBKW8b3JvSVKzjuppsT4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hwQSs1vkG78ye7FJ50kxtZ9bHHEfE+DZp/5qC9HpzaewFZQ7u7+fvZx7aq5oMuQg7
         AbtdIZbuM/64gkdNEABKM849WP5jxMeMXv1ePwZcMOu4bTTyWHgzriGFVTUL4JOsBU
         ZGynVfq1OGjORu5VA3y8o3DkWlzjgb2/8b9FlYu4cua2LTazNB4Zi+fBNAaH2Ea4VI
         XDCuHepuMWdafpwF+TW2CO/4MsBlkx23DlomtxUGMzkhx0W/8xNeplekEV9tuvJ6DF
         0lTQNGZSWiRMRukVnfTcWT6UzRe403mFgXKSzRIazTNmgWBM/IHNY5NyFsV3pW2NgS
         RroPH+BJZgBjg==
Date:   Fri, 8 Oct 2021 15:35:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
Message-ID: <20211008153536.65b04fc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
        <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 21:43:32 +0000 Keller, Jacob E wrote:
> > > Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
> > > really dry run. I guess that user might be surprised in that case...  
> > 
> > Would it be enough to do a policy dump in user space to check attr is
> > recognized and add a warning that this is required next to the attr
> > in the uAPI header?  
> 
> Doesn't the policy checks prevent any unknown attributes? 
> Or are unknown attributes silently ignored?

Did you test it?

DEVLINK_CMD_FLASH_UPDATE has GENL_DONT_VALIDATE_STRICT set.
