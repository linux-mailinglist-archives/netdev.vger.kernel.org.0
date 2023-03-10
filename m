Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84B06B3723
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjCJHK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCJHKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:10:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA191070F0;
        Thu,  9 Mar 2023 23:10:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9BA260DBF;
        Fri, 10 Mar 2023 07:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56489C433D2;
        Fri, 10 Mar 2023 07:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678432246;
        bh=VR1mKclschmFMjDRwvJBhuSRexdBJAOKmZHA86cnb2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bmb6ZwhLV4T9BIFnVhpjm7NxRsX3o0ta05h619BcJ6VuKOCSKJMyuB+nnYdk34PyA
         FeEtJdmhm8NGpwAvXc9kNVHl2r3ZQhi2gCii+nrGjeYC1VJmCbXFTYGI2fPCcmWXP5
         D+JrF5PAsfqp0wapqvo1YPWOhKng2OwAWKin66IRXp60Ic7NxIWa+MxhUC2nJemz7n
         aYNoKMTugt+UEy2vgAuRWRAYkaEjZ7QOCTIew2fxlFMZp4WOFrGrls3zM4KbABI+1b
         RMPWYk06pZWPRoc8QZQrJQdfxk0i4WDgC3rp7iv2G4h2XBvyAHphbwERynjzwVLGMC
         jZYxdGTASx8vg==
Date:   Thu, 9 Mar 2023 23:10:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 net 1/2] net: dsa: mt7530: remove now incorrect
 comment regarding port 5
Message-ID: <20230309231044.1dc41bf9@kernel.org>
In-Reply-To: <20230308130714.77397-1-arinc.unal@arinc9.com>
References: <20230308130714.77397-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Mar 2023 16:07:14 +0300 arinc9.unal@gmail.com wrote:
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index a508402c4ecb..b1a79460df0e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2201,7 +2201,7 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  	mt7530_pll_setup(priv);
>  
> -	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
> +	/* Enable port 6 */

I think you posted before Vladimir's patch went in, so even tho 
it applies now the CI/build bot could not test it. Please repost.
