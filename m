Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972423DDE79
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhHBRZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229551AbhHBRZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 13:25:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D039B60FC2;
        Mon,  2 Aug 2021 17:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627925142;
        bh=rDHGnR1MA66SVG6wpSp6UeehmSx/GDU1fTIdKvtZj1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfAp0hQOU+zzlJoe9/HNH8REFWUhqX6qk1quQKcucyIRW+vbMqXmRmJU+JOUbRtFk
         i0Io9mm5WVVZ6DiBvSPOmlG9jsEsvUT1GMctcQZrd+b6/mfAls9mtfnILBscjspd45
         g7jFIs7ZJS+pskXNL5wzCFsGAvWtl46WTX4aUqAFQjuQZUb+ztecTSxQXOcm7M3d4g
         KqjZLmcGae5e4eaMdJaGltKPjngd7ZHIy8MMmAHxzhpynvlS0M8ILItaJjuRT1yrCJ
         U77HcUz7HD08AABqUFNMI1CcdLGF/pzs2/KmI4eGHyWMGB4QJTpozzdpbMI7ZlNeBy
         mFK0wgz71HFLg==
Received: by pali.im (Postfix)
        id ADB4EB98; Mon,  2 Aug 2021 19:25:39 +0200 (CEST)
Date:   Mon, 2 Aug 2021 19:25:39 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to find out name or id of newly created interface
Message-ID: <20210802172539.2v3qnkjmp7l2qtxl@pali>
References: <20210731203054.72mw3rbgcjuqbf4j@pali>
 <YQawRZL6aeBkuDSZ@lunn.ch>
 <20210801143840.j6bfvt3zsfb2x7q5@pali>
 <YQf/UVmFEF2ihyKY@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQf/UVmFEF2ihyKY@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 02 August 2021 16:21:05 Andrew Lunn wrote:
> > Hello! This has additional issue that I have to choose some free ifindex
> > number and it introduce another race condition that other userspace
> > process may choose same ifindex number. So create request in this case
> > fails if other userspace process is faster... So it has same race
> > condition as specifying interface name.
> 
> O.K. if you don't want to deal with retries, you are going to have to
> modify the return value. The nice thing is, its netlink. So you can
> add additional attributes, and not break backwards compatibility. User
> space should ignore all attributes it does not expect.

Guillaume already proposed to implement NLM_F_ECHO...

> But i suspect the architecture of the code is not going to make it
> easy.
> 
> 	Andrew
