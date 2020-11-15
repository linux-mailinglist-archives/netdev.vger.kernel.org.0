Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868DA2B31B3
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgKOA40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOA40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:56:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A7422314;
        Sun, 15 Nov 2020 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605401785;
        bh=xFR1Tyl9mL1UJ99IS+i48t2t2ApKZ20BbHDmwwbKO+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T+HrCEabRM5Obx2H6n/x7+tAUFEq7Ld+rwJV/imbAtv36GH1olmRhsTidQa0q6MFw
         MYHhXKj6A9AYBZcfLYAKNaTILL3CycVR6o6uJnRbbcKuYbAKQcWKQHqt8hRFnkgCDP
         v2MqnylYLFgaXcDEZIkrhU+XpXjYXuTk3MZE8B1Y=
Date:   Sat, 14 Nov 2020 16:56:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 00/15] mlxsw: Preparations for nexthop objects
 support - part 1/2
Message-ID: <20201114165625.5190424f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 18:05:44 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set contains small and non-functional changes aimed at making
> it easier to support nexthop objects in mlxsw. Follow up patches can be
> found here [1].
> 
> Patches #1-#4 add a type field to the nexthop group struct instead of
> the existing protocol field. This will be used later on to add a nexthop
> object type, which can contain both IPv4 and IPv6 nexthops.
> 
> Patches #5-#7 move the IPv4 FIB info pointer (i.e., 'struct fib_info')
> from the nexthop group struct to the route. The pointer will not be
> available when the nexthop group is a nexthop object, but it needs to be
> accessible to routes regardless.
> 
> Patch #8 is the biggest change, but it is an entirely cosmetic change
> and should therefore be easy to review. The motivation and the change
> itself are explained in detail in the commit message.
> 
> Patches #9-#12 perform small changes so that two functions that are
> currently split between IPv4 and IPv6 could be consolidated in patches
> #13 and #14. The functions will be reused for nexthop objects.
> 
> Patch #15 removes an outdated comment.

Pleasant read, applied, thanks!
