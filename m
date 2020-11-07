Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC462AA7CE
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgKGT4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgKGT4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 14:56:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2339C2087E;
        Sat,  7 Nov 2020 19:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604779014;
        bh=z7w/1zP2PGEHbjxmk1O7wLhR+daWudmfSP+OyQ7OqLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vl+W3Jc9j8vXFSoonIzci+jfBFz2TOZAsaPxSTL7+CldE598Nc291X0DUQDnaBg9g
         SJDugf6lojqTlG47dPiRRSTGcFvNavBYZsDnTEsIENusCYuHfcTyNZlMLgT3F39kOr
         R0HX+X3AMWhyYzJqREtOZSLZ6ObDEMUXyGIrrZxs=
Date:   Sat, 7 Nov 2020 11:56:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiakaixu1987@gmail.com
Cc:     vishal@chelsio.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] cxgb4: Fix the -Wmisleading-indentation warning
Message-ID: <20201107115653.7c405fdd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604467444-23043-1-git-send-email-kaixuxia@tencent.com>
References: <1604467444-23043-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 13:24:04 +0800 xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the gcc warning:
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c:2673:9: warning: this 'for' clause does not guard... [-Wmisleading-indentation]
>  2673 |         for (i = 0; i < n; ++i) \
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Applied, thanks!
