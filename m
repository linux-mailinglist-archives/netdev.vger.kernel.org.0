Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6650ECA3
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfD2WQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:16:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729252AbfD2WQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XHl2trHVQzseYbqNaiploD41q4v9G1rFkpnAVFc7Eos=; b=xtlJfvqG07XeCgvfedjiazFqGG
        buw1Uwm+/OQ7FaMaaX7ri64lZPiX2pWYMTLxBx4dQ1BKgZ6nnqD1Vc/GRfVoFqCvjGBmgIyYWPIAv
        Q7uyG1eMyZyvbZ4FjeFv6owu+vH53Hu22qolut8W8JcSeqIcKmv5V/06hSnw2dOsAgdE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEZ6-0007Zs-Ec; Tue, 30 Apr 2019 00:16:00 +0200
Date:   Tue, 30 Apr 2019 00:16:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: Re: [PATCH v4 net-next 08/15] net: aquantia: use macros for better
 visibility
Message-ID: <20190429221600.GQ12333@lunn.ch>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
 <6ee59f31c13b6cdc9b1a3b8fc1b258ad3b8e7848.1556531633.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ee59f31c13b6cdc9b1a3b8fc1b258ad3b8e7848.1556531633.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 10:04:52AM +0000, Igor Russkikh wrote:
> Improve for better readability
> 
> Signed-off-by: Nikita Danilov <ndanilov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Hi Igor

https://www.spinics.net/lists/netdev/msg567238.html

Please remember to add any reviewed-by you get.

       Andrew
