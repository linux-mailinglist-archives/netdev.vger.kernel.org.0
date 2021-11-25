Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5E45E000
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbhKYRyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 12:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242204AbhKYRwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 12:52:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58D7F60184;
        Thu, 25 Nov 2021 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637862534;
        bh=0/dLZVSx9dFRkmYPtS9XsOFW+tzowm2F1v5jHZbuuQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qdLyIe1hPPBN0kJ6Wb7NS6DkvrgiwzfcbWFCCXOtXiQ+NfUZg81x6w5+idfANZfc9
         DUiSCZWuslYmax7waRGMo28KvOjEmAzNiQFmvLerygbfqp4DRy2fh5KS3w7V6hoj2v
         7dcDQ7uZu+JIKb8yRdoXJPZtUcYLhAVhMoSYBILJNCklesNlXYA/Ac+HeEVnVXzEyw
         FIf06C0RzMM+9sDBnZwuTZJuAhi97APmpCnDJwD69bvh0UhD8f4QeUqGWiFTUJEyD3
         1YqBnDJ0CmxBdJtqlGTnot1H9vnyA2iKw4Ri5GXTjk13+MYY4lrhHEywaAco2sJeN0
         mQqoSuBF5jc2g==
Date:   Thu, 25 Nov 2021 09:48:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ixp46x: Fix error handling in ptp_ixp_probe()
Message-ID: <20211125094853.0e3f2785@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125075432.26636-1-tangbin@cmss.chinamobile.com>
References: <20211125075432.26636-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 15:54:32 +0800 Tang Bin wrote:
> In the function ptp_ixp_probe(), when get irq failed
> after executing platform_get_irq(), the negative value
> returned will not be detected here. So fix error handling
> in this place.
> 
> Fixes: 9055a2f591629 ("ixp4xx_eth: make ptp support a platform driver")
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Please resend this and CC the right people.

./scripts/get_maintainer.pl
