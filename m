Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197036D9908
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjDFOH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239030AbjDFOG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:06:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86B1AF13;
        Thu,  6 Apr 2023 07:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G4nuJcd5AfkMWWoRDvdvNvpxfbVN9zYnFiB5IonV9R4=; b=ZPPa0C0aUl2YsTOMEmCxixeqeA
        AWpQbKdrF/xvgjzQ+8tx1cMnnTqG2ifwZHpRyiWpp7VcxtHepPNTze3lhfhN2nNp6dhCTdjQn68fV
        3M8H4pGqYxv77IZ3MolD8ce/ZTdLuzJGQ+kU7x2WE8bNZe8rROnAT9qYVSh3MlDW/13Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkQFg-009dNo-K7; Thu, 06 Apr 2023 16:06:12 +0200
Date:   Thu, 6 Apr 2023 16:06:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        system@metrotek.ru
Subject: Re: [PATCH net v2 2/2] net: sfp: avoid EEPROM read of absent SFP
 module
Message-ID: <db9a4f80-2ab1-48ba-84fa-322f9a5da5ec@lunn.ch>
References: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
 <20230406130833.32160-3-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406130833.32160-3-i.bornyakov@metrotek.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:08:33PM +0300, Ivan Bornyakov wrote:
> If SFP module is not present, it is sensible to fail sfp_module_eeprom()
> and sfp_module_eeprom_by_page() early to avoid excessive I2C transfers
> which are garanteed to fail.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
