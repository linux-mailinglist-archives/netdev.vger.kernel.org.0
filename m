Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156C1281D08
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgJBUmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBUmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 16:42:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030162064B;
        Fri,  2 Oct 2020 20:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601671329;
        bh=tsPfQs6GKnOQ0YKX2eF8iCzLkV49vFOIQKoUZkoPfzs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n0HJF5gfLez8ayF5+NeV07Qp9FwBU/MFtSjlbYtALDw5u9PQXG923vlZA4+qFNpwr
         L+09B5BcgVQUBhNsPQ92SVG/iAXptucBYqv2rgJ9fAGG+tvz5FVK6FXs5wmTox9PMt
         i2zpW9u4/u8N0e+Q8pjZbyNBxX9YLfGG2bwmGEJo=
Date:   Fri, 2 Oct 2020 13:42:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] netlink: rework policy dump to support multiple
 policies
Message-ID: <20201002134207.5a1f684d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <185e714a1d205c3cdf0f655630f8c3edf552fc1a.camel@sipsolutions.net>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
        <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
        <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <580e017d3acc8dda58507f8c4d5bbe639a8cecb7.camel@sipsolutions.net>
        <20201002133720.7fb5818c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <185e714a1d205c3cdf0f655630f8c3edf552fc1a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 22:38:49 +0200 Johannes Berg wrote:
> On Fri, 2020-10-02 at 13:37 -0700, Jakub Kicinski wrote:
> > I guess it's because of the volume of messages this would cause.  
> 
> There's actually been a large cleanup, so it wouldn't be too bad.
> 
> I had really just suspected tooling/build system issues, you know which
> C files you're compiling, but not easily which headers they're
> including, so how to run the checker script on them?
> 
> Anyway, never really looked into it.

Good point, in any case it should be simple enough to add a separate
test for headers to a CI, now that I know it's the case :)
