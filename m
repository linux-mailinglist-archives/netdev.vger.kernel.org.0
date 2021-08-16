Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3922D3EDFB5
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhHPWIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhHPWIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 18:08:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5423760F39;
        Mon, 16 Aug 2021 22:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629151681;
        bh=fKmJlcAWujG+hfnYc9mlf+5ADTZsqV+3dA5cMnbdAyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=usMkRssRE1BLvwxdKO3qlrlO0vTt/lUuUYp4uSkPDTpJN31gawK/UdOkbexpohu4D
         Sig37TCJvgKHz2gevU+aL5whoByub6LOPCiUlyNsXKHVyLIo1CC9nOMK7I01qbJdwq
         S7la6I0Az/kTFyeF3Q2Mwmx0kQ8v6mHk2BckBqsVI7fOgh5jxXhyffvanmCnk0kStO
         N894ZOURcig1ISJ2djsOTQcylpP4WUHjbXSZc4g98d9GIlkmRMR47HJ0V0aC6YzeHZ
         vCqMVFP1ri00BCI+KSDBDKNh4sDzV0KJU9CDvh5sYqVl4GXggqj+SehEAUipBKY1nO
         xCzUa1JdVAk7A==
Date:   Mon, 16 Aug 2021 15:08:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bechtel <post@jbechtel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: ss command not showing raw sockets? (regression)
Message-ID: <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210815231738.7b42bad4@mmluhan>
References: <20210815231738.7b42bad4@mmluhan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Aug 2021 23:17:38 +0200 Jonas Bechtel wrote:
> I've got following installation:
> * ping 32 bit version
> * Linux 4.4.0 x86_64 (yes, somewhat ancient)
> * iproute2  4.9.0 or 4.20.0 or 5.10.0
> 
> With one ping command active, there are two raw sockets on my system:
> one for IPv4 and one for IPv6 (just one of those is used).
> 
> My problem is that
> 
> ss -awp
> 
> shows 
> * two raw sockets (4.9.0)
> * any raw socket = bug (4.20.0)
> * any raw socket = bug (5.10.0)

Could you clarify how the bug manifests itself? Does ss crash?

> So is this a bug or is this wont-fix (then, if it is related to
> kernel version, package maintainers may be interested)?
