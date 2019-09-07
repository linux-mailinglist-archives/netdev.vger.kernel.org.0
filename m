Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A9AC934
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395263AbfIGUdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:33:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbfIGUdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 16:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j8EtJ3keCYwx0QhMZF+B9RmxbioGnM5yXTKYaXgtJGg=; b=aMlHkLo1vrOdtQenc3R1pdQo5n
        hEV+zJ5SE1w5BHHe1WJWg4HSszJlH7uP6ZS/KlE1kxZEh64esRmPEYdAu6xNO3e542p6Kya7JoBTN
        NM6IFayRMQM/BBqN0CYPJYANjKnTKTh2urSclmMSCNjwoO7IEUaZE1KtHBw/JEm6vf2U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6hOM-0005hp-GH; Sat, 07 Sep 2019 22:33:06 +0200
Date:   Sat, 7 Sep 2019 22:33:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 1/3] net: dsa: mv88e6xxx: complete ATU state
 definitions
Message-ID: <20190907203306.GB18741@lunn.ch>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
 <20190907200049.25273-2-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907200049.25273-2-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 07, 2019 at 04:00:47PM -0400, Vivien Didelot wrote:
> Marvell has different values for the state of a MAC address,
> depending on its multicast bit. This patch completes the definitions
> for these states.
> 
> At the same time, use 0 which is intuitive enough and simplifies the
> code a bit, instead of the UC or MC unused value.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
