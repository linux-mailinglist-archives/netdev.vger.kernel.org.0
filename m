Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B72E1A46
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 10:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgLWJEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 04:04:42 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:18107 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgLWJEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 04:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608714281; x=1640250281;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=OFvTDDSfgKeOYrK3s9uvKjz1XvryNuTpXVGl8F1Tlyk=;
  b=qifo2ZFoJCkMuw0bDcRJ4za9x/g4O0I4p4V8lll5CTn1CvDgQoK2kXym
   4YAgdrJoPYzIihrqW5+53pxU0TqIMHnbFWVJelBj1p547ddccGqCzzAMG
   8Fvk5o1EDpC5UvV1uMeiEBbBUjz5QB8Zyxj1QK7Vev3vzOS3Gz79jy0Ih
   J45mD+4akhIEhbmvBhk7LpfhyrN2QmEazNlppoIjEunmSriOKiyL/PoH2
   NkxkMadt7AgZBXLXACEjP3ZpTfnc46S3tHBN+hiK7/FubysaIg7LZyQTU
   J7Ato2HbYdchhUG5cnZecVhTZtnYeR9EZTBhsXajpYD/U4TV43WP0ik/A
   Q==;
IronPort-SDR: 6y6X9asZAaS3vrtRQxB+CiaEp5geuGyLuMyuPfquiP5Oo4EIB/itzBTUI+gW7P6S9oaoHiUQ2x
 0QPPz7Yo5wQOx/V1Jpj4RIZ2p8T5lJDD5Nu6z68vo/t6DJ4vs5TudGUcJq2w+eHcUYxyiP5y6v
 agkzkBlvoJcYFybHIQhQVv6k/HSt0fbBeX4PyXI25CJQ9z+ob3XCWmKC4c3K6x1hledt3g+M/f
 ISInzc0TAiVcRFkSSujESoY6c8EI548t1aZ9Ue2Q6w4fKqoCluTY4EqB2XXKLdLrpq1MKYYOxv
 ltA=
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="103795952"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2020 02:03:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Dec 2020 02:03:25 -0700
Received: from soft-dev10.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 23 Dec 2020 02:03:22 -0700
References: <20201217075134.919699-1-steen.hegelund@microchip.com> <20201217075134.919699-3-steen.hegelund@microchip.com> <20201219191157.GC3026679@lunn.ch> <37309f64bf0bb94e55bc2db4c482c1e3e7f1be6f.camel@microchip.com> <20201222150122.GM3107610@lunn.ch> <20201222165600.GE3819852@piout.net>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Lars Povlsen <lars.povlsen@microchip.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "Lars Povlsen" <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v2 2/8] net: sparx5: add the basic sparx5 driver
In-Reply-To: <20201222165600.GE3819852@piout.net>
Date:   Wed, 23 Dec 2020 10:03:11 +0100
Message-ID: <874kkcq4hc.fsf@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexandre Belloni writes:

> On 22/12/2020 16:01:22+0100, Andrew Lunn wrote:
>> > The problem is that the switch core reset also affects (reset) the
>> > SGPIO controller.
>> >
>> > We tried to put this in the reset driver, but it was rejected. If the
>> > reset is done at probe time, the SGPIO driver may already have
>> > initialized state.
>> >
>> > The switch core reset will then reset all SGPIO registers.
>>
>> Ah, O.K. Dumb question. Why is the SGPIO driver a separate driver? It
>> sounds like it should be embedded inside this driver if it is sharing
>> hardware.
>>
>> Another option would be to look at the reset subsystem, and have this
>> driver export a reset controller, which the SGPIO driver can bind to.
>> Given that the GPIO driver has been merged, if this will work, it is
>> probably a better solution.
>>
>
> That was my suggestion. Then you can ensure from the reset controller
> driver that this is done exactly once, either from the sgpio driver or
> from the switchdev driver. IIRC, the sgpio from the other SoCs are not
> affected by the reset.

I will take a look to see if we can change the implementation to use a
reset controller.

---Lars

--
Lars Povlsen,
Microchip
