Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29E5613821
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiJaNdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiJaNcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:32:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A5010554;
        Mon, 31 Oct 2022 06:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8yyvfwDpAKpyb8m69eVKr5lOcCham69PMp6CPAhA13Q=; b=xC+diylspD9rQWeAOigRmWl1I9
        NZX1cLJfh4nlzhI5yadi9uvpQuZxJh/TgJ98ZgbFFuJh/4eXyZrbFDZWaKH5IcO0RQfVOuVpw/3HB
        80DgEdd1y9csTwGzjp8k50obDPlQo3zQ3Sfc8DK1azUYOAToWEmotwnf3CMvOpB89L5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opUu1-0011SN-AA; Mon, 31 Oct 2022 14:32:33 +0100
Date:   Mon, 31 Oct 2022 14:32:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v7 2/3] net: ethernet: renesas: Add support for "Ethernet
 Switch"
Message-ID: <Y1/OcdvPS1bOHo9I@lunn.ch>
References: <20221031123242.2528208-1-yoshihiro.shimoda.uh@renesas.com>
 <20221031123242.2528208-3-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031123242.2528208-3-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 09:32:41PM +0900, Yoshihiro Shimoda wrote:
> Add initial support for Renesas "Ethernet Switch" device of R-Car S4-8.
> The hardware has features about forwarding for an ethernet switch
> device. But, for now, it acts as ethernet controllers so that any
> forwarding offload features are not supported. So, any switchdev
> header files and DSA framework are not used.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
