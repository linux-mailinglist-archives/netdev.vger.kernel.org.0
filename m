Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AA54C3469
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiBXSQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiBXSQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:16:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A05A253170
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 10:15:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 043B8B8283F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 18:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFDEC340E9;
        Thu, 24 Feb 2022 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645726544;
        bh=KmSRtGcpig6VMB9+/HtC8AWyAMr1pJtVGyUV51MCbuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e43qbM9UzuLtccu+znYpfpevtATfyCZ3jSIqTZus+cH4dE06IXARxdPGoVhjCNNjM
         iqPN0Dk0BoTleVozxQNCADRZuWTW18xasl1k/JToup/tPGP3qBgX4uI/ONBBlZyKFr
         pC/WjtNPLfc8zZgpgBVDgz3nszEyt0YDBdXx7paBLtz5H+K2FQfg0xr1xnsH9zISO5
         doiKqYenZzZMrwStyimof78oVm5V3R1n+gdoMIPzatKw4g2UtMt/VP4HbMFwYalCwk
         yQskoXJE9w18GzVqTGfpRil7biK22qrqwPwZLZ3ciKBI5NedtxFE9XpCRPG1tMpQBB
         1XBteIOmkzE3g==
Date:   Thu, 24 Feb 2022 10:15:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>,
        "Mishra, Sudhansu Sekhar" <sudhansu.mishra@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T
 device
Message-ID: <20220224101543.707986e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2da98bc3f97ef42dc6a054acc74894cd25031cd6.camel@intel.com>
References: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
        <20220215001807.GA16337@hoboy.vegasvil.org>
        <4242cef091c867f93164b88c6c9613e982711abc.camel@intel.com>
        <19a3969bec1921a5fde175299ebc9dd41bef2e83.camel@intel.com>
        <20220223203729.GA22419@hoboy.vegasvil.org>
        <2da98bc3f97ef42dc6a054acc74894cd25031cd6.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Feb 2022 17:26:15 +0000 Nguyen, Anthony L wrote:
> If you're okay with this, it looks like this patch still applies
> cleanly. Would you like me to resend it or did you want to use this
> one?

Are we talking about this?

+struct ice_aqc_i2c {
+	struct ice_aqc_link_topo_addr topo_addr;
+	__le16 i2c_addr;
+	u8 i2c_params;
+#define ICE_AQC_I2C_DATA_SIZE_S		0
+#define ICE_AQC_I2C_DATA_SIZE_M		(0xF << ICE_AQC_I2C_DATA_SIZE_S)
+#define ICE_AQC_I2C_USE_REPEATED_START	BIT(7)
+	u8 rsvd;
+	__le16 i2c_bus_addr;
+	u8 rsvd2[4];
+};

You can definitely improve it, even with the defines "inline" I'm 
not sure looking at this code which field those defines pertain to.
I'm guessing it's i2c_params because the next one is rsvd. Plus you 
should use kernel FIELD_* or filed_* accessors instead of defining
masks and shifts separately. I think I'm with Richard.
