Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7EC312021
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBFVA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 16:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFVA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 16:00:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F4EE64E57;
        Sat,  6 Feb 2021 21:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612645217;
        bh=80CDBgeDWUtvbWtIen/0r+tgzUT0TauEI+1hVZnNfng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tKibYGPO+eAa1ZyjFEBAbLYow1Thu4gDcGKOSXnK05sbY7D94yvAgsWGUm+AdOZAw
         KvcCukd5WCkYPSA6bG6pNNKm8bpEiGrFxDpPX5TQdee1W6VW2UMjwSaGFIk+JhxcMR
         94ioDQL6ywseGkzI5kGVpg/FqmmxRwH1ruDLuwBur5oDsHYtkMpfBKmWctjQ5k7RWO
         R1cvlI45e3kZFSXiMfnWqnh6BSkFCkIn2zj23XedJcLCfxW4OCNBK+1nTMSBvImUDg
         AqhQRy0UzfYyIY4XHbbl3fpFZTcdFbUbjaB/ccoseSoue4d+EvN1n1uS00+EYcKJQZ
         JYePTuSZvFvUQ==
Date:   Sat, 6 Feb 2021 13:00:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: core: Clean code style issues in `neighbour.c`
Message-ID: <20210206130016.7debcc34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205062821.3893-1-zhengyongjun3@huawei.com>
References: <20210205062821.3893-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 14:28:21 +0800 Zheng Yongjun wrote:
> Do code format alignment to clean code style issues.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

I don't think these changes make the code substantively more readable.
At the same time they make the history harder to follow and may cause
backporting failures.

Unless area maintainers disagree I'm not applying this patch, sorry.
