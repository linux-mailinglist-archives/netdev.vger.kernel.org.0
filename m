Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C252F7184
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 05:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732873AbhAOEOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 23:14:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbhAOEOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 23:14:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ACEF23AC9;
        Fri, 15 Jan 2021 04:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610684050;
        bh=2pbAemQNRup2me0OaNGafy1g5R/x8+eGuOc+MB36rVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T7byPPZfiIKDKCFJEexDVf055Pp47eELH51bVEQ2e0/npgyzbODUVCbiC6nN5KKp1
         a2dCmcII0G24vxWk7d1khxfHImGQJuQ35x0tQuHru0uDrARuSkjbHFr/kEV5CzPQO0
         Qg5N+5A7F6dzJKju2qxvACLffu9w5VVlRXcVHXsKm9s7uHJzdY31VqtV+G7csUp/G6
         meHjl4MS6vN9Oi8tmAZPiJBr+Ximfn44tCy1XHnqXtD8T1pzjZBk9fDW66QJ5qjDOD
         0pNKzUgzyo2wlLPdYLPg4hE+cSu8rhKDBJEv2QL8fuZFcnA/KhYyZEEcHLtl+9cdst
         lAuyv/2u1Ot1g==
Date:   Thu, 14 Jan 2021 20:14:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     nikolay@nvidia.com, roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH v2 net-next] net: bridge: check vlan with
 eth_type_vlan() method
Message-ID: <20210114201409.41778f77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115022344.4407-1-dong.menglong@zte.com.cn>
References: <20210115022344.4407-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 18:23:44 -0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Replace some checks for ETH_P_8021Q and ETH_P_8021AD with
> eth_type_vlan().
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

This adds a new warning when built with W=1 C=1:

net/bridge/br_vlan.c:920:28: warning: incorrect type in argument 1 (different base types)
net/bridge/br_vlan.c:920:28:    expected restricted __be16 [usertype] ethertype
net/bridge/br_vlan.c:920:28:    got unsigned long val
