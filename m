Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE14D4C44
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiCJOyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346118AbiCJOmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:42:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4823CE02F7;
        Thu, 10 Mar 2022 06:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yZ/yTUDNAlAVUPMpR6OP/+6VoPuOWZEY8uz25QGnmxE=; b=IY5uHqX84hc6MPM+gkh4wQxXMh
        SvZPOu2tYS490x1if7OvjfV2Ma/liN+2dF11r+kQjbo3HVcTqvH3rXiqz1wzKdpqkxKewP85eygjz
        BsVVhKD80zELBQCWI05o6XVROJllhV5jd/33n+JX2D1B8n8u0kon13zKMhmstnttlK2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nSJvj-00A9CZ-7v; Thu, 10 Mar 2022 15:38:15 +0100
Date:   Thu, 10 Mar 2022 15:38:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] net: phy: Kconfig: micrel_phy: fix dependency issue
Message-ID: <YioNV4G/OJmeEt0Z@lunn.ch>
References: <20220310101744.1053425-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310101744.1053425-1-anders.roxell@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The description says:

> Rework Kconfig for MICREL_PHY to depend on 'PTP_1588_CLOCK_OPTIONAL ||
> !NETWORK_PHY_TIMESTAMPING'.

>  config MICREL_PHY
>  	tristate "Micrel PHYs"
> +	depends on PTP_1588_CLOCK_OPTIONAL

But you actually added only a subset?

    Andrew
