Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5560E5FA157
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 17:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJJPor convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Oct 2022 11:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJJPop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 11:44:45 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61401274B;
        Mon, 10 Oct 2022 08:44:42 -0700 (PDT)
X-QQ-mid: bizesmtpipv601t1665416647ta8q
Received: from SJRobe ( [255.42.121.1])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 10 Oct 2022 23:44:06 +0800 (CST)
X-QQ-SSF: 01100000002000G0Z000B00A0000000
X-QQ-FEAT: D6RqbDSxuq4iBYyaYVDZrXYqb+RP52SdFAuHQ/mOMUEnz1R6tS6Xji8Mojn7c
        A/ErJX+BhX2Ke8jt3huafuXPmwcFpKortZ58JqYXFFiCH84q0fhM2XT6uoheKIV2FxR/mqS
        3RJ1nTfpz5YXwWDf4NE3ATtKIuKxm5j/qgccKz0V0Yi2MvOG4vAnl+RlSZBX12z9o27xrZ+
        +BKileqxTCkvhZ7HGAUaV1QSpdVE7/V0tr8WR/6RrOc1yylHMcZ3uqH4v4FMyXjbaUvoOeH
        mW4q23Q+j5rkTAJN3Bv6oMuKlSlsn1wu1Pu3S3AKdup84Rbwg+YLCi3j8y6f4ReviX34IoF
        64G512UvwVohWN5yjsvxx9dm5KdN1NL2fqY5XBV7zKkwDzp81mqptMwuxcQ0meGrDNVPb8O
X-QQ-GoodBg: 0
From:   "Soha Jin" <soha@lohu.info>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Heiner Kallweit'" <hkallweit1@gmail.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Eric Dumazet'" <edumazet@google.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Russell King'" <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221009162006.1289-1-soha@lohu.info> <Y0Q0P4MlTXmzkJSG@lunn.ch>
In-Reply-To: <Y0Q0P4MlTXmzkJSG@lunn.ch>
Subject: RE: [PATCH] net: mdiobus: add fwnode_phy_is_fixed_link()
Date:   Mon, 10 Oct 2022 23:44:06 +0800
Message-ID: <08616A924F416E8E+327e01d8dcbf$2237dbe0$66a793a0$@lohu.info>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFoC3KVUqWpiwX+Soe/1lfFTeyGBQNmLtDwrs40JzA=
Content-Language: fr
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpipv:lohu.info:qybglogicsvr:qybglogicsvr3
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,RCVD_ILLEGAL_IP,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, October 10, 2022 11:03 PM
> 
> On Mon, Oct 10, 2022 at 12:20:06AM +0800, Soha Jin wrote:
> > A helper function to check if PHY is fixed link with fwnode properties.
> > This is similar to of_phy_is_fixed_link.
> 
> You need to include a user of this new function.

Greg already notified me about this. I was thinking this patch and my
driver patches are on different trees, so I split the patches into
different parts. I will include this patch in my driver patch's v2 later
and ask you to review then. Sorry for the mistake.

> Also, not that ACPI only defines the 'new binding' for fixed-link.  If this is
> being called on a device which is ACPI underneath, it should only return true
> for the 'new binding', not the old binding.

Thanks for the information, I will correct this.

Regards,
Soha

