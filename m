Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13B72A3281
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgKBSEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgKBSEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:04:44 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C803A21D91;
        Mon,  2 Nov 2020 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604340284;
        bh=LSqTOlPjQ51qesbj9AETzLIbebgg/6dTER12sVS7/ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jmJL+Dvu28VkI+WWqrYAilxnLHi4Izg0XuuZtG5xd1anMX0a/Rr6z8g+Z2x54nkgU
         RNr4LZ6hGgMSzpiKpZaZdd+cFeujGDkiS9tra03pky68z+v9cM/AzUCHThuVy2A1NT
         Tep5PFCD9vZnd6MslHTO4TNOlXh8ZgBgztP+J5lg=
Date:   Mon, 2 Nov 2020 10:04:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-10-30
Message-ID: <20201102100442.3f59981f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <79a1775af358e04083c452729e74dbc8ba20fe63.camel@sipsolutions.net>
References: <20201030094349.20847-1-johannes@sipsolutions.net>
        <20201030135237.129a2cfe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <79a1775af358e04083c452729e74dbc8ba20fe63.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020 13:49:37 +0100 Johannes Berg wrote:
> On Fri, 2020-10-30 at 13:52 -0700, Jakub Kicinski wrote:
> > On Fri, 30 Oct 2020 10:43:48 +0100 Johannes Berg wrote:  
> > > Hi Jakub,
> > > 
> > > Here's a first set of fixes, in particular the nl80211 eapol one
> > > has people waiting for it.
> > > 
> > > Please pull and let me know if there's any problem.  
> > 
> > Two patches seem to have your signature twice, do you want to respin?
> > It's not a big deal.  
> 
> That often happens when I pick up my own patches from the list ... let's
> leave it.

Fine, pulled.
