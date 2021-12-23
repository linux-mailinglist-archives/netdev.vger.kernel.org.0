Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB4747E686
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 17:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349310AbhLWQrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 11:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbhLWQrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 11:47:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3388C061401;
        Thu, 23 Dec 2021 08:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6330461E67;
        Thu, 23 Dec 2021 16:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5215AC36AE5;
        Thu, 23 Dec 2021 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640278023;
        bh=Erp7JrQTEj22ZBoCVLb6jekKYLXMsaNkCl9Ck641gGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T+3js6b5lliyZxy4IkdhgSR3j95koElW6JZ3sZBGAg2yxf+MzmB+h6EgGEGMnGOFh
         t3soLXcNwP9KENxEdJFr7761jHPKhtBczFTWGf6DCtrwEXrhDCvJVhz+G8OuwDN1/L
         SV9NCxXGh2wqyCEiO0DMGFqaCAIfxgCADYctW30U7pwmRFle5nAsZU7eQt6ujB9mJc
         YHwYBnR1r0nQQCX1uSFZR3UYXHuMTezgRBtrN0Rv3X8s7ktqOA75RxpW8QxvjF0TB5
         uB9LFqB+oa22JQwzP2qwBYQQW4ud/hRTafBLgocnC98J8wrBGrHbs4GEY+AmTZBHfo
         XS86fg4uDbYGA==
Date:   Thu, 23 Dec 2021 08:47:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        prestwoj@gmail.com, xu.xin16@zte.com.cn, zxu@linkedin.com,
        praveen5582@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH net-next] ipv4: delete sysctls about routing cache
Message-ID: <20211223084702.51d09c08@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223122010.569553-1-xu.xin16@zte.com.cn>
References: <20211223122010.569553-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 12:20:10 +0000 cgel.zte@gmail.com wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Since routing cache in ipv4 has been deleted in 2012, the sysctls about
> it are useless.

Search for those on GitHub. Useless or not, there is software which
expects those files to exist and which may break if they disappear.
That's why they were left in place.
