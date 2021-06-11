Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94863A4433
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhFKOlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 10:41:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231503AbhFKOlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 10:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UqBd1I8CRBr1Bng94aJhCjA2akMs4VqHBktJyFx5ep0=; b=LLGjkWb15hH7ASHFDdP8GDjjBl
        86/NK7JLhl+j8uju5WZGY6HqL28seg5wlPdAAu/L8OThKH5w2HOmYR5KtSizcRVPjHSZETr4CMOPa
        qiPzJxCAgaqLUhcJl7n8KYfY3Y6SsIoyCPTNT+Yd3eWH+wK06eTSc7Zslo3sF7ISZfHM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lriJK-008rns-Ec; Fri, 11 Jun 2021 16:39:02 +0200
Date:   Fri, 11 Jun 2021 16:39:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 3/8] net: phy: delete repeated word of block
 comments
Message-ID: <YMN1hjqpAJWDhLDI@lunn.ch>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-4-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623393419-2521-4-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:36:54PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> Fix syntax errors in block comments.

I supposed double words could be considered syntax errors, but it is
pushing the definition a bit.

	Andrew
