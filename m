Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8502FD631
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390730AbhATQzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:55:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403995AbhATQyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 11:54:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AEA123358;
        Wed, 20 Jan 2021 16:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611161649;
        bh=VY6+TEL4SUjdxeBSivIiZY4VKyVq53k8YU99OvFbxSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CTuJPsVwqUaIKeUiWxO10Ql9U9pDqCaxkmIbpz2VunXuUxRC52oMQf9SJG2EiBr37
         Exivg3omBo3qf+akFEdnXT1XdIakAgT5LPHMDeAZ3mqWZLDYQcDoFfpy8zFIw2y4Ck
         9ZqFuOHVknUq1LOrxaUL1Ve/drM9DNFo2a/yBB3OvyNDaMQWiwI47jvKmlea9GqjMN
         rVcYT93jtT1ZT/PlVtCHxWsq5cYwEypN4XCc48jpUgF16EsFOIBP41I/pm7C0yXkew
         8hliEEDm7tX35veOmGrOAvmtg4Xf8PmCwodFGFDsq4lyZ2k4JsSwm4tYCywiKNbKVY
         0umEtFs5r1p9Q==
Date:   Wed, 20 Jan 2021 08:54:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2021-01-20
Message-ID: <20210120085408.5e074a54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120163439.8160-1-daniel@iogearbox.net>
References: <20210120163439.8160-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 17:34:39 +0100 Daniel Borkmann wrote:
> 1) Fix wrong bpf_map_peek_elem_proto helper callback, from Mircea Cirjaliu.
> 
> 2) Fix signed_{sub,add32}_overflows type truncation, from Daniel Borkmann.
> 
> 3) Fix AF_XDP to also clear pools for inactive queues, from Maxim Mikityanskiy.

Pulled, thanks!
