Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E54730355A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388162AbhAZFjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731797AbhAZD3j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 22:29:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D904122573;
        Tue, 26 Jan 2021 03:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611631739;
        bh=2KD03L52PFvNq3I5LvIBWsdqqfqc0tzC59ml0d8uUF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uSh74rLL28xt2lw+c0CjZliejRdb73mZVbAaRNNCZth6JwdRJR5z3PX4cfaWU+1JD
         W4iL6EgcTSDJFQg/OVAfam2y3MeJbO1gDpK53W7ckOK9a7K94A0cI+joMel3mTtvQN
         rDO7MZqRSw4OCLXkJ9xzVo8L0e5c3sRZPCi0x51lJzZaKeSF/Ptr/C4lSdJySUq7MJ
         9SKtEtd2ZVsxI1Ploc7VQdtp2HNiD5TYCN7snq6jdN60iQ7DHfqlTyTe0QhY2THrS3
         Xc/KOA2+gL9M5OdHsVcxQraOfd+Drjss5ZrNYDZ7bpA522TkWE8I95VosPiBg5QreT
         XN8ssXP4wQStg==
Date:   Mon, 25 Jan 2021 19:28:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Seth David Schoen <schoen@loyalty.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>, John Gilmore <gnu@toad.com>
Subject: Re: [PATCH net-next v2] selftests: add IPv4 unicast extensions
 tests
Message-ID: <20210125192858.595f3c71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125233847.GK24989@frotz.zork.net>
References: <20210125233847.GK24989@frotz.zork.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 15:38:47 -0800 Seth David Schoen wrote:
> Add selftests for kernel behavior with regard to various classes of
> unallocated/reserved IPv4 addresses, checking whether or not these
> addresses can be assigned as unicast addresses on links and used in
> routing.
> 
> Expect the current kernel behavior at the time of this patch. That is:
> 
> * 0/8 and 240/4 may be used as unicast, with the exceptions of 0.0.0.0
>   and 255.255.255.255;
> * the lowest host in a subnet may only be used as a broadcast address;
> * 127/8 may not be used as unicast (the route_localnet option, which is
>   disabled by default, still leaves it treated slightly specially);
> * 224/4 may not be used as unicast.

Missing your Signed-off-by.
