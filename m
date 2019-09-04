Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00344A89A8
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbfIDPog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:44:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbfIDPog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HRq00sfzAjkvsI+Qq7LB8E73cPJpt/v0dDqPy1RbU2M=; b=AjAaW+5b5783pgnbpP0o00ekYj
        eiplbNbZqXkWckFIJH9RqllDChYuCUIJrDwqFzNPXWKnxB7o12jIOjsBfLpTvAggUEmX+ire0oolC
        tqA4JO4F2XUOSHFEDmxDPuFG/6UukrwbU3Qu7G3gf9DX7CncIZ3DGk1pM3tTaqrHidJ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i5XSU-0003iN-0C; Wed, 04 Sep 2019 17:44:34 +0200
Date:   Wed, 4 Sep 2019 17:44:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     HOLTZ Matthieu <matthieu.holtz@hagergroup.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "matthieu.holtz@gmail.com" <matthieu.holtz@gmail.com>
Subject: Re: KSZ8863 ethernet PHY support question
Message-ID: <20190904154433.GC9068@lunn.ch>
References: <deba2802f6914ac3ba3245de0bfd2c1a@hagergroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <deba2802f6914ac3ba3245de0bfd2c1a@hagergroup.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 01:59:18PM +0000, HOLTZ Matthieu wrote:
> Hello,
> 
> I’d like to use a switch phy KSZ8863 with an NXP i.mx8mm MPU (new motherboard dev) and a kernel 4.14.x but I am a bit lost regarding the driver support.
> 
> Is the Phy supported by the driver under linux/drivers/net/phy/micrel.c and what about the switch configuration, is it implemented in the DSA subsystem ?

Hi Matthieu

There was a set of RFC patches for the switch posted a while ago:

https://www.spinics.net/lists/netdev/msg569654.html

You might want to talk to the author and help get them merged.

    Andrew
