Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFEA3982E3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhFBH1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:27:03 -0400
Received: from smtprelay0080.hostedemail.com ([216.40.44.80]:43080 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230099AbhFBH1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 03:27:02 -0400
Received: from omf08.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id EB0FB837F27B;
        Wed,  2 Jun 2021 07:25:18 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 475C11A29F8;
        Wed,  2 Jun 2021 07:25:17 +0000 (UTC)
Message-ID: <76fd35fe623867c3be3f93b51d5d3461a2eabed9.camel@perches.com>
Subject: Re: [PATCH net-next] net: mdio: Fix a typo
From:   Joe Perches <joe@perches.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, linux@armlinux.org.uk
Date:   Wed, 02 Jun 2021 00:25:16 -0700
In-Reply-To: <20210602063914.89177-1-zhengyongjun3@huawei.com>
References: <20210602063914.89177-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.78
X-Stat-Signature: 7bxgeo73qben776ijyiyq46pxkzremma
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 475C11A29F8
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19fhsINR+OZ61+6Rh5yB8tQ+XCilPauFME=
X-HE-Tag: 1622618717-649702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-02 at 14:39 +0800, Zheng Yongjun wrote:
> Hz  ==> hz
[]
> diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
[]
> @@ -203,7 +203,7 @@ static void unimac_mdio_clk_set(struct unimac_mdio_priv *priv)
>  		return;
>  	}
> 
> -	/* The MDIO clock is the reference clock (typically 250MHz) divided by
> +	/* The MDIO clock is the reference clock (typically 250Mhz) divided by

No thanks.

MHz is typical, Mhz is not.

$ git grep -w -i -o -h mhz | sort |uniq -c | sort -rn
   5042 MHz
    571 MHZ
    398 Mhz
    353 mhz
     10 mHz


