Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE33AA07F
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhFPP6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:58:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234841AbhFPP5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 11:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=39tZF8EbPw8MTYGW2AYaljaKzy40uNoolwSSC0+zSbk=; b=kjEcOeNdTQNLiWLFzkytDnF9Dz
        7876p+Wxdt132rWZW3Y+sdDfvy7pUZrMOS92FqO4l/hgaNiJ7LhcrLJWJXoesViGcAq8MvA1OUDim
        xtSvVi0WWuMFsZug27jemOAJ+UI7SxQwsnc/YLU41yLEfrrMP3uKlRKdTvxf9K9fTPRk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltXsz-009kVX-8C; Wed, 16 Jun 2021 17:55:25 +0200
Date:   Wed, 16 Jun 2021 17:55:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net-next 1/8] net: phy: change format of some
 declarations
Message-ID: <YMoe7WyeQ8p7ytSD@lunn.ch>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
 <1623837686-22569-2-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623837686-22569-2-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 06:01:19PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> Add a blank line after declarations, change the order of them and put the
> assignments and declarations together.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
