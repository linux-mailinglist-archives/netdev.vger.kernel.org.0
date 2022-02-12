Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0969F4B37A3
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 20:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiBLTgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 14:36:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiBLTgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 14:36:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B64A606CB
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 11:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SlGcP/IGp8w30qTBDl0DEE8FkP32xJ4+NO1+MbDgM/w=; b=Xn1JCa8q9W4FUOColtzGPFBmgB
        Iv5HN3L/XGkKuBuHsERF+zCXxO5YB5A6E3/A0HhuB4KlRaJMpgt1RG6J+wyBs0porOlIMVKhatHXs
        f7tZYtNWO6lUGno9CufWXEnajBV0f8v5rAlA5Q4Znm+Z3t0k+P3haJc0/oa6VCRVYQjY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIyBn-005eIE-PE; Sat, 12 Feb 2022 20:36:11 +0100
Date:   Sat, 12 Feb 2022 20:36:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next] net: dsa: realtek: rename macro to match
 filename
Message-ID: <YggMK6AFBVABYjkP@lunn.ch>
References: <20220212022533.2416-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220212022533.2416-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 11:25:34PM -0300, Luiz Angelo Daros de Luca wrote:
> The macro was missed while renaming realtek-smi.h to realtek.h.
> 
> Fixes: f5f119077b1c (net: dsa: realtek: rename realtek_smi to)
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
