Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAAF4B0A6D
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbiBJKSc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 05:18:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiBJKSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:18:31 -0500
X-Greylist: delayed 5020 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 02:18:32 PST
Received: from smtpout-03.clustermail.de (smtpout-03.clustermail.de [IPv6:2a02:708:0:31::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F039B88
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:18:32 -0800 (PST)
Received: from [10.0.0.6] (helo=frontend.clustermail.de)
        by smtpout-03.clustermail.de with esmtp (Exim 4.94.2)
        (envelope-from <Rafael.Richter@gin.de>)
        id 1nI6Vv-0000QR-Q1; Thu, 10 Feb 2022 11:18:24 +0100
Received: from [217.6.33.237] (helo=Win2012-02.gin-domain.local)
        by frontend.clustermail.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
        (Exim 4.94.2)
        (envelope-from <Rafael.Richter@gin.de>)
        id 1nI6Vv-00083z-No; Thu, 10 Feb 2022 11:17:23 +0100
Received: from Win2012-02.gin-domain.local (10.160.128.12) by
 Win2012-02.gin-domain.local (10.160.128.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 10 Feb 2022 11:17:22 +0100
Received: from Win2012-02.gin-domain.local ([fe80::b531:214c:87e0:8d4a]) by
 Win2012-02.gin-domain.local ([fe80::b531:214c:87e0:8d4a%18]) with mapi id
 15.00.1497.026; Thu, 10 Feb 2022 11:17:22 +0100
From:   "Richter, Rafael" <Rafael.Richter@gin.de>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Robert-ionut Alexa <robert-ionut.alexa@nxp.com>,
        "Klauer, Daniel" <Daniel.Klauer@gin.de>
Subject: AW: [PATCH net] dpaa2-eth: unregister the netdev before disconnecting
 from the PHY
Thread-Topic: [PATCH net] dpaa2-eth: unregister the netdev before
 disconnecting from the PHY
Thread-Index: AQHYHc3irxHwc5wFI0WE9O9tcl0aJqyLi9TygADwJVr///w+gIAAF3pd
Date:   Thu, 10 Feb 2022 10:17:22 +0000
Message-ID: <1644488242397.7248@gin.de>
References: <20220209155743.3167775-1-ioana.ciornei@nxp.com>,<20220210094052.64o52akouoh33m4j@skbuf>
In-Reply-To: <20220210094052.64o52akouoh33m4j@skbuf>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.176.8.30]
x-esetresult: clean, is OK
x-esetid: 37303A29342AAB5361706A
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Note: SpamAssassin invocation failed
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you Ioana for this patch.
Its usage prevents that the kernel panics (v5.17-rc2) on shutdown on our board (LX2160A + mv88e6xxx) if any dpaa-interface (sgmii-mac) has been activated before.

Tested-by: Rafael Richter <rafael.richter@gin.de>
________________________________________
Von: Ioana Ciornei <ioana.ciornei@nxp.com>
Gesendet: Donnerstag, 10. Februar 2022 10:40
An: Richter, Rafael
Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org; Klauer, Daniel; Robert-ionut Alexa
Betreff: Re: [PATCH net] dpaa2-eth: unregister the netdev before disconnecting from the PHY

On Thu, Feb 10, 2022 at 08:54:34AM +0000, Richter, Rafael wrote:
> Hi Ioana!
>
> please ignore the previous mail. Everything works now fine. It was a local issue with my setup.
>
> BR,
>


Hi Rafael,

Great to hear that the patch fixes the issue.
I didn't respond until now because I was trying to get it to reproduce
on my end even with the patch - to no avail.

Anyhow, would you mind sending a Tested-by tag?

Ioana

