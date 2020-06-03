Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DBD1ED30D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgFCPLF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Jun 2020 11:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgFCPLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 11:11:05 -0400
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44B6C08C5C0;
        Wed,  3 Jun 2020 08:11:04 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=roelofs-mbp.fritz.box); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jgV2Y-0000Ec-QM; Wed, 03 Jun 2020 17:10:50 +0200
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support / Options for
 proceeding ?
From:   Roelof Berg <rberg@berg-solutions.de>
In-Reply-To: <08FC216E-BBCA-40E6-8251-FA1EB3EF9F99@berg-solutions.de>
Date:   Wed, 3 Jun 2020 17:10:49 +0200
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <95EAD2D0-1996-49FF-9C03-DC5AD4000E71@berg-solutions.de>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
 <08FC216E-BBCA-40E6-8251-FA1EB3EF9F99@berg-solutions.de>
To:     "rberg@berg-solutions.de" <rberg@berg-solutions.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1591197064;d2a39fce;
X-HE-SMSGID: 1jgV2Y-0000Ec-QM
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

we need to decide how to continue with the lan743x patch for fixed phy support. Thanks everyone for the valuable time.

Summary of the development steps so far:
The patch initially had low influence on the installed base, but lacked some compatibility to Linux best practices. During the review process we found improvement potential. We decided to make the patch more similar to the majority of Linux drivers, by avoiding a special autodetection silicon feature that is unique. However, now, with more test hardware available, this road becomes more difficult than we initially assumed.

Would it be ok to split the topics into two distinct patches ?

Topic a: New feature: Add fixed link and RGMII support in a minimal invasive way. (Including fixing a reboot-issue that the last patch fixed.)

Topic b: Refactor old driver: Understand, and if possible remove, the silicon’s Mac-Phy auto-negotiation feature.

Maybe splitting distinct features into distinct patches is the most defensive approach, now that device testing disconfirmed our promising approach ?

Thanks everyone for cooperating on this feature,
Roelof


> Roelof Berg <rberg@berg-solutions.de>:
> 
> Testing note [...]
> - Different from prior approaches it affects the installed base. So we need some more testing (with hardware I don’t have available yet) and I’m in contact with Microchip already.
> 
> Thanks for guiding us to a proper solution,
> Roelof Berg
> 
>> . The automatic speed and duplex detection of the lan743x silicon
>> between mac and phy is disabled.

