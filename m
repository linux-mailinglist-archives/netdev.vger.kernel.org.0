Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877491DBB1B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgETRVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:21:05 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40542 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETRVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:21:04 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KHKwHq020773;
        Wed, 20 May 2020 12:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589995258;
        bh=yrKwbAO5uhLlt/mQiD0EoGYC+VF09O7pczsKToEZH94=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=A1K4+hLRPyQxIGoro61sk9hld7QVYHYIQ39iV7K7YLq2iusgjGI99agLUY9uFUq4a
         N76y38HGtQmugA0vaOnlLLCVyQ5v5/V04asTE1ND8x5vM9vT3d/Xsxo4xBZS03lr2a
         GR01Y4d+580V16HR/P22TGZejnEu+geq+2JKOQY4=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KHKvpo014522
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 12:20:57 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 12:20:36 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 12:20:36 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KHKaEO089527;
        Wed, 20 May 2020 12:20:36 -0500
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com> <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
 <20200520164313.GI652285@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
Date:   Wed, 20 May 2020 12:20:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520164313.GI652285@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew/Florian

On 5/20/20 11:43 AM, Andrew Lunn wrote:
>> I am interested in knowing where that is documented.  I want to RTM I
>> grepped for a few different words but came up empty
> Hi Dan
>
> It probably is not well documented, but one example would be
>
> Documentation/devicetree/bindings/net/ethernet-controller.yaml
>
> says:
>
>        # RX and TX delays are added by the MAC when required
>        - rgmii
>
>        # RGMII with internal RX and TX delays provided by the PHY,
>        # the MAC should not add the RX or TX delays in this case
>        - rgmii-id
>
>        # RGMII with internal RX delay provided by the PHY, the MAC
>        # should not add an RX delay in this case
>        - rgmii-rxid
>
>        # RGMII with internal TX delay provided by the PHY, the MAC
>        # should not add an TX delay in this case
>
>        Andrew

OKI I read that.  I also looked at a couple other drivers too.

I am wondering if rx-internal-delay and tx-internal-delay should become 
a common property like tx/rx fifo-depth

And properly document how to use it or at least the expectation on use.

Dan

