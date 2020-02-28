Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB871740A5
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 21:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgB1UEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 15:04:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1UEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 15:04:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C1224677;
        Fri, 28 Feb 2020 20:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582920279;
        bh=dhyy/EF/RYGrLhHYMT2CeRPAd7BGBv5EWjO98YpJ4mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=njNKiJsrg3Se2Clw2t6+GjvXaOgIYfYS37oCyzMqr9XTc1/pnfKdfrWEfYQYSzJ4H
         SebKf7NmU9SI+zK57lqknMlG12UhbUtVcuk4d0hlwqs4RSHaPviiGjWCRPd225rdye
         liJeMxHMZ2gZt3mRDrptoVDrrufxbLyi85L6+/zc=
Date:   Fri, 28 Feb 2020 12:04:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        herbert@gondor.apana.org.au, secdev@chelsio.com, varun@chelsio.com
Subject: Re: [PATCH net-next v2 0/6] cxgb4/chcr: ktls tx offload support on
 T6 adapter
Message-ID: <20200228120437.547bdb97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200228183945.11594-1-rohitm@chelsio.com>
References: <20200228183945.11594-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Feb 2020 00:09:39 +0530 Rohit Maheshwari wrote:
> This series of patches add support for kernel tls offload in Tx direction,
> over Chelsio T6 NICs. SKBs marked as decrypted will be treated as tls plain
> text packets and then offloaded to encrypt using network device (chelsio T6
> adapter).

You need to try harder CCing people who can give you reviews.

Please resend CCing at least Boris and myself, we gave you reviews 
on your recent patch..
