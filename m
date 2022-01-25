Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AEB49BF4A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiAYXCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:02:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58328 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiAYXCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:02:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3DC4CE19A7;
        Tue, 25 Jan 2022 23:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18E5C340E0;
        Tue, 25 Jan 2022 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643151754;
        bh=gp6pWEqFqGSE/3T0cqmvdasPflH4sWC6zy+xc4W3hSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sd3iA8+K/pmrFF3ikMd973xnXeioQrp3wtkL2HjlHAbfa7hhyeEaPcov1ScYlb4GZ
         Mpnbo04tFOG4HeB8vsChnECzL+GQmXcM0zhJGN+CN6mLnOogdOd/uOgBn3HkjM8+iP
         VY3iQ3tbEIrklxJpQEnsV2LN+ghrt9MkQ9HD74eiIFM/HY9h+/lkGaVrXeO2Azc69P
         7MwbXzVXZdcyIr7u1V2RqP4VaiC8HPL0AeCNYvGGuZOuGfKkbJGYCLVSRBU2jxgbAc
         IchS2AdNjtDA/o9INH/whB6mnoaYrNv2gecTM81eCbnABfqoLmnumCmVEcGaL8XiU7
         siuzeaqWx7yEg==
Date:   Tue, 25 Jan 2022 15:02:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v3 net-next] net-core: add InMacErrors counter
Message-ID: <20220125150233.27073ad5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125221214.2480419-1-jeffreyji@google.com>
References: <20220125221214.2480419-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 22:12:14 +0000 Jeffrey Ji wrote:
> Change-Id: If820cc676807ba8438a9034873df3ef2e0b07213

Please drop the Change-Id.
