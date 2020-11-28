Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD952C6DD9
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 01:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgK1ACb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 19:02:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731565AbgK1AB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 19:01:58 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06A4A2223F;
        Sat, 28 Nov 2020 00:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606521678;
        bh=LECueOqRQ+DDTtDsX3sm3StVu4cyL88reB7AmOrwxCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zBRzW+qNqUsiEdE1j90KpYDOa1cDNWC+do23itXwZZNpZXSy2hyfRur9dmU4UmVy0
         e+5qzHCfgx/euc2KZ7sYbW9o/RGFHP56CRuQ4Bd6cBZoYqUHS+i70XbxSbx6zV9DEJ
         Liqwq5tkqrvUNfBOby3eiASJcqr4aNxcvrv0lcAk=
Date:   Fri, 27 Nov 2020 16:01:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     bongsu.jeon2@gmail.com
Cc:     krzk@kernel.org, k.opasiak@samsung.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 3/3] nfc: s3fwrn5: extract the common phy
 blocks
Message-ID: <20201127160116.5c8e6853@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606476138-31992-1-git-send-email-bongsu.jeon2@gmail.com>
References: <1606476138-31992-1-git-send-email-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 20:22:18 +0900 bongsu.jeon2@gmail.com wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Extract the common phy blocks to reuse it.
> The UART module will use the common blocks.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
> Changes in v2:
>  - remove the common function's definition in common header file.
>  - make the common phy_common.c file to define the common function.
>  - wrap the lines.
>  - change the Header guard.
>  - remove the unused common function.

You need to repost the entire series.

Please wait around 8 hours and rebase on top of net-next. At that point
Krzysztof's fix which you were including as patch 1 should already be
in net-next, so you should be able to post just the latter two patches.
