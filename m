Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F1681E27
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 23:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjA3WeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 17:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjA3Wd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 17:33:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EC9C655;
        Mon, 30 Jan 2023 14:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EfdNTnk9TBSamoP2JzjdKer/iDymiosZUNSEn3LqCa8=; b=qh//3/1vAmN8NouKaa4Q8N184l
        H+R38PyMF4uLYAk9+f7nwrG3aGF6WmfXDUt+Bo8o/QV6RuBrlPycA5fYEVzIBXtAOgiSvWwio7F3b
        3eQBEe40K7NqxzK98poOlqQ+3t2k6ReYeOAXskErbzUXVXK0gTi0DmUngp21BUqldaZE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMcig-003d7F-DB; Mon, 30 Jan 2023 23:33:46 +0100
Date:   Mon, 30 Jan 2023 23:33:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/2] net: mdio: add amlogic gxl mdio mux
 support
Message-ID: <Y9hFyqANYqZee1JE@lunn.ch>
References: <20230130151616.375168-1-jbrunet@baylibre.com>
 <20230130151616.375168-3-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130151616.375168-3-jbrunet@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 04:16:16PM +0100, Jerome Brunet wrote:
> Add support for the mdio mux and internal phy glue of the GXL SoC
> family
> 
> Reported-by: Da Xue <da@lessconfused.com>
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
