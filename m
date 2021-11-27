Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CE745F788
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 01:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbhK0AqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 19:46:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34716 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236288AbhK0AoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 19:44:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F32A3B8294F
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 00:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B788C004E1;
        Sat, 27 Nov 2021 00:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637973664;
        bh=7LJ8BQQEKVjSZiDvuNGenITIhO45YlZ5flOivCHUc5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EVmHR5EciK5oVgB2QqEJu/9a8N3vaL64fE1YEQtvry8QIVxvW5gBBDwJlRIS3GjO2
         tBCpaW+BKkioBriL7r7g3JlT81/KlcUU9ftaNJ/P225GNosPWoPtfpY3OTODtDUcWR
         0SbZny6w+xwHUCIXeURgo7nN9pU1hP6teX23szDW7CsV55BrmlXvzRQEzuqBaJFqe6
         Vf3nd7GzmAf2AnFb30fmPZSnz6sZ5T6k3Clx2A1g2+lxxIbpwfmByWtdTYwmbvnvLV
         dcq0lMFayLdXjlN+2Tajt+gRMTOmf0JiJxY3gKnqY0YhNe87CAWnkonXiXih+voP6l
         HkYH+arwiKZmA==
Date:   Fri, 26 Nov 2021 16:41:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/2] qed*: enhance tx timeout debug
 info
Message-ID: <20211126164102.358d0a0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY3PR18MB46121917AA9B79B570F58637AB639@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211124094303.29390-1-manishc@marvell.com>
        <20211124094303.29390-2-manishc@marvell.com>
        <20211124185131.2cd860d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY3PR18MB46121917AA9B79B570F58637AB639@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 22:04:03 +0000 Manish Chopra wrote:
> > Please consider using devlink health if you want to communicate more data to
> > the user  
> 
> It's not really that huge logs/data, these are just very basic metadata (few prints) about the TX queues logged to system logs.
> Those can be looked easily from dmesg/var-log-messages files which can be made available conveniently.
> Rest are the mailbox commands posted to management firmware with those basic information about the queues.

Right, I meant "more" as in if it keeps growing in the future, not
necessarily to replace this patch.

> > > +/**
> > > + * qed_int_get_sb_dbg: Read debug information regarding a given SB
> > > + *
> > > + * @p_hwfn: hw function pointer
> > > + * @p_ptt: ptt resource
> > > + * @p_sb: pointer to status block for which we want to get info
> > > + * @p_info: pointer to struct to fill with information regarding SB
> > > + *
> > > + * Return: Int  
> > 
> > What's the point of documenting the return type?  
> 
> For ./scripts/kernel-doc, I will put some suitable description. 

I don't think it requires documenting return value. All arguments -
yes, but not documenting return value is fine. So you can as well
remove it, up to you.
