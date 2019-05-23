Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B638A27D09
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbfEWMnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:43:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44907 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbfEWMnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6h1D4Ud/7r70N6KTznuJt38cxPCFT7J0mt36Y7aCy1M=; b=wJO2sGD0T6Xqve2m0J4I9ZDHZF
        090A/YSc9PS+ej6Q1E4e05jB1eID9pC+RksuSLRBctWBk856DZxRbrM0lh5pSSX3XyDBGJ/rzp3au
        kg8JwChYSPQo8M6O6w0aoO0t9aYVgHHW5ot5nZzGFDr9YIcLPn9bH0hhMtTgHzbbIY3c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTn4W-0004Bk-Cy; Thu, 23 May 2019 14:43:48 +0200
Date:   Thu, 23 May 2019 14:43:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA setup IMX6ULL and Marvell 88E6390 with 2 Ethernet Phys - CPU
 Port is not working
Message-ID: <20190523124348.GB15531@lunn.ch>
References: <944bfcc1-b118-3b4a-9bd7-53e1ca85be0a@eks-engel.de>
 <20190523050909.B87FB134148@control02-haj2.antispameurope.com>
 <25a1f661-277b-e4b3-ffee-9092af6abf5d@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25a1f661-277b-e4b3-ffee-9092af6abf5d@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> thanks for your reply. You're right, both PHYs are 10/100.
> 
> I already added a fixed-link like this:
> 
> 			port@0 {
> 				reg = <0>;
> 				label = "cpu";
> 				ethernet = <&fec1>;
> 				phy-mode = "rmii";
> 				phy-handle = <&switch0phy0>;
>                                 fixed-link {
>                                         speed = <100>;
>                                         full-duplex;
>                                 };
> 			};
> 
> I hope you mean that with fixed-phy? But this doesn't changed anything.

You probably have multiple issues, and it is not going to work until
you have them all solved.

You can get access to the registers etc, using patches from:

https://github.com/vivien/linux.git dsa/debugfs

I've only seen the external MDIO bus on the 6390 used for C45 PHYs. So
there is a chance the driver code for C22 is broken?

      Andrew

