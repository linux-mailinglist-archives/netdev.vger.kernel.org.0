Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1755026F
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbiFRDZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbiFRDZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6A637032;
        Fri, 17 Jun 2022 20:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD912B82D23;
        Sat, 18 Jun 2022 03:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4514EC3411B;
        Sat, 18 Jun 2022 03:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655522739;
        bh=0RgRGYkZzENCX4Mc2hUdCOmQVqdNIJLs6theSy9ongQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=diW5nfCR9ao8YWEiPGHBYrh230kdWRj1uIVkDD/oSrf31ms0Ecz/jYf6ZUvHQ47SM
         n1P6zfBiM/M0wWZGIfnI4u9Kp/uoPlIcEvP1WHMtqwaajEPVvPrJDz1NemEplEME5f
         dwWHXkuPgoMOd2kna4D7d2VCRcczr9vVb04sOdA6c8Ee7+fFHYZ0bhHHpL4nuquavd
         nM+87ZZ4yDxad6kYpsE2RaC8X14b73tnYdadc/Sg9cEEwyNNiIBY/pMe0UYQE7WEEz
         ZF8H3JxRN/4WYLYIbR6CqoZ13pmefH/sTcTJuduZBfb+zIJAVlFfmBWdD3fZQcdgC9
         kWt5cBmeyrfIg==
Date:   Fri, 17 Jun 2022 20:25:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: phy: at803x: fix NULL pointer
 dereference on AR9331 PHY
Message-ID: <20220617202538.234b6f48@kernel.org>
In-Reply-To: <20220617045943.3618608-1-o.rempel@pengutronix.de>
References: <20220617045943.3618608-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jun 2022 06:59:43 +0200 Oleksij Rempel wrote:
> Subject: [PATCH net-next v2 1/1] net: phy: at803x: fix NULL pointer dereference on AR9331 PHY

> Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")

The patch under Fixes is in net, why target net-next?

Please repost with [PATCH net]
