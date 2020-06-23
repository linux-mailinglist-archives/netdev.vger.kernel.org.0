Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D6720469C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 03:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgFWBSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 21:18:53 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58744 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731466AbgFWBSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 21:18:52 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05N1IkRB122682;
        Mon, 22 Jun 2020 20:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592875126;
        bh=Q2jnREKdHNPlfbFQnNi8Bgm9tnFTDboNB8j6ofPFEEs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qp++4/g3tqJqCRKgxkj1IWWIXdFWfEWCe0iYrtCXdLveWIvXZ1KfUJ9B+ZynHw4hU
         oE5O5y5Y8Lk3/1rSyYtcec5BG222gnPvXIB3JCB6nkZAvlirgdQUKnCy2ZAoRhCBcs
         JqqskOzBppRHhX7M7lyr33x72jgIx6IOF3Nttg1M=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05N1IjHk047259
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 20:18:46 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 22
 Jun 2020 20:18:45 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 22 Jun 2020 20:18:45 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05N1Ij8o110007;
        Mon, 22 Jun 2020 20:18:45 -0500
Subject: Re: [PATCH net-next v9 1/5] dt-bindings: net: Add tx and rx internal
 delays
To:     David Miller <davem@davemloft.net>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200619161813.2716-1-dmurphy@ti.com>
 <20200619161813.2716-2-dmurphy@ti.com>
 <20200622.154030.984476700483302206.davem@davemloft.net>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <78436a27-288c-d094-876b-f687f2e28efa@ti.com>
Date:   Mon, 22 Jun 2020 20:18:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622.154030.984476700483302206.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David

Thanks for the review

On 6/22/20 5:40 PM, David Miller wrote:
> From: Dan Murphy <dmurphy@ti.com>
> Date: Fri, 19 Jun 2020 11:18:09 -0500
>
>> @@ -162,6 +162,19 @@ properties:
>>       description:
>>         Specifies a reference to a node representing a SFP cage.
>>   
>> +
>> +  rx-internal-delay-ps:
> Do you really want two empty lines between these two sections?

No.  Will fix.

Dan

