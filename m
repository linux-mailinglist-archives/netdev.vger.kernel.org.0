Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974CF5776F3
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiGQPOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiGQPOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:14:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB907656C
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VHEIl6J4Dv6zcYMcfOapxKhtQukbRO5H+I1+oVlI/N4=; b=bahsPf7sB2yBjlidvobdEfyIxw
        bnxokqOgyWnjhdquo7M77kljN7m6hiDFqdr9T3w37VGhRYHP9m1PLo5s+pHTzbUp+GIMXB+I0daru
        R53b7Dk/T+PUu/y4URGc/J6RKBMhMOs32ANce2OH/oSlo4lA9JHs9dh5jX82fs+zpPyo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oD5yc-00Actx-Fu; Sun, 17 Jul 2022 17:14:34 +0200
Date:   Sun, 17 Jul 2022 17:14:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net 01/15] docs: net: dsa: update probing documentation
Message-ID: <YtQnWsz/X6yGBo3g@lunn.ch>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716185344.1212091-2-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir

> +Switch registration from the perspective of a driver means passing a valid
> +``struct dsa_switch`` pointer to ``dsa_register_switch()``, usually from the
> +switch driver's probing function. The following members must be valid in the
> +provided structure:

> +
> +- ``ds->priv``: backpointer to a driver-private data structure which can be
> +  retrieved in all further DSA method callbacks.

I'm not sure this is strictly true. The DSA core itself should not use
ds->priv. And the driver could use other means, like
dev_get_platdata(ds->dev->pdev) to get at is private data. But in
practice it is true.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
