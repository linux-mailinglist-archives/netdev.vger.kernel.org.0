Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAB819D36
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfEJM1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 08:27:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60187 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727071AbfEJM1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 08:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eNH9H4PLrdXN2AdkKhoFI5Ej0xuYYGf6KfUsQnOFlyY=; b=kTRqqECCSGBKRpDbbduzoNijiQ
        1tGXmnhJwnjSwfpMsBy2ka7yGv+Lf2laCZb32UuihFnT3J82aL3UMTWuOoY3gMuxnHGTNN6RdugEP
        KzErxfxvGeEXAeoy5OQWKulaNDiEq/m6NLS0YjH7ZBjF4EGJTXl/GGNrj5KkbhMGpKqE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hP4c1-0002JG-Pf; Fri, 10 May 2019 14:26:53 +0200
Date:   Fri, 10 May 2019 14:26:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dsa: tag_brcm: Fix build error without
 CONFIG_NET_DSA_TAG_BRCM_PREPEND
Message-ID: <20190510122653.GD4889@lunn.ch>
References: <20190510030028.31564-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510030028.31564-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 11:00:28AM +0800, YueHaibing wrote:
> Fix gcc build error:
> 
> net/dsa/tag_brcm.c:211:16: error: brcm_prepend_netdev_ops undeclared here (not in a function); did you mean brcm_netdev_ops?
>  DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
>                 ^
> ./include/net/dsa.h:708:10: note: in definition of macro DSA_TAG_DRIVER
>   .ops = &__ops,       \
>           ^~~~~
> ./include/net/dsa.h:701:36: warning: dsa_tag_driver_brcm_prepend_netdev_ops defined but not used [-Wunused-variable]
>  #define DSA_TAG_DRIVER_NAME(__ops) dsa_tag_driver ## _ ## __ops
>                                     ^
> ./include/net/dsa.h:707:30: note: in expansion of macro DSA_TAG_DRIVER_NAME
>  static struct dsa_tag_driver DSA_TAG_DRIVER_NAME(__ops) = {  \
>                               ^~~~~~~~~~~~~~~~~~~
> net/dsa/tag_brcm.c:211:1: note: in expansion of macro DSA_TAG_DRIVER
>  DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
> 
> Like the CONFIG_NET_DSA_TAG_BRCM case,
> brcm_prepend_netdev_ops and DSA_TAG_PROTO_BRCM_PREPEND
> should be wrappeed by CONFIG_NET_DSA_TAG_BRCM_PREPEND.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: b74b70c44986 ("net: dsa: Support prepended Broadcom tag")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
