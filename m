Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EF6117360
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLISCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:02:33 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35850 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:02:32 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB9I2Qqg010003;
        Mon, 9 Dec 2019 12:02:26 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575914546;
        bh=p27ngScByZibHh+gUZ0Szuc+RoIApKBQAaSxjbTsJLg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=lQE4WZOWRq74OR6Koq9eFvfT32do9jUsbVpFnnMW/iJ86zlShka2i6GjS38WH9ZZg
         av/0H/1+Gu0jSCsb+VERXKmRsb/HJlhSwJjhRKT4fFTPm4NdPzDblxdOOJGvBZwtld
         gVUcjWt6Cez4X5y8DEPOPEjAj9rI+YIQSKfuJhRk=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9I2QoM025315;
        Mon, 9 Dec 2019 12:02:26 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 9 Dec
 2019 12:02:26 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 9 Dec 2019 12:02:26 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9I2Qr4052252;
        Mon, 9 Dec 2019 12:02:26 -0600
Subject: Re: [PATCH 1/2] dt-bindings: dp83867: Convert fifo-depth to common
 fifo-depth and make optional
To:     David Miller <davem@davemloft.net>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>, <robh@kernel.org>
References: <20191206164516.2702-1-dmurphy@ti.com>
 <20191209.094356.813138131056263064.davem@davemloft.net>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d9418bb2-6726-f352-0636-96c0ff0848c4@ti.com>
Date:   Mon, 9 Dec 2019 12:00:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191209.094356.813138131056263064.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David

On 12/9/19 11:43 AM, David Miller wrote:
> These patches don't apply cleanly to my networking trees.
>
> Please also properly supply an appropriate "[PATCH 0/N]" header posting
> and clearly indicate the target GIT tree as in "[PATCH net-next 0/N]"
> as well as the patch series version "[PATCH v2 net-next 0/N]" when you
> repsin this.
>
> Thanks.

Ack and resent

Dan

