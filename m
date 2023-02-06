Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9534C68BE35
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjBFNbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjBFNbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:31:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF219241CC;
        Mon,  6 Feb 2023 05:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EL+eliTSYThwoQEr1IlZuxjX4Q7b2kGWenFUilH/GhM=; b=3GvKuJgyWl1LcjEwyZpd0wRPik
        ag4FUOjYiwQ/ukipHWckzE6bU3Y6ZYve174t8NGoCcEcEMbL8TiNz+8Z/CMmFCu1UUqnTjZW0G75J
        BtIIpL2D2ZFpfnn/fHZKZn1AEnb5ofwTpG/n07ZhIKns0fApE91DszLjBdaebHEoPz1Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pP1aQ-004CmF-3g; Mon, 06 Feb 2023 14:31:10 +0100
Date:   Mon, 6 Feb 2023 14:31:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael@walle.cc
Subject: Re: [PATCH net-next v3 2/2] dt-bindings: net: micrel-ksz90x1.txt:
 Update for lan8841
Message-ID: <Y+EBHsAtbb9paTTm@lunn.ch>
References: <20230206082302.958826-1-horatiu.vultur@microchip.com>
 <20230206082302.958826-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206082302.958826-3-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 09:23:02AM +0100, Horatiu Vultur wrote:
> The lan8841 has the same bindings as ksz9131, so just reuse the entire
> section of ksz9131.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
