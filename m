Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13218EC9A
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfD2WNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:13:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbfD2WNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U2pE5xnWvTMyASyFJ+2Wa7Jsi9tuUaDjVV7ixbkc/Bo=; b=u0HA2AwNTvS3GIxw8SxQRwYQKI
        MYP/MmruWjc3wOBf0mxk8gHczPQiLvWHbwqJHh9RnnSYHZr5GubqnWkUmjSZ6u6uKZqxR3urWQh9q
        FDVYv+emB7XBug07Mg/VLBy1XL58IuQrwcI6SADIqW8tMBFVkaNOvO4jwaT5DoN5OTQs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEWN-0007TY-Kb; Tue, 30 Apr 2019 00:13:11 +0200
Date:   Tue, 30 Apr 2019 00:13:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Yana Esina <yana.esina@aquantia.com>
Subject: Re: [PATCH v4 net-next 01/15] net: aquantia: add infrastructure to
 readout chip temperature
Message-ID: <20190429221311.GO12333@lunn.ch>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
 <0a378d58cf39e838372492dd6352ad082873d42d.1556531633.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a378d58cf39e838372492dd6352ad082873d42d.1556531633.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 10:04:35AM +0000, Igor Russkikh wrote:
> From: Yana Esina <yana.esina@aquantia.com>
> 
> Ability to read the chip temperature from memory
> via hwmon interface
> 
> Signed-off-by: Yana Esina <yana.esina@aquantia.com>
> Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
