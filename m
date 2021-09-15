Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E28E40BDC9
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhIOC3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhIOC3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 22:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADDE61131;
        Wed, 15 Sep 2021 02:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631672897;
        bh=wrESkK+A6pJf6sSL1ntWooGUWYIub5LxG6B56o4mieA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nr2FsFomV/KuFGn1OsB1I2tyuuQ3eKqAMkESClzw6C5fIJp1RfLeK0w7ixDQARILR
         zwpuFnuHK8f5PRnPGBx3Z+uk9hdQTzuhbSJVSzUomeMeCFxRn3Pj8UZb/liRzf5EWA
         E/v0M+tddjVnW6j8S7vdmHmCveWixbJp9B84+toBxNkau4P6StLOLitfzT3BaJgH8l
         S81d7hfKqQCwZo4f8mop1IDt4hb52qHJxm8J3JxwQcKOKp2qxIY5ixovf365KkQsRB
         ksRW7EpTdoZikXAIzFBPIxLtc+8vdq8zHLA8UPdnae93VEkoqPQeeTAHWG/hUwSriy
         kaWJOHpt8pVzg==
Date:   Tue, 14 Sep 2021 19:28:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shai Malin <smalin@marvell.com>, Adrian Bunk <bunk@kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bnx2x: Fix enabling network interfaces without VFs
Message-ID: <20210914192815.0376cb73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SJ0PR18MB3882AD2C9F93E24C35A2E6FECCD99@SJ0PR18MB3882.namprd18.prod.outlook.com>
References: <SJ0PR18MB3882AD2C9F93E24C35A2E6FECCD99@SJ0PR18MB3882.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Sep 2021 11:18:33 +0000 Shai Malin wrote:
> On 9/12/2021 at 1:42PM, Adrian Bunk Wrote:
> > On Mon, Sep 13, 2021 at 08:14:33AM +0000, Shai Malin wrote:  
> > > Thanks for reporting this issue!
> > > But the complete fix should also not use "goto failed".
> > > Instead, please create a new "goto skip_vfs" so it will skip
> > > the log of "Failed err=".  
> > 
> > Is this really desirable?
> > It is a debug print not enabled by default,
> > and trying to enable SR-IOV did fail.  
> 
> I agree.
> 
> Acked-by: Shai Malin <smalin@marvell.com>

Applied, thanks!
