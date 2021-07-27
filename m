Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691883D7539
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhG0Mmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhG0Mma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 08:42:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A81C061757;
        Tue, 27 Jul 2021 05:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1xxPIZzwnUCYdIgCzjeIvifN5KI2/48eyHiiOas8Njw=; b=pAC+vmFgqg6OQ4sHwUtWijpcB/
        u2WL9Et9YUG8LVvi/trCTP2DXHK+8hqfID8wzV5jCJ26NqRRK0cIUKilASn7/jExlSQUmwJFczPfs
        IO/ElggiatF1tbMR43XmZ0fzLp9RGf4MbsrtPnoHcsgmiRMZvjuYynYOdIGrvYXjl9+5ajS++qPtg
        OICyVwKxpfEIo2qtLW2dJfk3Rdxq+z//y1oazsj6StrygQeppuaTWaxtD2AgjlmpmoyqMGj5ODZEg
        pJudGcLCyCQJGRoPC1h0nkZyP0jxsgYGIrSU3PXhw4WVa7O8t4QZNNBQ6ffenp4p/+QhADyVuPrdR
        hdnBVPyw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8MPk-00Ekef-Qj; Tue, 27 Jul 2021 12:42:28 +0000
Date:   Tue, 27 Jul 2021 05:42:28 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intersil: remove obsolete prism54 wireless driver
Message-ID: <YP//NPZbVXZ5efZJ@bombadil.infradead.org>
References: <20210713054025.32006-1-lukas.bulwahn@gmail.com>
 <20210715220644.2d2xfututdoimszm@garbanzo>
 <6f490ee6-4879-cac5-d351-112f21c6b23f@gmail.com>
 <87mtq8guh7.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtq8guh7.fsf@codeaurora.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 09:07:48AM +0300, Kalle Valo wrote:
> Christian Lamparter <chunkeey@gmail.com> writes:
> 
> > On 16/07/2021 00:06, Luis Chamberlain wrote:
> >> On Tue, Jul 13, 2021 at 07:40:25AM +0200, Lukas Bulwahn wrote:
> >>> Commit 1d89cae1b47d ("MAINTAINERS: mark prism54 obsolete") indicated the
> >>> prism54 driver as obsolete in July 2010.
> >>>
> >>> Now, after being exposed for ten years to refactoring, general tree-wide
> >>> changes and various janitor clean-up, it is really time to delete the
> >>> driver for good.
> >>>
> >>> This was discovered as part of a checkpatch evaluation, investigating all
> >>> reports of checkpatch's WARNING:OBSOLETE check.
> >>>
> >>> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> >>> ---
> >
> > noted. Farewell.
> 
> How do we know that there are no users left? It's surprising how ancient
> hardware some people use. Is the driver broken or what?
> 
> (Reads commit 1d89cae1b47d)
> 
> Ah, p54 is supposed to replace prism54. Does that include all the
> hardware supported by prism54?

There was a one off chipset someone told me about long ago that p54
didn't work for. But that persond disappeared from the face of the
earth. Additionally, distributions have been blacklisting prism54
for years now.

> If yes, that should be clearly documented
> in the commit log and I can add that.

Agreed. Feel free to quote the above.

  Luis
