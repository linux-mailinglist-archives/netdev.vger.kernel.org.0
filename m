Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F42A3AA0F2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbhFPQMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:12:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPQMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:12:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=98RvjIliQ3Q1LTOvhKy6uwgGrK7LdLKt4+7ZHnkgHlY=; b=hkSfuw+i2LlOgePlQgtSBE69dO
        f5WZ68VtQvn69YTIRajKjlCzV32kA5eoTaQZLiVGW2lqQSp7UqFpL71JUSuChVjWIH5kljcMZTmjS
        FJJHwk05n+OVQ821AqJ8raFDyMRNvrdEd52Jr6STRhPjw5qdbmIoH+7ttTg1E4Rut+Qk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltY73-009kk4-Qc; Wed, 16 Jun 2021 18:09:57 +0200
Date:   Wed, 16 Jun 2021 18:09:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v2 net-next 8/8] net: phy: replace if-else statements
 with switch
Message-ID: <YMoiVXqkzdBzd17Y@lunn.ch>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
 <1623837686-22569-9-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623837686-22569-9-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 06:01:26PM +0800, Weihang Li wrote:
> Switch statement is clearer than a group of 'if-else'.
> 
> Signed-off-by: Weihang Li <liweihang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
