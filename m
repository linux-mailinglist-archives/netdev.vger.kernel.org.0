Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF632630D3
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgIIPpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730462AbgIIPpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 11:45:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A85218AC;
        Wed,  9 Sep 2020 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599666267;
        bh=RXe/Z7ngspVEdKMzbg3EvNg9s5K5vSQuDRW/3BoUar0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h64/6bJGimF3a3vk4LazYhb3s766t0novIMk1vH8RGoPnSNosW8/YyQfqc6uGBOJT
         OT3+X8He94B0a1Lf8VFftBZGhe15XXznGQgyUi0T/Kw45yoZoGpblKhy1VGnXFTVg9
         N0uvMNxrKE1ly7lRWeqhz5e3QSRKKNswEKh2wuH8=
Date:   Wed, 9 Sep 2020 08:44:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next] cxgb4/ch_ipsec: Registering xfrmdev_ops with
 cxgb4
Message-ID: <20200909084424.6b7cbdd7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909103620.30210-1-ayush.sawal@chelsio.com>
References: <20200909103620.30210-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 16:06:20 +0530 Ayush Sawal wrote:
> As ch_ipsec was removed without clearing xfrmdev_ops and netdev
> feature(esp-hw-offload). When a recalculation of netdev feature is
> triggered by changing tls feature(tls-hw-tx-offload) from user
> request, it causes a page fault due to absence of valid xfrmdev_ops.
> 
> Fixes: 6dad4e8ab3ec ("chcr: Add support for Inline IPSec")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Looks reasonable.

Acked-by: Jakub Kicinski <kuba@kernel.org>
