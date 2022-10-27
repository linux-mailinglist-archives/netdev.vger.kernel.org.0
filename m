Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC52460FF6C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiJ0Rg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbiJ0Rg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:36:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F5C4B0D3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K19V505AmhYi402yEu6tSKylDjTCTtgNR1/rmog4GpA=; b=TG9qv6T9iEgfyURi3vaSANiLR0
        wBeMAhBviRi1b8tPijEJk8NpF0mBzETJmnERdfQ3g1Oq4q9FWq4EI6GT9lqG9dU9RTC2MuTYwC2tr
        KmiPCq2zncnGq9Ev/VqtIK+xrursW3fiza3BcdRk8vKhOCkOG7VcFIkCJy3NjEl4n8Hs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oo6oC-000jmC-9O; Thu, 27 Oct 2022 19:36:48 +0200
Date:   Thu, 27 Oct 2022 19:36:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next] phy: convert to boolean for the mac_managed_pm flag
Message-ID: <Y1rBsJT2UBzprHEm@lunn.ch>
References: <4bca2d92-e966-81d7-d5a6-2c4240194ff4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bca2d92-e966-81d7-d5a6-2c4240194ff4@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 06:05:27PM +0300, Denis Kirjanov wrote:

The subject "[net-next] phy:" is not very helpful. You don't change
any generic PHYs, not network PHYs. "drivers: net " would be a better
prefix, it at least makes it clear it is touching multiple network
drivers.

The change itself is O.K.

    Andrew
