Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B02163C787
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiK2S4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiK2Szg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:55:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D5261BA2;
        Tue, 29 Nov 2022 10:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HdhNqyL9b6+i/7sE7vyZwnk+0Mb0bUvJtlVA06WsRNk=; b=gYf2PQJ4GAf7YOwlGpsxjpgiSC
        UWWqZkWv26a8We/lOIdE9aemGPJsUEPH7x3lD5LIqQIYjMKDeMYdMdihYP67e0L/DIQaV98V1uIA7
        GWB8esLSw37GG0foLzfCihsZRNI4VIa5qsxeCUuWidjSyaRT+s2yZiPzD9FumnpgsDRI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p05l0-003u8O-Mk; Tue, 29 Nov 2022 19:55:02 +0100
Date:   Tue, 29 Nov 2022 19:55:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 08/12] net: dpaa2-switch replace direct MAC
 access with dpaa2_switch_port_has_mac()
Message-ID: <Y4ZVhhonnUm39qay@lunn.ch>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
 <20221129141221.872653-9-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129141221.872653-9-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 04:12:17PM +0200, Vladimir Oltean wrote:
> The helper function will gain a lockdep annotation in a future patch.
> Make sure to benefit from it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

 Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
