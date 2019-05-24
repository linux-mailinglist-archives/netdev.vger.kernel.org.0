Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A109291A3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 09:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389056AbfEXHYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 03:24:38 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:35638 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388982AbfEXHYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 03:24:38 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 34DD1C012B;
        Fri, 24 May 2019 07:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558682663; bh=ep8YghOnVJandEp4n5gYS1G1JYgCzpooQvEBO3Vcyg0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=SsCvf8pxuGvHXs1VR6DWH6pTycRIpwI2RqDuKVvtSsMw8jAfTgfZ8fZ0Guz5IBu32
         n5M38/cW+cIIGylsObwiJ/yoA/leMU8gHYT2Hb9EQu5v6Jt9Gy9geby3GIUyPqHWOM
         SzHOyH+VxzjujRLF65TzIH9u0NYYVJGvGpsdPPW4HXJ1vDMijC6oq0SAHDqEa36ccV
         RqicsLey/WoPc3Kvycc0KRqn6B8/Wl43Ps8YNR4oQaLqsvGXepL7FG1+NigRR1iJgr
         bm3g+/K+5zJoYJWsk1gfkiIwaDRf7yU59dThfXSm4zU2gVuPkAfo5wCAnyqQdZy47a
         C3+QWhcsV8IOg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 91544A00FF;
        Fri, 24 May 2019 07:24:29 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 24 May 2019 00:24:29 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Fri,
 24 May 2019 09:24:27 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "clabbe.montjoie@gmail.com" <clabbe.montjoie@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [PATCH net-next 00/18] net: stmmac: Improvements and Selftests
Thread-Topic: [PATCH net-next 00/18] net: stmmac: Improvements and Selftests
Thread-Index: AQHVETphrQGM1vIbeE+0UH3fT3CjTKZ4v88AgAACcwCAAR5pwA==
Date:   Fri, 24 May 2019 07:24:26 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B92CB20@DE02WEMBXB.internal.synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
        <20190523.090928.974790678055823460.davem@davemloft.net>
 <20190523.091814.750814773629903183.davem@davemloft.net>
In-Reply-To: <20190523.091814.750814773629903183.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, May 23, 2019 at 17:18:14

> I'm reverting, this doesn't even build.

Damn, sorry! I failed to notice that dev_set_rx_mode() is not exported :/

I will fix and resend!

Thanks,
Jose Miguel Abreu
