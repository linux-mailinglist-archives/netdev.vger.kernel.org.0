Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1AC2260A8
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgGTNUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:20:50 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42134 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTNUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 09:20:50 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06KDKjRn110242;
        Mon, 20 Jul 2020 08:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595251245;
        bh=fHibyZU8eMvgXdXwQ7PItKsVHUvXrjo73hcgwlhfeDg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=GFJRQBttuioT3tBZhkkZZDcvH6tX/oiv8xFRsUPmRcqcgQ930gUE2pNArKpRDqg21
         RBp8F2J+4uExDzQFqFDdyBE0w88lc8na/6ULgPTo21x4eylBW/myYsxfpDaHhJ1Hlf
         T4XqA9xHWM9Pl69xIEpeDfcKLl8oipa+pyETYcHg=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06KDKjLa062982
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 08:20:45 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 20
 Jul 2020 08:20:45 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 20 Jul 2020 08:20:45 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06KDKics088219;
        Mon, 20 Jul 2020 08:20:44 -0500
Subject: Re: [net-next PATCH v3 2/7] net: hsr: introduce common code for skb
 initialization
To:     David Miller <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
References: <20200717151511.329-1-m-karicheri2@ti.com>
 <20200717151511.329-3-m-karicheri2@ti.com>
 <20200717.185628.2081788534116318446.davem@davemloft.net>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <013a7d42-d163-126f-aeac-5f72dfe29ad6@ti.com>
Date:   Mon, 20 Jul 2020 09:20:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717.185628.2081788534116318446.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/20 9:56 PM, David Miller wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> Date: Fri, 17 Jul 2020 11:15:06 -0400
> 
>> +static void send_hsr_supervision_frame(struct hsr_port *master,
>> +				       u8 type, u8 hsr_ver)
>> +{
>> +	struct sk_buff *skb;
>> +	struct hsr_tag *hsr_tag;
>> +	struct hsr_sup_tag *hsr_stag;
>> +	struct hsr_sup_payload *hsr_sp;
>> +	unsigned long irqflags;
> 
> Reverse christmas tree please.
> 
OK
-- 
Murali Karicheri
Texas Instruments
