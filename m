Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD19E5176A5
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381085AbiEBSli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiEBSlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:41:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4140C7645;
        Mon,  2 May 2022 11:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ABxy0wS80KF+pBKz64zQirAM63Sv5abMFRGPRfjm7oo=; b=ssamXQW0RHFKNrdzU1gpi5MEpZ
        X+aoTCHifrMOcrYpprEsQUZsy8R7mjvdw0J+Tqe5K94SI30+Ujl9xmT1pRA5vDp1CzmX7/fxt3VKA
        yUtJ/OIBjo6ZteX6qVmfCY9+zUTXBt8mv7UiDWev9q7cB7zMhLsiAE4MJHvseWMXUmXA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nlavm-000wL6-81; Mon, 02 May 2022 20:37:58 +0200
Date:   Mon, 2 May 2022 20:37:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: Add tx-fault quirk for Huawei MA5671A SFP ONT
Message-ID: <YnAlBvWyyJ9oDcpz@lunn.ch>
References: <20220430124803.1165005-1-mnhagan88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430124803.1165005-1-mnhagan88@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
> +	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
> +		sfp->tx_fault_ignore = true;
> +	else
> +		sfp->tx_fault_ignore = false;
> +
> +	return 0;
> +
>  	return 0;

Why do we need two return 0; Probably a merged conflict gone wrong.

    Andrew
