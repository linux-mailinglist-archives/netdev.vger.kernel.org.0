Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FD74F666
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 17:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfFVPFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 11:05:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFVPFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 11:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=up6pfbdJDDcaB6pbaK4zpv7dmRIaJEXOS6MX2yezjAI=; b=3abeux1IQmsZCgw5ieJeQHU1uh
        WIHjkmVBHbX2/PHm64gjE9a6y0HwMYn3BLxXXYBhHG7bsGWMtRP3PqyJ/7xaxaggOpU6cwoGhgSAT
        6vsLpO13Zrn64UvokliwGep/UqAv1dPfvST7zqAbyo2nG9e9RhaYSzEzOhzRS/Ufg9as=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hehZq-0002a9-5u; Sat, 22 Jun 2019 17:05:14 +0200
Date:   Sat, 22 Jun 2019 17:05:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        jakub.kicinski@netronome.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/7] net: aquantia: replace internal driver
 version code with uts
Message-ID: <20190622150514.GB8497@lunn.ch>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
 <f5f346ff5f727f1ccf0f889e358261a792397210.1561210852.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5f346ff5f727f1ccf0f889e358261a792397210.1561210852.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 01:45:12PM +0000, Igor Russkikh wrote:
> As it was discussed some time previously, driver is better to
> report kernel version string, as it in a best way identifies
> the codebase.
> 
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Nice.

Devlink has just gained something similar to ethtool -i. Maybe we
should get the devlink core to also report the kernel version?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
