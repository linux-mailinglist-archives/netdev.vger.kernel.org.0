Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0361B683
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfEMMz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:55:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbfEMMz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:55:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=25Uwi8H60pwR1izqxasvTT+l1DgmsqYph9SZk1uXsws=; b=mhVGgKf6LMTY3GRpQFIQrTTQPi
        Y1jNUhq75vqkCJ0pQigCy6TXXxcpx7EEl6AUfOq/Zb7IDBIXltz178vZAUZcZTQ57DkrmHcaGBGkU
        yHRMCHibWd4aWhn89mX9iTOB8aiCFZ48ar/tk0or4BlvAPJorp1eycoihgaXXhjxbEXM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQAUC-0008IB-I9; Mon, 13 May 2019 14:55:20 +0200
Date:   Mon, 13 May 2019 14:55:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of_net: Fix missing of_find_device_by_node ref count drop
Message-ID: <20190513125520.GD28969@lunn.ch>
References: <1557740500-2479-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557740500-2479-1-git-send-email-ynezz@true.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 11:41:39AM +0200, Petr Štetiar wrote:
> of_find_device_by_node takes a reference to the embedded struct device
> which needs to be dropped after use.
> 
> Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Petr Štetiar <ynezz@true.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
