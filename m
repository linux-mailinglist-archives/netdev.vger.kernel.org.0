Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9DA2B0C56
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgKLSKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgKLSK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 13:10:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCC2B22201;
        Thu, 12 Nov 2020 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605204628;
        bh=fXnEjZUTZBrZT8O4BZLVAbJj6Sbu5xUt9drTZIFlDYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yCUhmyPZewRtkTWwmtW44puJvOb7Q0+1HmH2NSLVB48bPuEpdYHRla9LGc07BoMpC
         eppV52h2foztFeyqFnxUqD1no1/0wmz8HfUq3Wg4r7ctVTfNV8L9TiXpNSzTRHLi5r
         FcMI294TKJ116A3ldx43kGAF12dZVoROdgIaFMg8=
Date:   Thu, 12 Nov 2020 10:10:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: Fix passing zero to 'PTR_ERR'
Message-ID: <20201112101026.02065beb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112152602.GA13694@netronome.com>
References: <20201112145852.6580-1-yuehaibing@huawei.com>
        <20201112152602.GA13694@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 16:26:03 +0100 Simon Horman wrote:
> On Thu, Nov 12, 2020 at 10:58:52PM +0800, YueHaibing wrote:
> > nfp_cpp_from_nfp6000_pcie() returns ERR_PTR() and never returns
> > NULL. The NULL test should be removed, also return correct err.
> > 
> > Fixes: 63461a028f76 ("nfp: add the PF driver")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>  
> 
> Thanks, this does indeed seem to be the case.
> 
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Thanks!

I'll drop the fixes tag and apply to net-next, though.
Unnecessary NULL-check is hardly a bug.
