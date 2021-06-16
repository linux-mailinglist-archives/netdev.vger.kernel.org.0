Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1403AA0DF
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhFPQJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:09:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234819AbhFPQJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yEpJUIzrA/ga0HWtih5DkwIBsgEMTje8yEK8KbplSc8=; b=Aol4YZZp7aENPXSNRDcQeDOtDi
        Aw1NYXJ7zT64SF3ikWHYoI5O1D1Qa5EFzcqMA+EXLAmtARFXFEEMzSb2dH/JXEVfJbHI2l0OIyplq
        0vDv06TBTdx01EsR8X/2zgAsYk4blDSuAGfK5IYsznFQiFAcRNCF5sMEWoSt6YUbfX+o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltY4j-009kfr-3t; Wed, 16 Jun 2021 18:07:33 +0200
Date:   Wed, 16 Jun 2021 18:07:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH v2 net-next 4/8] net: phy: fix space alignment issues
Message-ID: <YMohxSui1qZLA7ip@lunn.ch>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
 <1623837686-22569-5-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623837686-22569-5-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 06:01:22PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> There are some space related issues, including spaces at the start of the
> line, before tabs, after open parenthesis and before close parenthesis.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
