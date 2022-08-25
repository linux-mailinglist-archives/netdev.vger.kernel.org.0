Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C605A11D6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbiHYNUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241610AbiHYNUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:20:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4951910BB;
        Thu, 25 Aug 2022 06:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6HMxahn1EDQiz4DxfnN3F/RqZWfOR3K+Oe1CabJOFl0=; b=CRAHICCWs6375tr74PQdoE65wv
        OCs8t91QYVXeHAwzmlqzS2/z7Uz9KZQXcynCfjF4+18oIfbv3JjNZYD/C7qPQWYnaX20oxz2vcsrW
        OtN1g35yWKd+LcuEQygN4llGZa9537XTKjnZk4vS+rWzs6cVFD8chEUYrjaUKh1VEemo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRClu-00EZZP-B1; Thu, 25 Aug 2022 15:19:46 +0200
Date:   Thu, 25 Aug 2022 15:19:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <Ywd28j0TJjW/ZWUU@lunn.ch>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825080549.9444-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 01:35:49PM +0530, Divya Koppera wrote:
> Supports SQI(Signal Quality Index) for lan8814 phy, where
> it has SQI index of 0-7 values and this indicator can be used
> for cable integrity diagnostic and investigating other noise
> sources.

This driver supports 16 PHY devices. You only add this to one. Are you
sure it does not work with others?

     Andrew
