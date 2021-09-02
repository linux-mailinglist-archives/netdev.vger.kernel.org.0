Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DB03FE692
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243941AbhIBAWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 20:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243369AbhIBAWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 20:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D84561057;
        Thu,  2 Sep 2021 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630542065;
        bh=QeIMK5Iju8hsbcpXPKcj6rYZSS0aBR89XHTDJL6Eck8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kJzShFmfNDD1CPp+5At+aPHSB0lglqhhM7OZMfq9lDwbJcNpHRnn+C7UWShGQN3bo
         sm8Kgc2ArBQ9cTC6TXHzoOjvMR4D/Nm9l/Q/RqBM3vUvk4rH7hX9KYRfgN/KVnMiSP
         hvJN5Bnfi0Z3jpw+TVO/cqSiksEc2sUZL95OD3yd87UyvfLHm572Z+78kS7SBCBfto
         sO9AEYQH5fpeeAQudSHQGp+pXS3QsvxuBhrr2VT1biOg0Sg7hlHXh6LTfn+8Ug5ioG
         PNVrCF3ffGlNeWa6FfYARoJppQhcNO3Nw20IDO7A+k6x+QBUR6fxnJBMn7PUGI/pYS
         SyilI1ty0NSnQ==
Date:   Wed, 1 Sep 2021 17:21:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Brad Ho <Brad_Ho@phoenix.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: Re: [PATCH 1/1] net/ncsi: add get MAC address command to get Intel
 i210 MAC address
Message-ID: <20210901172104.5ccd51b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830171806.119857-2-i.mikhaylov@yadro.com>
References: <20210830171806.119857-1-i.mikhaylov@yadro.com>
        <20210830171806.119857-2-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 20:18:06 +0300 Ivan Mikhaylov wrote:
> This patch adds OEM Intel GMA command and response handler for it.
> 
> Signed-off-by: Brad Ho <Brad_Ho@phoenix.com>
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>

Applied, thanks, but there is a disconcerting lack of length checking.
How are truncated responses rejected?
