Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23E94F6B6B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbiDFU36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbiDFU3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:29:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698E01A397B
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 11:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B69B81C83
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 18:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6D2C385A5;
        Wed,  6 Apr 2022 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649271171;
        bh=nrUs+OgbcF/TQelOzfe+pb1CAB4eIs6PKGZnjXJNeW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sTqP7d7u46gWoHKsoDtLH6oUOKjFyXMNobx2YOZta7MBmWAk83Fzg2xZIjxlKCDqS
         YdJlxgfSqKwvj3UL40BRLWVMRl2aGJGLNhg82iqQcuEAj1BEN469pl/QsynugJX7Ee
         dIO+0fCETGGeaYCt/N2u16tJSzXdO2C+XSnPJDiAWzf9rjL2KtTZdQ8pfjAcY3e4UU
         j6Uy1SjxMhJuM0b5cSwLZS2s2uKpAgL+oOJ44gZnhQSpNsbwXBrnS8iPV14ohpKCGU
         zfhjIbmERwVvTeYgkcScq6WVIZYIawSennGQ0kACk5Iax8VcWd/k1xD+xjJT5iKqeA
         vI0L8CKmrsz4g==
Date:   Wed, 6 Apr 2022 11:52:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 5/9] net: dsa: mt7530: only indicate linkmodes
 that can be supported
Message-ID: <20220406115250.047570c1@kernel.org>
In-Reply-To: <E1nc3Dd-004hq7-Co@rmk-PC.armlinux.org.uk>
References: <Yk1iHCy4fqvxsvu0@shell.armlinux.org.uk>
        <E1nc3Dd-004hq7-Co@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 06 Apr 2022 11:48:57 +0100 Russell King (Oracle) wrote:
> -	if (state->interface != PHY_INTERFACE_MODE_MII) {
> +	if (state->interface != PHY_INTERFACE_MODE_MII &&
> +	    state->interface != PHY_INTERFACE_MODE_2500BASEX)
>  		phylink_set(mask, 1000baseT_Full);
>  		phylink_set(mask, 1000baseX_Full);
>  	}

Missing { here. Dunno if kbuild bot told you already.
