Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C44FE633
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350181AbiDLQr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357874AbiDLQrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745DD41633;
        Tue, 12 Apr 2022 09:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A197618E3;
        Tue, 12 Apr 2022 16:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ABBC385A1;
        Tue, 12 Apr 2022 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649781926;
        bh=9WqfLsITCMQXM6BzvIJqgUUTiyJhjqSLaU3vvrhppUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EPRs9cD4B+WGLVGyn7/owde2rI1JLkCO4GeFwhlhNyrTK8tJg89r4e3vS8UwUyRh1
         xjsdyvSayYgzzwg+nELxF7Hl/H8LDlVR1XivUJ6zd0PtLiRzeMlTunNGoB2Dv+KiZX
         PMwfO+se/K+71qvzHp17lAcTuok75yU9D92ZH6zzz4Ksm4/WCF3urCK6OxehCI3Ib9
         4nNKwt7r6lIOTlKMOk83Tt8ASAmAP5SO1amo/0x2uVFsn5FDgEIK42lqMNLGy8Wcny
         zMwYD9j9I8jmBpfbLvXrLkqP32pFT4XUaguBIowlSGimo1QxNjVG6Zc+IEI0qdRW7b
         YS+S+WaZ89rmA==
Date:   Tue, 12 Apr 2022 09:45:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <alexandru.tachici@analog.com>
Cc:     <andrew@lunn.ch>, <o.rempel@pengutronix.de>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: Re: [PATCH v6 4/7] net: phy: Add 10BASE-T1L support in phy-c45
Message-ID: <20220412094524.178b8785@kernel.org>
In-Reply-To: <20220412130706.36767-5-alexandru.tachici@analog.com>
References: <20220412130706.36767-1-alexandru.tachici@analog.com>
        <20220412130706.36767-5-alexandru.tachici@analog.com>
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

On Tue, 12 Apr 2022 16:07:03 +0300 alexandru.tachici@analog.com wrote:
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 36ca2b5c2253..6c3048e2a3ce 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -698,6 +698,8 @@ struct phy_device {
>  	u8 mdix;
>  	u8 mdix_ctrl;
>  
> +	int pma_extable;
> +
>  	void (*phy_link_change)(struct phy_device *phydev, bool up);
>  	void (*adjust_link)(struct net_device *dev);

kdoc warning here:

include/linux/phy.h:711: warning: Function parameter or member 'pma_extable' not described in 'phy_device'

Please allow at least 24h between postings to collect additional
feedback.
