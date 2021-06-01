Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDDD397B8B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 23:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhFAVIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 17:08:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhFAVIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 17:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=saC4lXX3Yu3TcJR9oyjMPkfPxaiIt07IEhAIqDxIDZo=; b=Rou/Ces95nFpKM1/SLufs7jn1d
        kkt7FHqwdCWkrr2nVWzHlTRenN0Sc3QA5an0piJj6xtxaltub9I4xBM1zMJ0Ty3fxe5k/9N0wGD5Y
        CpEOs1dn13R03FW5fVBVHzp1su2UPxLcCWFi2jepEmTnbe+XOJ0fFta3scJRUocGO3uo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loBbM-007LWy-PS; Tue, 01 Jun 2021 23:07:04 +0200
Date:   Tue, 1 Jun 2021 23:07:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next v2 4/4] net: marvell: prestera: try to load
 previous fw version
Message-ID: <YLaheDOkUPinh2Lv@lunn.ch>
References: <20210531143246.24202-1-vadym.kochan@plvision.eu>
 <20210531143246.24202-5-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531143246.24202-5-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 05:32:46PM +0300, Vadym Kochan wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> Lets try to load previous fw version in case the latest one is missing on
> existing system.
> 
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
