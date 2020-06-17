Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108C61FD489
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgFQS1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:27:15 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38466 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgFQS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:27:14 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05HIR966014994;
        Wed, 17 Jun 2020 13:27:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592418429;
        bh=q9IeiGcmHa7Cuowc/9kIPooap4gOmUa92yAlNd2M3p8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=x092aJ7BnaJt7pJkKNOofQh//IyubKji8DqWfcbUvWNN7M+XHlvf9kVUsRo90Qsl9
         NaAP3aL/137rJlTVYXvxjxbjpTU7zramn7OOe2yz5aP4V99y7eaKwPjY2g1RPST9aj
         FqYC+ZtmJTBgq/9GCTD/tCOONgzNkob112PzOaJ8=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05HIR9eY022851
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 17 Jun 2020 13:27:09 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 17
 Jun 2020 13:27:08 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 17 Jun 2020 13:27:09 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05HIR8gR010235;
        Wed, 17 Jun 2020 13:27:08 -0500
Subject: Re: [PATCH net-next v7 6/6] net: phy: DP83822: Add ability to
 advertise Fiber connection
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200617182019.6790-1-dmurphy@ti.com>
 <20200617182019.6790-7-dmurphy@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <4efcd835-e4e2-ddfa-d0f8-9f29f574eb9e@ti.com>
Date:   Wed, 17 Jun 2020 13:27:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617182019.6790-7-dmurphy@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All

On 6/17/20 1:20 PM, Dan Murphy wrote:
> The DP83822 can be configured to use the RGMII interface. There are
> independent fixed 3.5ns clock shift (aka internal delay) for the TX and RX
> paths. This allow either one to be set if the MII interface is RGMII and
> the value is set in the firmware node.

$subject is wrong.  I used the 83822 fiber patch as my base as it had 
90% of the work done that I needed for the

internal delay.  I will fix it in v8 after review comments.

Dan

