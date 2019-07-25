Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423A074ED0
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfGYNIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:08:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbfGYNIM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 09:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Um9HOmZgnXVVQVKGE6OESVzPLL37//DOWNy4+nthSFo=; b=WQ3X6wStXGAfOB1hhX7gCcT2xJ
        B5zI5SsXb9PX0pepOt1V2YcDWwPD23vS/6D3Qsy7yivWWUVvmhfK0Dbpka5u9kWZtDUmIsph3SDb+
        rTYakGPXpEZwjxSzn+b2JmkpX4XiZ62nrl6PUwxDrlPxdVlHe2YDzJGkMVfu6BM8IrW0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqdTb-0005nm-Q4; Thu, 25 Jul 2019 15:08:07 +0200
Date:   Thu, 25 Jul 2019 15:08:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     liuyonglong <liuyonglong@huawei.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        shiju.jose@huawei.com
Subject: Re: [PATCH net] net: hns: fix LED configuration for marvell phy
Message-ID: <20190725130807.GB21952@lunn.ch>
References: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
 <20190722.181906.2225538844348045066.davem@davemloft.net>
 <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
 <20190725042829.GB14276@lunn.ch>
 <8017d9ff-2991-f94f-e611-4d1bac12e93b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8017d9ff-2991-f94f-e611-4d1bac12e93b@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You are discussing about the DT configuration, is Matthias Kaehlcke's work
> also provide a generic way to configure PHY LEDS using ACPI?

In general, you should be able to use the same properties in ACPI as
DT. If the device_property_read_X() API is used, it will try both ACPI
and OF to get the property.

    Andrew
