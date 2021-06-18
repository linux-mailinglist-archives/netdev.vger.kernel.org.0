Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFD53ACDC8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhFROrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhFROrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:47:45 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2CBC061574;
        Fri, 18 Jun 2021 07:45:36 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4ED9A3F0;
        Fri, 18 Jun 2021 16:45:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1624027534;
        bh=FKW8njs2kRxwujOeLiKCOtR02ayGsBBQd4ozlsxBPgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e6LGAjCwsJEBTVeYtXVlga8VEXmBged5TLW/vxGPoRKpVwz339fBFl580b5Bh8ouV
         NZDKaY0xeGXBAYf3ZZo1x3Z2tZKgxgQJqVGNWp63kcVfBteGp4xGprqgC2NoqmyF2U
         K3D+hIZBNWW2IWUDa+qxLwsB6JMn/rSrOFJXG0FU=
Date:   Fri, 18 Jun 2021 17:45:10 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
Message-ID: <YMyxdnz0Ol/wMF/e@pendragon.ideasonboard.com>
References: <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
 <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
 <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home>
 <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
 <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
 <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
 <CAMuHMdVcNfDvpPXHSkdL3VuLXCX5m=M_AQF-P8ZajSdXt8NdQg@mail.gmail.com>
 <20210618103214.0df292ec@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210618103214.0df292ec@oasis.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 10:32:14AM -0400, Steven Rostedt wrote:
> On Fri, 18 Jun 2021 16:28:02 +0200 Geert Uytterhoeven wrote:
> 
> > What about letting people use the personal mic they're already
> > carrying, i.e. a phone?
> 
> Interesting idea.
> 
> I wonder how well that would work in practice. Are all phones good
> enough to prevent echo?

That could be solved by isolating attendees in different rooms. That way
people could even attend remotely. Oh, wait... :-)

> It is something that needs to be tested out first before making it
> officially used.

-- 
Regards,

Laurent Pinchart
