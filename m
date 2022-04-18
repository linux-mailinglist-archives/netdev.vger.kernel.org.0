Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB615506056
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiDRXvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiDRXvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:51:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5EB1EAEE
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=+mILBtu4ojlYfvx5i4722NMOMLi0Gu19JBHCEMFQSMI=; b=uz
        uTY7jpOdh1UMlUo0V3hxdaj7JM36FlYXyPz2FWV+DpWi5wrTeqw9kp7KBd8eXgtJ+B7kN0yVsOHbP
        JS95xLmOKE4d8ixlPHBu1CQKY6/q+XCY0Q325BNzRayz/PJ5iq7RpEGFxm/vgVNj7ZYAJknA0P2NY
        SE7bG15NpDHHE5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngb6V-00GPOP-6t; Tue, 19 Apr 2022 01:48:23 +0200
Date:   Tue, 19 Apr 2022 01:48:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzk+dt@kernel.org, arinc.unal@arinc9.com
Subject: Re: [PATCH net v2 2/2] net: dsa: realtek: remove realtek,rtl8367s
 string
Message-ID: <Yl34x+GDBkBKBggN@lunn.ch>
References: <20220418233558.13541-1-luizluca@gmail.com>
 <20220418233558.13541-2-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220418233558.13541-2-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 08:35:58PM -0300, Luiz Angelo Daros de Luca wrote:
> There is no need to add new compatible strings for each new supported
> chip version. The compatible string is used only to select the subdriver
> (rtl8365mb.c or rtl8366rb.c). Once in the subdriver, it will detect the
> chip model by itself, ignoring which compatible string was used.
> 
> Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
