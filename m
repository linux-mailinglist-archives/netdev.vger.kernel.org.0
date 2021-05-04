Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628473730FD
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhEDTq7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 May 2021 15:46:59 -0400
Received: from mx.krause.de ([88.79.216.98]:48356 "EHLO mx.krause.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232409AbhEDTq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 15:46:58 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 15:46:58 EDT
Received: from [172.20.10.126] (port=40758 helo=mail.horstmanngroup.de)
        by mx.krause.de with esmtps (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <t.schluessler@krause.de>)
        id 1le0uO-0002xz-2S; Tue, 04 May 2021 21:40:40 +0200
Received: from HG-SRV-053.HG.local (172.20.10.125) by HG-SRV-054.HG.local
 (172.20.10.126) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.1.1979.3; Tue, 4 May 2021
 21:40:40 +0200
Received: from HG-SRV-053.HG.local ([::1]) by HG-SRV-053.HG.local ([::1]) with
 mapi id 15.00.1367.000; Tue, 4 May 2021 21:40:40 +0200
X-CTCH-RefID: str=0001.0A782F1C.6091A338.0080,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
From:   =?iso-8859-1?Q?Schl=FC=DFler=2C_Timo?= <t.schluessler@krause.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: mcp251x: Fix resume from sleep before interface was
 brought up
Thread-Topic: [PATCH] can: mcp251x: Fix resume from sleep before interface was
 brought up
Thread-Index: AQHXQP7OdPP9Ain59kOZYaf6kWSIbarTiL4AgAAv/ho=
Date:   Tue, 4 May 2021 19:40:39 +0000
Message-ID: <DE1325CF-9C93-4C97-9267-F4484E151F28@krause.de>
References: <bd466d82-db03-38b1-0a13-86aa124680ea@kontron.de>,<20210504184854.urgotqioxtjwbqqs@pengutronix.de>
In-Reply-To: <20210504184854.urgotqioxtjwbqqs@pengutronix.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 04.05.2021 18:01:48, Schrempf Frieder wrote:
>> Fixes: 8ce8c0abcba3 ("can: mcp251x: only reset hardware as required")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Thanks for finding and fixing this and sorry for introducing the bug.

Regards
Timo
