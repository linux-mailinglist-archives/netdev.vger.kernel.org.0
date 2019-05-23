Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44E27A0F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 12:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfEWKLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 06:11:47 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:52220 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726429AbfEWKLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 06:11:46 -0400
Received: from mailhost.synopsys.com (dc2-mailhost1.synopsys.com [10.12.135.161])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3A084C019A;
        Thu, 23 May 2019 10:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558606292; bh=ZEbZqunZ+rIwViZDW6o7vFr9VUdu0pDj0hPGxzIu6ek=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cBUJrPawSJA6R+HhDp/hN/3hxkJdWLBnHIrnV6/L4PpYSXb+SRaYhDxUzgq6nHulc
         k/WbOxllU3Dxi482kElOyiEjTjrBVnIcMZG56vzkxqxRiB6o18bW6y3x+0K+eYRm4W
         PJqZGaeLrTLn9a3Dhb/1EpC3jT5dTmXy/l3upXuxJrezlwHEM2dUvLIsWSeYlm6AzK
         ye+r51OCFeMIALLzS58nZWsUHFoJeZSZJ8U9LXv84RpWfIhqoSTspL4OKXgRLoFj+v
         JRbInyMmArtFabkdmNFACrIHy7TeK5muPFxZBILN27ZNYQ330Pxel6nTNA/GOUmtpU
         Oy9oIkMw7uyHg==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C811FA009E;
        Thu, 23 May 2019 10:11:42 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 23 May 2019 03:11:42 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 23 May 2019 12:11:40 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Chen-Yu Tsai" <wens@csie.org>
CC:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?iso-8859-1?Q?Antoine_T=E9nart?= <antoine.tenart@bootlin.com>
Subject: RE: [PATCH 6/8] dt-bindings: net: stmmac: Convert the binding to a
 schemas
Thread-Topic: [PATCH 6/8] dt-bindings: net: stmmac: Convert the binding to a
 schemas
Thread-Index: AQHVEU4TH/U8rGF20keiHF2VDmX4vKZ4fKug
Date:   Thu, 23 May 2019 10:11:39 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B92B864@DE02WEMBXB.internal.synopsys.com>
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <ba1a5d8ad34a8c9ab99f504c04fbe65bde42081b.1558605170.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <ba1a5d8ad34a8c9ab99f504c04fbe65bde42081b.1558605170.git-series.maxime.ripard@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>
Date: Thu, May 23, 2019 at 10:56:49

> Switch the STMMAC / Synopsys DesignWare MAC controller binding to a YAML
> schema to enable the DT validation.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

How exactly can I see the final results of this ? Do you have any link ?=20
(I'm no expert in YAML at all).

Thanks,
Jose Miguel Abreu
