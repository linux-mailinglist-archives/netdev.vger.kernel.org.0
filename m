Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9766247868
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 22:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgHQU7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 16:59:18 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36776 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHQU7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 16:59:17 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07HKwfO3028875;
        Mon, 17 Aug 2020 15:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597697921;
        bh=sZfjcuY3ET6KjajkQkKEOmAhEG2PZKNSiWaJZrOVbUE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qvZfWvIjepWO8bOVGrRdhY0HfVM2GRMNoTXv1IuKSV5PLpSydT1/oqq9CtMKbk0b0
         lvSsBmyWNzmhiANo7LNagRcFeaj8CRGDXSWyxyBpsHyyM4WARy0ICV74XJzEdQ0WOR
         jMXf7apDG4h0b6wOF6RqrEaKx+F4+Uw/jUNgSFps=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07HKwfsm116665
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 15:58:41 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 17
 Aug 2020 15:58:41 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 17 Aug 2020 15:58:41 -0500
Received: from [10.250.227.175] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07HKwdLv013286;
        Mon, 17 Aug 2020 15:58:40 -0500
Subject: Re: [net-next iproute2 PATCH v4 1/2] iplink: hsr: add support for
 creating PRP device similar to HSR
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <kuznet@ms2.inr.ac.ru>
References: <20200806203712.2712-1-m-karicheri2@ti.com>
 <20200806203712.2712-2-m-karicheri2@ti.com>
 <20200816154608.0fe0917b@hermes.lan>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <682a636a-a42b-f40d-853c-3ae7d3c4bd82@ti.com>
Date:   Mon, 17 Aug 2020 16:58:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200816154608.0fe0917b@hermes.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/20 6:46 PM, Stephen Hemminger wrote:
> On Thu, 6 Aug 2020 16:37:11 -0400
> Murali Karicheri <m-karicheri2@ti.com> wrote:
> 
>> +	
> 
>> +		print_int(PRINT_ANY,
>> +			  "proto",
>> +			  "proto %d ",
>> +			  rta_getattr_u8(tb[IFLA_HSR_PROTOCOL]));
> 
> Since this unsigned value, you probably want to use print_uint, or print_hhu.
> Also please put as many arguments on one line that will fit in 80 (to 90) characters.
> 
> 	if (tb[IFLA_HSR_PROTOCOL])
> 		print_hhu(PRINT_ANY, "proto", "proto %hhu ",
> 			  rta_getattr_u8(tb[IFLA_HSR_PROTOCOL]));
> 
Ok. Will send v5 shortly for this.
-- 
Murali Karicheri
Texas Instruments
