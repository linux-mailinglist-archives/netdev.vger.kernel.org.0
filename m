Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E2E322444
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 03:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhBWCqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 21:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhBWCqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 21:46:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE4446023B;
        Tue, 23 Feb 2021 02:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614048319;
        bh=PufLx0l8jwwD+QrNL96jJCdWhbaoxfgLzn8QuxgROHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pls659a3oV40H01Yg6G4tnOIA7CGvceZjX+zYHKTz25Zd2OP2JVSd+rYTyAFwWtPY
         chOflQP07cSB0rdNCYLQ982DWBErx5xoPoILnSbwNsCs9QLt3AXLJclh4LG+Cypp0e
         CrNPOI0kzMseQfn98bKVgGJOk90JOgRVqJYzyCBD+ahYQTwR18pwCp8XNoNlRhH/3b
         sv7FRZLPaHL5IJf/5U6Ryimg+UpapTuOCI/g3TkzSsGxlXvp2rI/oWc1m/9pNK+EKA
         PIRv2ZUmhT+r3vHWgeQIK9pOpe8UsRCFTGseM6AQY2p7K/F6p0tbCeQj/EuBGoKXIZ
         2wcjQg+T24eXQ==
Date:   Mon, 22 Feb 2021 18:45:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "rocco.yue" <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>
Subject: Re: [PATCH net-next 2/2] net: ipv6: don't generate link local
 address on PUREIP device
Message-ID: <20210222184515.61c268ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1614045791.6614.3.camel@mbjsdccf07>
References: <20210128055809.31199-1-rocco.yue@mediatek.com>
        <20210129190737.78834c9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1612418761.1817.19.camel@mbjsdccf07>
        <1614045791.6614.3.camel@mbjsdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 10:03:11 +0800 rocco.yue wrote:
> On Thu, 2021-02-04 at 14:06 +0800, rocco.yue wrote:
> > On Fri, 2021-01-29 at 19:07 -0800, Jakub Kicinski wrote:  
> > > On Thu, 28 Jan 2021 13:58:09 +0800 Rocco Yue wrote:  
>  [...]  
> > > 
> > > There is no ccmni driver in the tree - is this for non-upstream
> > > driver?  
> > 
> > ccmni is the name of MediaTek mobile interface, currently, it is
> > non-upstream driver and we plan to upstream these driver codes this
> > year.
> > 
> > Honestly, the reason why upstreamed this patch is not only that it can
> > be used by ccmni, but also I observed that the current Linux kernel does
> > not generate ipv6 link-local address only when addr_gen_mode ==
> > IN6_ADDR_GEN_MODE_NONE. We hope kernel can add a device type so that no
> > ipv6 link-local address can be generated in any addr_gen_mode.  
> 
> gentle ping for this patch set.

We don't merge patches without upstream users.
