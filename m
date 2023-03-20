Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98D66C0C85
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 09:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjCTIuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 04:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjCTIuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 04:50:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCC7D330;
        Mon, 20 Mar 2023 01:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AF60B80D7E;
        Mon, 20 Mar 2023 08:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673FEC433EF;
        Mon, 20 Mar 2023 08:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679302188;
        bh=ZOGGGKiTpZNldxTGPSbHJBbYnJcBl4dpdhlNwkX07j8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XDa+CpyJEbo3Mzrqm+czSbFRB/XZAQZ3SnwNK+nAxgZPQu+o76h/sCEKNVGpKSeE0
         BowtlOc4Mq3St5ngmQtdhtiKGm1QlhOLgjzpfwWwLxFp/yfyhOP3pOWBmdtlYvb59t
         aP0a6NQDG1ZmPWVP5Pl+yXxV0i+AfMoIhpBdAW7T4Of6og/787y1hJU8u/YshqzfiB
         W4G7ngETRqHZ0O79Erk6Wg2pnRTipmhaPhQu0oadTN65UZSR106skEISX+Ruvcj2FK
         JN1kBwKiBLvmjzrVkd5rDA0glqBEsy5mt9Ogs1aZqCPWUMAJeC5ZZETjROX6DpHpRH
         rLSkgYqVu4ndg==
Date:   Mon, 20 Mar 2023 14:19:44 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v2 net-next 1/9] phy: phy-ocelot-serdes: add ability to
 be used in a non-syscon configuration
Message-ID: <ZBgeKM50e1vt+ho1@matsya>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
 <20230317185415.2000564-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317185415.2000564-2-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17-03-23, 11:54, Colin Foster wrote:
> The phy-ocelot-serdes module has exclusively been used in a syscon setup,
> from an internal CPU. The addition of external control of ocelot switches
> via an existing MFD implementation means that syscon is no longer the only
> interface that phy-ocelot-serdes will see.
> 
> In the MFD configuration, an IORESOURCE_REG resource will exist for the
> device. Utilize this resource to be able to function in both syscon and
> non-syscon configurations.

Applied to phy/next, thanks

-- 
~Vinod
