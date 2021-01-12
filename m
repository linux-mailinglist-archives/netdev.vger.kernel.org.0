Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355052F2612
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732590AbhALCH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:07:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbhALCH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 21:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6CE22E02;
        Tue, 12 Jan 2021 02:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610417238;
        bh=J4DfSHGmpNbOyayOV1RcYzVsVESx5yQNIJuVsFTbkp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tGkRVzmGhGsBO+xVPhNr9tQy04q3WIon1e3YSJB3Fxkqbg2oS+c/5VElFQ7iagEnK
         6g0S8QQ3mIL1lq9PNHseryWC9tYww42U+SZSGfsL3VI0Z4Mkw4zE8Q1hgFp/O3X28d
         I4kY6Zwj63E8UfK7webPfOr4jmKCfZCiQmNlf1rblPSnHai6K8mGuuUswFjSc7twuz
         SS0lVtxNnp8L9wQtQFtq1DpJYGCk85sGJNRhMiCBQpmTtl+wKnXSRq6FUetIRfuUx+
         Jm3PFIHlzM4sPPeu7XH4VOM+qMBPdCjprJTCxqlD3kri4S0iJJSeVHEIr8s80dX3IZ
         PyQ+UTJFQJ0KQ==
Date:   Mon, 11 Jan 2021 18:07:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Long Li <longli@linuxonhyperv.com>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: Re: [PATCH v2 0/3] hv_netvsc: Prevent packet loss during VF
 add/remove
Message-ID: <20210111180717.19126810@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
References: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 16:53:40 -0800 Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> This patch set fixes issues with packet loss on VF add/remove.

These patches are for net-next? They just optimize the amount of packet
loss on switch, not fix bugs, right?
