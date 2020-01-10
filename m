Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FA213773A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgAJTbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:31:04 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60862 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgAJTbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:31:03 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00AJUwJn094609;
        Fri, 10 Jan 2020 13:30:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578684658;
        bh=FmFre3D1v2uvSgCmb16gwmygh7BGUpqD8FGcahDNICk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=MROnmtSqB4RRTP9M+GBGNbauhj0DJAbOv94nr7ZAyy7R+HJlpelRMEGCq1ZzAgt/1
         uhgIU2tES5yv2ZPKRPbTk/pQzlTh8XJ68j69paH+DkmPKb7QCYG/gFnw/dw1JYa25E
         zjgAtgb9k+T6kePR2ShgTrSR/iYOW3jP7ska3BwE=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00AJUvVS120153
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jan 2020 13:30:58 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 10
 Jan 2020 13:30:57 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 10 Jan 2020 13:30:57 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00AJUvSo065048;
        Fri, 10 Jan 2020 13:30:57 -0600
Subject: Re: [PATCH 0/4] TI DP8382x Phy support update
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200110184702.14330-1-dmurphy@ti.com>
 <20200110192524.GO19739@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <2e9333e1-1ee7-80ce-fab4-a98a9f4b345f@ti.com>
Date:   Fri, 10 Jan 2020 13:28:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200110192524.GO19739@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 1/10/20 1:25 PM, Andrew Lunn wrote:
> On Fri, Jan 10, 2020 at 12:46:58PM -0600, Dan Murphy wrote:
>> Hello
>>
>> These patches update and fix some issue found in the TI ethernet PHY drivers.
> Hi Dan
>
> Please could you separate fixes from new functionality. Have the fixes
> based on net, and new functionality on net-next.

You mean separate series between fixes and functionality?

Sure I can separate them but they are dependent on each other.

3 and 4 will not apply cleanly if patch 1 and 2 are not merged first.

Did you want patch 1 and patch 2 sent separately or together as part of 
their own series?

Dan


