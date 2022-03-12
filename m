Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFEA4D70D2
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 21:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiCLU03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 15:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiCLU01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 15:26:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EEA205E01;
        Sat, 12 Mar 2022 12:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W98kJ8M5wU591OAtrR3WbZqBuGols1ohFkbdgxOPZmQ=; b=YXWkPF+Ud0qtMHwCIRWl+Z4utS
        BShtIUsURWMw2TsLlE7kSNs7kUU6aKCaBlSZwepfW/5SEHoO/0Iu7FjErDqVDpmtJLDXCHQSwbtIt
        dKpAXm/tuCPANtqEdpT8FUqyUJhYem6qGg81CPIp2JZ5k4EFWuOFr/ygN8NWeqNUXTpc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nT8IW-00AVUA-3z; Sat, 12 Mar 2022 21:25:08 +0100
Date:   Sat, 12 Mar 2022 21:25:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org, kabel@kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: phy: marvell: Fix invalid comparison in the
 resume and suspend functions
Message-ID: <Yi0BpO5er+5w7UDY@lunn.ch>
References: <20220312002016.60416-1-kurt@x64architecture.com>
 <20220312201512.326047-1-kurt@x64architecture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312201512.326047-1-kurt@x64architecture.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 03:15:13PM -0500, Kurt Cancemi wrote:
> This bug resulted in only the current mode being resumed and suspended when
> the PHY supported both fiber and copper modes and when the PHY only supported
> copper mode the fiber mode would incorrectly be attempted to be resumed and
> suspended.
> 
> Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
> Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>

Hi Kurt

Best practice is to add any Reviewed-by or Tested-by to the patch
whenever you repost it, except when you make major changes. Otherwise
they can get lost.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
