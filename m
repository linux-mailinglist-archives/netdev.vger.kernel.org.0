Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13582E1D70
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgLWOcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:32:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:9399 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLWOcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 09:32:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608733962; x=1640269962;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mCXL6f9tv64JDm7NFojUga1H6cDJs67q/mMzoMR+F6o=;
  b=j5CXUGTzsHG+ZZZwF0FKf6ChKJABmVy9Th4TfEW1F0HurEPspl7t01b5
   STtRpoQprP8MKkct3uCOG0q21Kqvn2xFNPwfyQwgRxaaMyc8i00M//Qi5
   2p/mAqgUujNJn4y33Xmb8Q1NS8K/jRG0NjXpXGxXoiv//ueVbE6zWl7b2
   7TrULt+6GLXXx3cVvLgS757nOD/CF8Jue2HnfKddoZ7LULkaW5EvAFlkj
   5Z40KT6NqgWf8vsn9/AM33mQlL1jdT1X8rrf60jfldp2GRAlGNgl9So0n
   qvSaeHPvhgBIyw2s1DHnZz/jInYEnXr96YQWolLrltSrzgKBBPQQRK0dm
   g==;
IronPort-SDR: XCNArEeyOBPN8MtiaCVgnuE8FzgmXjXzIk+Nw5p7b7ARTv2oGMHdjg0r1nMc1L7FVBYsPMaHDL
 2kJGCJjInutd3mgrv1HCOhEdNFqhZBGtsP4oquGt7nPekeM9HfKwqOKHYz2jQWxDf5ofWfT3kn
 rQJdP5JpWHdvRneFEkxNujRqdNRtpZg2TWPUjvHTFDS7C9IC1qdl2hw5PiKyDJ+84Epm6QNP4T
 Fs8fmtTP2XKnU25lqZgD+df7mlkfa1+UGOzKHCJNXVi89QQ1TWgXq/aEcH7d0P2H7D36VQyKS5
 BXg=
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="100844053"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2020 07:31:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Dec 2020 07:31:26 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 23 Dec 2020 07:31:25 -0700
Date:   Wed, 23 Dec 2020 15:31:24 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v2 8/8] arm64: dts: sparx5: Add the Sparx5 switch node
Message-ID: <20201223143124.tr2vejqgpf2qsot2@mchp-dev-shegelun>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-9-steen.hegelund@microchip.com>
 <20201219202448.GE3026679@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201219202448.GE3026679@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.12.2020 21:24, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> +             port13: port@13 {
>> +                     reg = <13>;
>> +                     /* Example: CU SFP, 1G speed */
>> +                     max-speed = <10000>;
>
>One too many 0's for 1G.

Ah, but this is allocation for the port, not the speed.  This just
used by the calendar module to allocate slots on the taxis as requested.
So I would say it is OK to overallocate in this case (but you could
argue it does not make much sense).

>
>> +             /* 25G SFPs */
>> +             port56: port@56 {
>> +                     reg = <56>;
>> +                     max-speed = <10000>;
>
>Why limit a 25G SFP to 10G?

In the PCB134 case it is to keep the total allocation below 200Gbits
((12+8)*10G).  There is a port mux mode that provides 8*25G on the 25G
SerDes'es, but that would be a different DT.

The Datasheet shows which port mux combinations are possible, and not
all combinations of SerDes, Speed and interface are allowed.

The PCB134 was designed to showcase this "many 10G ports" mode, so that
is why we have the current DT.

>
>    Andrew

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
