Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79ED864074B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiLBM56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiLBM55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:57:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEBC7B542
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VHjELIUlZzi6UTditcMVCH0wG5OJszzf/zoC2vJU6Ks=; b=k+CHk6S9tvp8nG7/AWRFamII1j
        25Cnw9ivRr//aEtCgkd2uQ27SIC2DyQcGA5uuE8nrCDm9J1A/qRaAY1hlbufrWQOZ4Z3hpSZWX2Ai
        EF+45LGvVm9WJRVvTNwXbbncaF+KXmtT/YnUrxzhvb1Sx2SEmeRf2yUk36sMbZtNty7Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p15at-004Asn-84; Fri, 02 Dec 2022 13:56:43 +0100
Date:   Fri, 2 Dec 2022 13:56:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zeng Heng <zengheng4@huawei.com>
Cc:     Yang Yingliang <yangyingliang@huawei.com>, f.fainelli@gmail.com,
        pabeni@redhat.com, kuba@kernel.org, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, liwei391@huawei.com
Subject: Re: [PATCH] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
Message-ID: <Y4n2C1A78YgxZTyG@lunn.ch>
References: <20221201092202.3394119-1-zengheng4@huawei.com>
 <Y4jH1Z8UdA/h+WlE@lunn.ch>
 <d7f2266a-12c0-7369-952b-fbaa787de125@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7f2266a-12c0-7369-952b-fbaa787de125@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No, they don't interact with each other, because they fix different issues
> respectively.

I'm wanted to ensure you know about each others work and that the
fixes don't clash. I could not see a Cc: between you, nor a
reviewed-by: etc to indicate you are working together on this.

The patches can go separately, but maybe you can review v3 of his
patch? Ask him to review yours.

       Andrew
