Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08195396CC9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhFAF3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAF3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:29:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C3061042;
        Tue,  1 Jun 2021 05:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622525241;
        bh=vfdyDVfejBDK08APTvZn88/BgNA1G6tTsDDAjl5hXzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sFdZmG3k+bI0DbZO5SSe1KApJkX/YuX0YBfuZhigJ7CBbE5uGTO+/fbsesTtjvhrD
         PWLaA81KhTD3mjMxqEwjg+bh0VeqtjnKG4TiCxcEgTOCVprEPHUZyQ5IU7ef7J6UF6
         MRDFnR5XVN5EJa59nfpUIgt09mODIseX0DuiRa5ann5r2Q2hSThLQ2Wv3jhEI1AEoI
         ApVB9ETaqD6cu1A9OOlsKVuOYsM8N+rgVuaqQhWokMnkzDQjDUMlD27YJL8AEWFzep
         mIEysAQm0SE6SB0Sqg2w/9Vk18QO9hAY19yBlSfkuuuTTzfi/oiMFQrfxcyEo+s+CI
         0rfjd3eQYwmMA==
Date:   Mon, 31 May 2021 22:27:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <davem@davemloft.net>, <linux-nfs@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bfields@fieldses.org>, <chuck.lever@oracle.com>
Subject: Re: [PATCH net-next] xprtrdma: Fix spelling mistakes
Message-ID: <20210531222719.3e742ed6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210531063640.3018843-1-zhengyongjun3@huawei.com>
References: <20210531063640.3018843-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 14:36:40 +0800 Zheng Yongjun wrote:
> Fix some spelling mistakes in comments:
> succes  ==> success
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

This should not have been tagged for net-next, leaving it to Trond.
