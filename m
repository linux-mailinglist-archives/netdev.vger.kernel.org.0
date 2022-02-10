Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4E04B0F26
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241054AbiBJNs2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 08:48:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiBJNs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:48:27 -0500
X-Greylist: delayed 76448 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 05:48:27 PST
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B747191;
        Thu, 10 Feb 2022 05:48:27 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 6107F15360;
        Thu, 10 Feb 2022 13:48:25 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 4A572219C0A; Thu, 10 Feb 2022 13:48:25 +0000 (GMT)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: fix reset on probe
References: <20220209145454.19749-1-mans@mansr.com>
        <20220209183623.54369689@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 10 Feb 2022 13:48:25 +0000
In-Reply-To: <20220209183623.54369689@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 9 Feb 2022 18:36:23 -0800")
Message-ID: <yw1xsfsq4yty.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed,  9 Feb 2022 14:54:54 +0000 Mans Rullgard wrote:
>> The reset input to the LAN9303 chip is active low, and devicetree
>> gpio handles reflect this.  Therefore, the gpio should be requested
>> with an initial state of high in order for the reset signal to be
>> asserted.  Other uses of the gpio already use the correct polarity.
>> 
>> Signed-off-by: Mans Rullgard <mans@mansr.com>
>
> Pending Andrew's review, this is the correct fixes tag, right?
>
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")

Yes, the error has been there since the driver was first added.

-- 
Måns Rullgård
