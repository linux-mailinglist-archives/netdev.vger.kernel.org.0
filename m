Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114B61ED623
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgFCSbV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 14:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 14:31:21 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12563C08C5C0;
        Wed,  3 Jun 2020 11:31:21 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jgYAM-0005ZE-ML; Wed, 03 Jun 2020 20:31:06 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support / debugging
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <20200603180615.GB971209@lunn.ch>
Date:   Wed, 3 Jun 2020 20:31:06 +0200
Cc:     David Miller <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C69EECC3-5701-46FF-84E4-4F0AFDB52809@berg-solutions.de>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
 <20200601.115136.1314501977250032604.davem@davemloft.net>
 <D784BC1B-D14C-4FE4-8FD8-76BEBE60A39D@berg-solutions.de>
 <20200603155927.GC869823@lunn.ch>
 <42337EA1-C7D1-46C6-815F-C619B27A4E77@berg-solutions.de>
 <20200603180615.GB971209@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1591209081;b92e8198;
X-HE-SMSGID: 1jgYAM-0005ZE-ML
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I’m testing with Microchip Lan7430, which is an integrated circuit that contains MAC and PHY in one package. With the release kernel the hardware works fine, so the overall configuration is ok (jumpers).

I will verify wether the effective RGMII and delay settings, you mention, are equal in both driver versions.

>> Ok, let's proceed :) 
> What PHY is being used?
> Is it using RGMII?
> 
> If it looks like the PHY and the MAC are happy, just that frames are
> not being transferred between them, it could be RGMII delays.
> 
>    Andrew
> 

