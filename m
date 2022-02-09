Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E5F4AF5CA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbiBIPxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbiBIPxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:53:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CF4C05CB88
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g8etlpk4yicT3BviFnNQncoMQf/bcu/Qz/BT/x7UOwE=; b=bEg2eMvKd8rrQgkYybFNeeOGmF
        5pQoBc6/9rob+kds9EVfGJ1uOnZ2CBZKmW9wK/zwn7LMe69WkGXDCbVuXQEB8hK38uSCWlQyIGRTP
        wU99saFN49ZPd8V8r8cxWk5mKewoO0k+VBq5H8Id00AYRS8eSUhf+d4ATpj2+ATrYtjc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHpHm-005932-ID; Wed, 09 Feb 2022 16:53:38 +0100
Date:   Wed, 9 Feb 2022 16:53:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: mediatek: remove PHY mode check on MT7531
Message-ID: <YgPjgvlVkykx1e1G@lunn.ch>
References: <20220209143948.445823-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209143948.445823-1-dqfext@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 10:39:47PM +0800, DENG Qingfang wrote:
> The function mt7531_phy_mode_supported in the DSA driver set supported
> mode to PHY_INTERFACE_MODE_GMII instead of PHY_INTERFACE_MODE_INTERNAL
> for the internal PHY, so this check breaks the PHY initialization:

Is the PHY actually internal? If so PHY_INTERFACE_MODE_INTERNAL would
be correct.

Are you fixing the wrong thing here?

    Andrew
