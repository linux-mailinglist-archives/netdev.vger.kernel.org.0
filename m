Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55CE62BFCC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiKPNmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiKPNmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:42:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EF643AD1;
        Wed, 16 Nov 2022 05:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vOhf5Vs6Hr0hFLYE0bv9EyZDIkrIxvZ7t0QosSy46mc=; b=kZE4gqPIYo/A4YjNtK5dgxelvc
        bjDr5FzQ385E0lRz8s9S9mn1/ziD2ZOPIaTIMDyYsZxWFL2obLV7zSWqbxV86H8PPuK1bQsd1gaBo
        ifyn0eLn93N16vKL9mKeSXzFYjpm8bgYnlW6rX+nwKtgtMsSb5zI5Wb9/18Q3/XiqOyM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovIfy-002ZVJ-2K; Wed, 16 Nov 2022 14:42:02 +0100
Date:   Wed, 16 Nov 2022 14:42:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] net: dsa: set name_assign_type to NET_NAME_ENUM
 for enumerated user ports
Message-ID: <Y3ToqglHWb+QKnz2@lunn.ch>
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-4-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116105205.1127843-4-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 11:52:04AM +0100, Rasmus Villemoes wrote:
> When a user port does not have a label in device tree, and we thus
> fall back to the eth%d scheme, the proper constant to use is
> NET_NAME_ENUM. See also commit e9f656b7a214 ("net: ethernet: set
> default assignment identifier to NET_NAME_ENUM"), which in turn quoted
> commit 685343fc3ba6 ("net: add name_assign_type netdev attribute"):
> 
>     ... when the kernel has given the interface a name using global
>     device enumeration based on order of discovery (ethX, wlanY, etc)
>     ... are labelled NET_NAME_ENUM.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
