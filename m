Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9608213776B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgAJTpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:45:01 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56152 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgAJTpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:45:01 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AJiu1X120699;
        Fri, 10 Jan 2020 13:44:56 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578685496;
        bh=ItNnnZAM/+Sva9AL51uIL1NROcOms3i8jcra1pSdNkA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=uX2M8G04XNe8eGTXh514QVte952OuEmEty4cXZ99l815FLWYhnq/l4/iCAZlE+bg8
         vEY3pCrb/LR/3bR4LNZTtrrehG41oI2FllOifSK1Q4iVRbxXNPlwG5IzG9ToGPWwbd
         Ad6ri8umwx6XuS5CoGVtqJ0vG/7gGcQkqkHYyc1Q=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AJiuE5128687;
        Fri, 10 Jan 2020 13:44:56 -0600
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 13:44:56 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 13:44:56 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AJiti6059704;
        Fri, 10 Jan 2020 13:44:55 -0600
Subject: Re: [PATCH 0/4] TI DP8382x Phy support update
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200110184702.14330-1-dmurphy@ti.com>
 <20200110192524.GO19739@lunn.ch>
 <2e9333e1-1ee7-80ce-fab4-a98a9f4b345f@ti.com>
 <20200110194011.GT19739@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f4cbc8c1-ba4b-fc57-b60c-e10ff8286bd3@ti.com>
Date:   Fri, 10 Jan 2020 13:42:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200110194011.GT19739@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 1/10/20 1:40 PM, Andrew Lunn wrote:
>> You mean separate series between fixes and functionality?
>>
>> Sure I can separate them but they are dependent on each other.
> Send 1 and 2 first. After about a week, David will merge net into
> net-next, and then you can submit 3 and 4.

Thanks.  Got it

Dan


> 	  Andrew
