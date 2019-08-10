Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF19288C6D
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfHJRRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 13:17:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50156 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfHJRRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 13:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sQ2p3KGTVc+l5cuwMYNqgdmg6J4/Q0KCcyvFiZwZyX4=; b=wdQpOqT8Y/kAfa+T9djLrTxEPK
        0tbKu9giE9sPhtU7/+I3Dsap08ManRWznUcrDIthj3UCTJIkaeETP/uHfooVCU0oGLp9tw/JhjB+8
        UHFrG++jPQQbXYInowr+xP19/ueCEdtIl8nSMKDXomVCffm5O90O69diXizBZqAY5c5s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwUzC-0000Ph-8L; Sat, 10 Aug 2019 19:16:58 +0200
Date:   Sat, 10 Aug 2019 19:16:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v5 3/6] net: mscc: describe the PTP register
 range
Message-ID: <20190810171658.GG30120@lunn.ch>
References: <20190807092214.19936-1-antoine.tenart@bootlin.com>
 <20190807092214.19936-4-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807092214.19936-4-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 11:22:11AM +0200, Antoine Tenart wrote:
> This patch adds support for using the PTP register range, and adds a
> description of its registers. This bank is used when configuring PTP.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
