Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1283EBB7F
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhHMR3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhHMR3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67A2760F36;
        Fri, 13 Aug 2021 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628875754;
        bh=LbsRTCOs3XQJpYExVTATW3htfDPyz+crpy/a/eUJebI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aeLpCdQNwSq3mM5Jf0p0MWs33faZUlC9nstkImEcZ+Q0e2uZsHTT/bu+ZULAbqrNU
         PKI0i8ZtUTo8wJx/0a7mFmpbBZa/EKZU+K1f7x7bGjgCqbb3H+Ffh3VRNHxGCXrWEX
         PEX+fdMzCThsZX4NqcV4Y92VU3h3o8yvMDT5aCpxS3FJDzb6c/M7MXKWelsJBIfAqB
         9XGtATJDk/N9wAje4tHmM01Ik8kRlYE87Lz5RGRHVPN5wOvnS9YD3sxlbZzFa3kLGX
         K5HQeHYVAA1Q0/KDSEpylyEd0NAnnW8uy54m8e3xw0VFbluPfvnch/NZgT0FPHu4JL
         zUONGlczdplJA==
Date:   Fri, 13 Aug 2021 10:29:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: gc useless variable in
 nlmsg_attrdata()
Message-ID: <20210813102913.7a6ecea5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRYCwjh+5CpccgI8@localhost.localdomain>
References: <YRWRcbWR45+zF9mD@localhost.localdomain>
        <20210812150552.18f32fb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRYCwjh+5CpccgI8@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 08:27:30 +0300 Alexey Dobriyan wrote:
> On Thu, Aug 12, 2021 at 03:05:52PM -0700, Jakub Kicinski wrote:
> > On Fri, 13 Aug 2021 00:24:01 +0300 Alexey Dobriyan wrote:  
> > > Kernel permits pointer arithmetic on "void*" so might as well use it
> > > without casts back and forth.  
> > 
> > But why change existing code? It's perfectly fine, right?  
> 
> It is harder to read (marginally of course).

TBH I prefer the current code, I don't have to wonder what type
nlmsg_data() returns and whether it's okay to do void* arithmetic 
in this header (if it's uAPI). Sorry :(
