Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6233A44598F
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhKDSYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:24:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234120AbhKDSYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 14:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=t/D3DgX2odV/NvsRqA603EdmnnUXsKTgW/9qz/vLQUk=; b=4SzbOWDLnFLhY8eufyUu2MLMZX
        ilHHvvIV+TgS9dH6CC8JVD+56r/s6hf22J/KVEIzwRz8vqi/T1Zx0w/ypUKXUFEMafycsQe8sNiLC
        QtBPW4KJH3tegwLCzv53ueqf6rsnuKjZPlB2akAsnKyYm6/w566G4T5VCaUJ83Mcq0ig=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mihMg-00Cc2u-Uy; Thu, 04 Nov 2021 19:21:30 +0100
Date:   Thu, 4 Nov 2021 19:21:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYQkqkZOwOhTa+VD@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
 <YYLjaYCQHzqBzN1l@lunn.ch>
 <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
 <YYPZN9hPBJTBzVUl@lunn.ch>
 <c51d2927eedb4f3999b8361a44526a07@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c51d2927eedb4f3999b8361a44526a07@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No, we only develop arm-based SoC, never for x86 or mips.
> We never compile the driver for x86 or mips machine.

You don't, but the Linux community does build for those
architectures. Most people do tree wide refactoring work using
x86. Tree wide cleanups using x86, etc. Any changes like that could
touch your driver. The harder is it to build, the less build testing
it will get, and tree wide changes which break it are less likely to
get noticed.  So you really do want it to compile cleanly for all
architectures. If it does not, it normally actually means you are
doing something wrong, something you need to fix anyway. So please do
build it for x86 and make sure it builds cleanly.

	  Andrew

