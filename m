Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F742AF5A4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgKKQAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgKKQAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:00:30 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEF8820709;
        Wed, 11 Nov 2020 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605110429;
        bh=Dv9BJlsfpFVl0Xexy5UTw33fgnjDZpEORoMIQwG5VrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WQWostecFHGQH3YBVlqic8fIdISsfyNjbN6bue3q4tBnspH7fWstqk+t7gLRcU+Y2
         YuRZ4uHLKndAM5qSykd+DXjRwXRLR6KrDKLkDDA8j55EANVJzCk7Oc6Ydvf43jjWNA
         1f8ZBm8YAhtMusSpZsc9clZE1ZwjoUpfVlKjNeJw=
Date:   Wed, 11 Nov 2020 08:00:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Wang Qing <wangqing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock
 is ERROR
Message-ID: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111135558.GB4928@hoboy.vegasvil.org>
References: <1605086686-5140-1-git-send-email-wangqing@vivo.com>
        <20201111123224.GB29159@hoboy.vegasvil.org>
        <cd2aa8a1-183c-fb15-0a74-07852afb0cb8@ti.com>
        <20201111135558.GB4928@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 05:55:58 -0800 Richard Cochran wrote:
> On Wed, Nov 11, 2020 at 03:24:33PM +0200, Grygorii Strashko wrote:
> > 
> > Following Richard's comments v1 of the patch has to be applied [1].
> > I've also added my Reviewed-by there.
> > 
> > [1] https://lore.kernel.org/patchwork/patch/1334067/  
> 
> +1
> 
> Jakub, can you please take the original v1 of this patch?

I don't think v1 builds cleanly folks (not 100% sure, cpts is not
compiled on x86):

		ret = cpts->ptp_clock ? cpts->ptp_clock : (-ENODEV);

ptp_clock is a pointer, ret is an integer, right?

Grygorii, would you mind sending a correct patch in so Wang Qing can
see how it's done? I've been asking for a fixes tag multiple times
already :(
