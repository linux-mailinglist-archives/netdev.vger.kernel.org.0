Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB4429A603
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 09:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508596AbgJ0IAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 04:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390164AbgJ0IAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 04:00:12 -0400
Received: from coco.lan (unknown [95.90.213.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BC82224E;
        Tue, 27 Oct 2020 08:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603785611;
        bh=XAql63pKUX6s4hxGe+dS12y311hL1/XWQiKxGStrVis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1i75/fswjGGmJRRS5Bw1xSU65pvHidYPbMB+zmxNAyJsrJQJUSmNQGfbjkW5OQlLz
         0y3NgvRaghfKoRs4bCoy6m81ud2U2x3mtlx272fX053nviRizyVzgSUSlAeEro+EA9
         B6rrrUYoVmMDbwshkSb8l5gWnklQ4FtGq/AKAlhY=
Date:   Tue, 27 Oct 2020 09:00:02 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 21/56] mac80211: fix kernel-doc markups
Message-ID: <20201027090002.4a9bace4@coco.lan>
In-Reply-To: <bee691201828c96cb5ac678d8ab65e8ecd934364.camel@sipsolutions.net>
References: <cover.1603469755.git.mchehab+huawei@kernel.org>
        <978d35eef2dc76e21c81931804e4eaefbd6d635e.1603469755.git.mchehab+huawei@kernel.org>
        <bee691201828c96cb5ac678d8ab65e8ecd934364.camel@sipsolutions.net>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 27 Oct 2020 08:26:20 +0100
Johannes Berg <johannes@sipsolutions.net> escreveu:

> On Fri, 2020-10-23 at 18:33 +0200, Mauro Carvalho Chehab wrote:
> > Some identifiers have different names between their prototypes
> > and the kernel-doc markup.
> > 
> > Others need to be fixed, as kernel-doc markups should use this format:
> >         identifier - description
> > 
> > In the specific case of __sta_info_flush(), add a documentation
> > for sta_info_flush(), as this one is the one used outside
> > sta_info.c.  
> 
> Are you taking the entire series through some tree, or should I pick up
> this patch?

Feel free to pick the patch. IMO, this should work better for
those patches, as it should help avoiding potential merge
conflicts.
> 
> If you're going to take it:
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for reviewing it!

> 
> johannes
> 
> 



Thanks,
Mauro
