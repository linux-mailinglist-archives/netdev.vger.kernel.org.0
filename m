Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D076C11B7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjCTMUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjCTMT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:19:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72068A6F;
        Mon, 20 Mar 2023 05:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=SDD2xJ9FtOaz057f1e0KNKm4B5SAK+5TSxOhygHPfmo=; b=1w
        rdnMO1b64ZpMqakitSxyQBaffNeeeCm17bGLoouwArT2eohNOoSiefGwU+Uj2CvAAjh3JFHQKOyQ7
        Mr8lxtUJffGL5ubboBztBhb/PHm1+nLjyXP43A5lUkJ2Rod+19/xFyaPIz/TzvicjsKAd72R0IROR
        VEuTtmYUugpUoEQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1peEUO-007qFk-S2; Mon, 20 Mar 2023 13:19:48 +0100
Date:   Mon, 20 Mar 2023 13:19:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: b53: add support for BCM63xx RGMIIs
Message-ID: <2f86d1ab-beae-45ec-b130-57865437c8a7@lunn.ch>
References: <20230319183330.761251-1-noltari@gmail.com>
 <20230319220805.124024-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230319220805.124024-1-noltari@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 11:08:05PM +0100, Álvaro Fernández Rojas wrote:
> BCM63xx RGMII ports require additional configuration in order to work.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
