Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA9E2AA890
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 01:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgKHA0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 19:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKHA0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 19:26:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C6BD206E3;
        Sun,  8 Nov 2020 00:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604795201;
        bh=sKBSY3VLNqBwwtFXGomAKxvsvgCcHRg323U7LSJ/ldE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K+owaIEWlpIzCkwuL9YeKGwCjIu1me1Vwr6/vu/HOrtTgm7caZFQ34hbt5ey0xqEu
         ati4yOufk0mRM0iaak9c94+9m1cy2I7RXL62QZRKujYVWElk+K1ffZuMzEq9HG18vc
         4UNeLNBxeYFowMefoB2hMIdr5YZ15aXkf+icEfiQ=
Date:   Sat, 7 Nov 2020 16:26:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        manivannan.sadhasivam@linaro.org, cjhuang@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/5] net: qrtr: Add distant node support
Message-ID: <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 18:33:25 +0100 Loic Poulain wrote:
> QRTR protocol allows a node to communicate with an other non-immediate 
> node via an intermdediate immediate node acting as a 'bridge':
> 
> node-0 <=> node-1 <=> node-2
> 
> This is currently not supported in this upstream version and this
> series aim to fix that.
> 
> This series is V2 because changes 1, 2 and 3 have already been submitted
> separately on LKML.

Looks like patch 1 is a bug fix and patches 2-5 add a new feature.
Is that correct?

If so first one needs to go to net and then onto 5.10, and the rest 
to net-next for 5.11.
