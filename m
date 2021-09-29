Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC71B41CB4F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345359AbhI2Rxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345459AbhI2Rxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:53:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98686613CD;
        Wed, 29 Sep 2021 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632937928;
        bh=8gCg1U8pjrvZqhYf81Sai3dKdeTUFzFIXzl4TnPAcPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hr/hapyvG6mkyp6eWJIKMbasfY826pYd4TwPTazoFxIDMO6c9XKnv5Rxj5xVubNGL
         z8ckPeqZs9QArbccG58hCYnj7WBFwcDKMEGl+pDwkxMODKbuPWqG8srlAICEkCmKr8
         r1VN9PO8eMWLG60Si8PgY9ugm33qv9hBnker/ezkBWXvC9az0jik80f1qNqTx/l4ym
         A1ccdosSwYWTnlsVam0wgZGNLhi622efYSyLqAunn4kUyjkw35WAsG5o4GPPvyCG3P
         FHBmlh9239G1wl38qVraoEf20XXfb3sjzxXnUKHEH/5oJZ6kzZGPQRI3rV57C2ihan
         0By5Xi6eFzB0w==
Date:   Wed, 29 Sep 2021 10:52:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next] devlink: Add missed notifications iterators
Message-ID: <20210929105207.06352a37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2ed1159291f2a589b013914f2b60d8172fc525c1.1632925030.git.leonro@nvidia.com>
References: <2ed1159291f2a589b013914f2b60d8172fc525c1.1632925030.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 17:18:20 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The commit mentioned in Fixes line missed a couple of notifications that
> were registered before devlink_register() and should be delayed too.
> 
> As such, the too early placed WARN_ON() check spotted it.

> Fixes: 474053c980a0 ("devlink: Notify users when objects are accessible")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Corrected the fixes tag and applied.
