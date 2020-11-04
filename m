Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F742A6CFD
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 19:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgKDSkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 13:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728841AbgKDSkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 13:40:13 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93C02067C;
        Wed,  4 Nov 2020 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604515213;
        bh=xsPnP8YIEBjSo8aJnOWYwePxTvRnTs1zE6OuxS3fIps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QFeEiwen9PiWHiRG3Fo+cxfR0VU+Z8Igv6Hz/BN5ZO7dTAVdFmOW6VAebpoY1oUUZ
         tH+ao1BVDlsJi+eVpOP+WTvNIiFCEdexETZMH+4PuLoUMOn2HQxJaTI/zjIyUNR75R
         I6qC4lE9FjzSzTy+CWzgV/byx/IVdYs0Pwm4D/Vk=
Date:   Wed, 4 Nov 2020 10:40:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: pull request (net): ipsec 2020-11-04
Message-ID: <20201104104011.5ffb3235@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104090010.17558-1-steffen.klassert@secunet.com>
References: <20201104090010.17558-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 10:00:08 +0100 Steffen Klassert wrote:
> 1) Fix packet receiving of standard IP tunnels when the xfrm_interface
>    module is installed. From Xin Long.
> 
> 2) Fix a race condition between spi allocating and hash list
>    resizing. From zhuoliang zhang.

Pulled, thank you!
