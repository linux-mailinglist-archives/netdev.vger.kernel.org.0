Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8E1543289
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241383AbiFHO2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241115AbiFHO2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:28:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C865827FE1;
        Wed,  8 Jun 2022 07:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F3F76CE28C1;
        Wed,  8 Jun 2022 14:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93F0C34116;
        Wed,  8 Jun 2022 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654698522;
        bh=BgepgKpmeUq7/B7mH+sOFV/Unmrp2ez8DXwPXSn6bKg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DM07zktGJkT1qLiX7R1DQ1pl6WmWTQaLQqulJLfPgGwLcWo72KE44StL72TYN2eBv
         zsIMFqwtJDypzlIrFCq1ul8w+QxpUQy9rvhxxWY55QS1fc1Y/9KM0ZepAPG64WpWHY
         THKhBUQL5I19ROw8ZddLDh0KF9BTgcDp7wloPJZ4TAYOTpRM71PyVWOLt6EOvH58SQ
         uM19eGsVIUn117Hk4uGIJN7Nj45ffccDV+Q3OTtN7PkXXtIf9PvtBip6aludNZvuea
         53+LkJPGRjxs6+LrU70aWhhxoJXqN3yaulbgOx8j76Vh3SV7Fr79MVF3K54GxOlMI1
         vaaSAlU5706rQ==
Date:   Wed, 8 Jun 2022 07:28:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] net: phy: dp83td510: add cable diag
 support
Message-ID: <20220608072840.227255b9@kernel.org>
In-Reply-To: <20220608123236.792405-1-o.rempel@pengutronix.de>
References: <20220608123236.792405-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jun 2022 14:32:33 +0200 Oleksij Rempel wrote:
> changes v3:
> - spell fixes

FWIW relatively recently we started asking folks to wait 24h before
reposting:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches

Would be doubly useful here since it sounds like Andrew is out for 
the week.
