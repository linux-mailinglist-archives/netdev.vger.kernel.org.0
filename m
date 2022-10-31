Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2092C6132DC
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiJaJgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJaJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:36:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBE56353;
        Mon, 31 Oct 2022 02:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB9BEB81334;
        Mon, 31 Oct 2022 09:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7254CC433C1;
        Mon, 31 Oct 2022 09:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208967;
        bh=NWP8gi9S/VZYCjeSODWW1dww8BeQZjjjdJ+ZdO3A5BA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QwwEr6n94lXelYwpg7CAF/Ac3hdtDXSx+FMvb9eFBsZ96QA/hKiGSD3GS41hrnPRf
         De5Hlk7yq09aAjvK+Iel4JJ9RkDWmjj9LD15jAmpMrgKDAYvEp1z3t8Y/IdyiPRWOI
         IqWHJ/uPxZtdguqT4Pr4dQ9zw4Zo1INsMKbCG2routlqCHsQM7ntxWWOKk9Sk1Vpm0
         DWJxFh9raSebfmRlpmr3UQxwjXaoLH9BNJKUtTOSZBfvAkT6NE8m7WhelO529vmauo
         jAWE/jCjRE2z/B2J5JF77OTM1OUrW9Ze9az2aS5bAk3JDBF0cUWVzLQXy1YuhXhxpN
         ykWWZd2sJafew==
Date:   Mon, 31 Oct 2022 09:36:00 +0000
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC v4 net-next 17/17] mfd: ocelot: add external ocelot switch
 control
Message-ID: <Y1+XAC/VH6gP9RIz@google.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-18-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221008185152.2411007-18-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 08 Oct 2022, Colin Foster wrote:

> Utilize the existing ocelot MFD interface to add switch functionality to
> the Microsemi VSC7512 chip.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v4
>     * Integrate a different patch, so now this one
>       - Adds the resources during this patch. Previouisly this
>         was done in a separate patch
>       - Utilize the standard {,num_}resources initializer
> 
> v3
>     * No change
> 
> v2
>     * New patch, broken out from a previous one
> 
> ---
>  drivers/mfd/ocelot-core.c | 60 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)

For my own reference (apply this as-is to your sign-off block):

  Acked-for-MFD-by: Lee Jones <lee@kernel.org>

-- 
Lee Jones [李琼斯]
