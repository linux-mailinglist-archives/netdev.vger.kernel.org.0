Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2CACF926
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfJHMEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730797AbfJHMEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:04:35 -0400
Received: from localhost (92-111-67-33.static.v4.ziggozakelijk.nl [92.111.67.33])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815FF206C2;
        Tue,  8 Oct 2019 12:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570536275;
        bh=4hDOqK2Pg50FghYIyQchR1OA0SV7QFsd2RKg14AFHJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lzUf0NKUOkkfLaQ6ZPKaTSthmuOapdVK/QgNMFyDj28DzbK3u/8Rjc+6qr3pC2b8R
         FysvWGQH4z60eBys04RSqmLC8IjaZDG750DLBRw7yYpTFGhIMYVO3mjukZ1rlspTcz
         6snDYw7SOe8IS++ZpnUq7G5jJT3eOYmfQ5EPdUSA=
Date:   Tue, 8 Oct 2019 14:04:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: Re: [PATCH 4.4 stable 04/10] netfilter: ipv6: nf_defrag: Pass on
 packets to stack per RFC2460
Message-ID: <20191008120432.GB2761030@kroah.com>
References: <20191008112309.9571-1-geokohma@cisco.com>
 <20191008112309.9571-5-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008112309.9571-5-geokohma@cisco.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 01:23:03PM +0200, Georg Kohmann wrote:
> commit d65bc9545fd3 ("netfilter: ipv6: nf_defrag: Pass on packets to stack
> per RFC2460")
> Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Date:   Fri Jan 12 17:36:27 2018 -0700
> 
> [ Upstream commit 83f1999caeb14e15df205e80d210699951733287 ]

THis looks to be patch 4/10, where are the other 9 patches in the
series?

confused,

greg k-h
