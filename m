Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9D528C45E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 23:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbgJLV5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 17:57:03 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53248 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731083AbgJLV5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 17:57:03 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09CLv033010469;
        Mon, 12 Oct 2020 16:57:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602539820;
        bh=KEEjr1TJQf8w4kLOA50efHGhlC+WAW48EVAvsPdLf6U=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=NmPP3Zz3/28uSMdRvXXKK4lGEyg0Vw75+8BserzrZdQGOQrKx5RE6A1YpN8Ri5w3s
         4N1j9sSwXOZ0ozyR56FW/vThmBExWcwsjj+z5OBP/o00WK7JT1+LJK1V2Fcp8u1xKp
         DtEFH5EpBNfIK2vf9rqKOf/sQwBaMGu2Er2XEs8Y=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09CLv00q043049
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Oct 2020 16:57:00 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 12
 Oct 2020 16:57:00 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 12 Oct 2020 16:57:00 -0500
Received: from [10.250.129.154] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09CLuw42041390;
        Mon, 12 Oct 2020 16:56:59 -0500
Subject: Re: ethtool enhancements for configuring IET Frame preemption
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b7f93fdb-4ad6-a744-056a-6ace37290a8c@ti.com>
 <87lficsy5k.fsf@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <8908ab22-a4d0-1a9b-99c6-6ab3c3a69ed3@ti.com>
Date:   Mon, 12 Oct 2020 17:56:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87lficsy5k.fsf@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 8/17/20 6:30 PM, Vinicius Costa Gomes wrote:
> Hi Murali,
> 
> I was finally able to go back to working on this, and should have
> something for review when net-next opens.
> 
Do you have anything to share here on this or still work in progress?

Thanks

Murali
> 
> Cheers,
> 
> Murali Karicheri <m-karicheri2@ti.com> writes:
> 
>> Hello Vinicius,
>>
>> Wondering what is your plan to add the support in ethtool to configure
>> IET frame preemption? Waiting for the next revision of the patch.
>>
>> Thanks and regards,
>> -- 
>> Murali Karicheri
>> Texas Instruments
> 

-- 
Murali Karicheri
Texas Instruments
