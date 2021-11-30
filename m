Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0FA46294F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhK3A4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:56:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60796 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhK3A4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 19:56:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4E50B81647
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 00:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2640FC53FAD;
        Tue, 30 Nov 2021 00:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638233582;
        bh=0FMejvjg+y6GpBtz9jcjcK28zQ8sluo/uGMYizjcs10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YnFjyreezAS7O8xQkMPOnSVrAfuJFXGzZR8VZ8IZvpKl5FW6295KX8EXhTWR1SJ49
         ciZLvr0nwv1pg7yD7nwgmDhX9kZYET+y3Vncq0r4yUoUKxM+9FcljT4SA3Flac09x4
         q900wsVmJUSmWCZbedKsAJT9RraylqvFkoZcz7+Zgkylc/BBKljrLIJ2JVFVgnH7+P
         UDNavKY/Alz8JRIv9NIqfziJhF4ZNkaXH0K/L1uBDMTXlmSBwH35oqI/XTQGhPtb0u
         0gXIL8QZ8Ythyya2/y/WM52QDUTLg+B9VJQkI8TPjLd67+N0BPTCTbpBl4Fj80MEJK
         vr08SFR/Oz4wQ==
Date:   Mon, 29 Nov 2021 16:53:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "patryk.malek@intel.com" <patryk.malek@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 02/12] iavf: Add change MTU message
Message-ID: <20211129165300.0cc4af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <91d61a00c15af2ad177cc88fa532fb911fd8484d.camel@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-3-anthony.l.nguyen@intel.com>
        <20211124154606.47936e48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <91d61a00c15af2ad177cc88fa532fb911fd8484d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 18:43:26 +0000 Nguyen, Anthony L wrote:
> On Wed, 2021-11-24 at 15:46 -0800, Jakub Kicinski wrote:
> > On Wed, 24 Nov 2021 09:16:42 -0800 Tony Nguyen wrote:  
> > > Add a netdev_info log entry in case of a change of MTU so that user
> > > is
> > > notified about this change in the same manner as in case of pf
> > > driver.  
> > 
> > Why is this an important piece of information, tho? Other major
> > vendors
> > don't print this.  
> 
> I was going to say this was to match the behaviour of our other
> drivers, however, after looking at the others, they are dev_dbgs. Would
> that change work for you?

Yes, dbg() would be better, thanks.
