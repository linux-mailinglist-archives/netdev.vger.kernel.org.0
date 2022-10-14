Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA00D5FEDA1
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 13:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiJNLyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 07:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJNLyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 07:54:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F11958C1;
        Fri, 14 Oct 2022 04:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y5HkdSnQwwhYn4XoEiPn5A22fhd1yJEXYYhQPNU+LGM=; b=oSwL4IiL0f5UKhk4F9ianYv3pY
        Bg/1K9c4/3pUk6izxRed4/LhGXeVTc8bnI9OAKinVFRzOXx0c74wJ2zSFryQxjs5xngZkgXjQGtQV
        ACOZTDYwx+ElZ67HyuHtzpIKdNF7sHBAazP3Y/oebUPJecxdgdxomMDJYHjLqE0ItB+8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ojJFP-001y3r-8a; Fri, 14 Oct 2022 13:53:03 +0200
Date:   Fri, 14 Oct 2022 13:53:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harini.katakam@amd.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, michal.simek@amd.com,
        radhey.shyam.pandey@amd.com
Subject: Re: [PATCH v2] net: phy: dp83867: Extend RX strap quirk for SGMII
 mode
Message-ID: <Y0lNn4Eqgyu5YS87@lunn.ch>
References: <20221014064735.18928-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014064735.18928-1-harini.katakam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 12:17:35PM +0530, Harini Katakam wrote:
> When RX strap in HW is not set to MODE 3 or 4, bit 7 and 8 in CF4
> register should be set. The former is already handled in
> dp83867_config_init; add the latter in SGMII specific initialization.
> 
> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Please see the netdev FAQ. You are supposed to put the tree this patch
is for in the subject line, [PATCH net v2] ... etc. Please remember
this for next time.

    Andrew
