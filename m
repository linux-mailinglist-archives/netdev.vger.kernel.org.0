Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C972C9594
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgLADJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 22:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbgLADJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 22:09:33 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F62F2076E;
        Tue,  1 Dec 2020 03:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606792132;
        bh=NO/n6TquoRHEUq5dWavZsUHOcbSdv/lAYcN8JJ2g4yY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jkMVb5VB2FXT/7/vEgirrPFduKX4HKApM7LO89T3klxuGlUJ1KNOaX5oB3/GylkHL
         WDVz1+udwmsZgpb7XbsjhEqnEmw162hIbsNIzhc3MwQWUP//COlpM+LzVqRHKg9Ay3
         +FytNPeuB8o8NzS5aMbsKaCPh6S9Z+U43FvkjPoI=
Date:   Mon, 30 Nov 2020 19:08:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-11-30
Message-ID: <20201130190851.1e820400@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130125307.218258-1-mkl@pengutronix.de>
References: <20201130125307.218258-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 13:53:02 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> here's a pull request of 5 patches for net/master.
> 
> The first patch is by me an target the tcan4x5x bindings for the m_can driver.
> It fixes the error path in the tcan4x5x_can_probe() function.
> 
> The next two patches are by Jeroen Hofstee and makes the lost of arbitration
> error counters of sja1000 and the sun4i drivers consistent with the other
> drivers.
> 
> Zhang Qilong contributes two patch that clean up the error path in the c_can
> and kvaser_pciefd drivers.

Pulled, thanks!
