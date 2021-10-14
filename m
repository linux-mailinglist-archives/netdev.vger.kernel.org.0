Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCB242DF58
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhJNQpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233026AbhJNQpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 12:45:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E2460551;
        Thu, 14 Oct 2021 16:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634229789;
        bh=IPSZxqTHaraDT9+1EnYKmsNnEd3fQn/0+OSbR5g/kA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t6DUNkmD8zzkCqb7kix9urpXyWMvC7ADf0wq9EGxGqNWxPIghPmnROWZ/Ueqdk7Oj
         CSQ4oOXnNgLdTjxNYIJKCukyOzZMVwV++Ctmj+4YdoWu8cWwBgq3Vg16kcH11g1Afj
         Ie2Jy3KwNl4un/C80BNfG3rGxC6W2Bqn3zkq8rlX/YQs30b3f7b+1nxJvS/erP66rh
         hmeQxtmyZNF/A1CtcDTMsZp5bSmZ98M3wEiE5QeaCKCoiTr3TL9soCUUsAeqxGrEPE
         GSJjqUJxKA22VIXjWyTFoKCwIk0QiFIohFvao84gL05sD7S4VSyMs1Muao3ckShw5r
         LiTK0UoTBHJBg==
Date:   Thu, 14 Oct 2021 09:43:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
Message-ID: <20211014094307.0a40078f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <539c6c0e373eed1cd70e4bf2f3bad75040acee6d.camel@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
        <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211013164044.33178f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <539c6c0e373eed1cd70e4bf2f3bad75040acee6d.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 09:32:31 -0700 James Prestwood wrote:
> On Wed, 2021-10-13 at 16:40 -0700, Jakub Kicinski wrote:
> > On Wed, 13 Oct 2021 16:37:14 -0700 Jakub Kicinski wrote:  
> > > Please make sure you run ./scripts/get_maintainers.pl on the patch
> > > and add appropriate folks to CC.  
> > 
> > Ah, and beyond that please make sure to CC wireless folks.
> > The linux-wireless mailing list, Johannes, Jouni, etc.
> > The question of the "real root cause" is slightly under-explained.
> > Sounds like something restores carrier before the device is actually
> > up.  
> 
> Sure. As for the real root cause, are you talking about the AP side? As
> far as the station is concerened the initial packets are making it out
> after a roam. So possibly the AP is restoring carrier before it should,
> and packets are getting dropped.

Yeah, that's what I meant. If you're saying that station sends the
packet out correctly then indeed nothing we can do but the workaround.

> In v2 I'll include a cover letter with more details about the test
> setup, and what was observed.

Thanks!
