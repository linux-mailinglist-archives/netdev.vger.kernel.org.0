Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D503884D8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 04:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbhESCkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 22:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236806AbhESCkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 22:40:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 238436112F;
        Wed, 19 May 2021 02:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621391939;
        bh=XucpGTi9ahRzp0sdEFDRlL3/Nsl8ezxxQ1FQY3dSJuI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V9JCccr24Bdkx5YPQ/KI4KLB7acqwHfmYRi6yiwTCOUdpSdkrroyLGvKxB6t0oK2f
         XSFt1rct6eBGKlXpDjkwUW3+1wa3W1nP95g7ffZo/35bOi4rBcFr/bsSMbw6TKfiPk
         XkYc4rKDKlTr80zO1PbrxU+2t9ZtTMTNlOBjHMhvyzcxjacOhXMGOZjUV3uE13Adr8
         eGQRM6+cWP3csggPeCkrfzHffsKJLTj5qI5AVfqy18mwuPw2+nCMuiZ28V/26BlqdO
         XNEmYJ6G/QYL7Qw5soga9zr2sIw/iUcGQLvOdVajHTFngQjo2p/vjWhK6uucGtyGDb
         VWJnLS4sMWuiw==
Date:   Tue, 18 May 2021 19:38:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ethtool: stats: Fix a copy-paste error
Message-ID: <20210518193858.7296623e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210519021038.25928-1-yuehaibing@huawei.com>
References: <20210519021038.25928-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 10:10:38 +0800 YueHaibing wrote:
> data->ctrl_stats should be memset with correct size.
> 
> Fixes: bfad2b979ddc ("ethtool: add interface to read standard MAC Ctrl stats")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Ah, FWIW this should had been targeting net.
