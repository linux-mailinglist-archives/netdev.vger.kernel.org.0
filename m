Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DB6508B17
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354278AbiDTOuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242167AbiDTOuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:50:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A9E3890;
        Wed, 20 Apr 2022 07:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=C4GoOKx29HLtanFXK8nyLuAFb7FrVDGEuR4ipZ5/Enk=; b=ggus6FfwcGrUmCEVtuAKjEye7/
        5N4zG6/SklAl7Xs3k2WURX46WMHwO/kQu7K4PLeeV7dbKB5nYQLGG2nUYMiO4A8MEVdilVqAb3HtQ
        rs3BIN6YtUuFHpim+VKPbFV15Kh0rCc71jo/8GhucVlW7Bk1Wq9N1dDFhkWIetFkrNN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhBc1-00Gg1E-BS; Wed, 20 Apr 2022 16:47:21 +0200
Date:   Wed, 20 Apr 2022 16:47:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] net: mdio: Mask PHY only when its ACPI node is
 present
Message-ID: <YmAc+dzroa4D1ny2@lunn.ch>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-2-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420124053.853891-2-kai.heng.feng@canonical.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 08:40:48PM +0800, Kai-Heng Feng wrote:
> Not all PHY has an ACPI node, for those nodes auto probing is still
> needed.

Why do you need this?

Documentation/firmware-guide/acpi/dsd/phy.rst 

There is nothing here about there being PHYs which are not listed in
ACPI. If you have decided to go the ACPI route, you need to list the
PHYs.

	Andrew
