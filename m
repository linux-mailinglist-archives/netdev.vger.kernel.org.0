Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342122A5C16
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgKDBm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgKDBm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:42:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0C520870;
        Wed,  4 Nov 2020 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454146;
        bh=9YUbEtVD3+u2qPGIceQ+Ilqvt6i8DYXQ+WzjfG/+1EM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gbNMLjp4QLdkYSj6NJ6B87LdcYY4xDV2COYK/sTJCwBdpwNTys1GTNkm642NudwwM
         Lvb1vbZvuzBCTzxj9Uy5XjJnPTptuCzhrvp467mPWVK3h4KJSSgOladSQI7nVDuVzO
         4ykhst7NtPBoZhgJLO0mFbMIPVqLAAck7hn5/2tg=
Date:   Tue, 3 Nov 2020 17:42:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org,
        Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 net-next 0/3] fsl/qbman: in_interrupt() cleanup.
Message-ID: <20201103174224.0216674b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201101232257.3028508-1-bigeasy@linutronix.de>
References: <20201101232257.3028508-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 00:22:54 +0100 Sebastian Andrzej Siewior wrote:
> This is the in_interrupt() clean for FSL DPAA framework and the two
> users. 
> 
> The `napi' parameter has been renamed to `sched_napi', the other parts
> are same as in the previous post [0].
> 
> [0] https://lkml.kernel.org/r/20201027225454.3492351-1-bigeasy@linutronix.de

Applied, thanks everyone!
