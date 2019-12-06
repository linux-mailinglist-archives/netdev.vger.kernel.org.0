Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1E811506E
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 13:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfLFM3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 07:29:00 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55850 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfLFM27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 07:28:59 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB6CSvjM074655;
        Fri, 6 Dec 2019 06:28:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575635337;
        bh=M1+Y8KSGNeNG5arLgGnMLbnCLyRMTkpFUDsspvDH0Wc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=XGhTLXlJfSIK4KNQwdok0tpOOdDmYDXTmKY73MAvrErEEFObq2iAepNPejt1lZsRd
         jpJpvADN1wD+CpEKyf8iSCAEqQZWyjJWlMxFLf7sxHFY0r1C7SbXBwv63V56l1yQJ+
         iaAjzYesivdA/zZuleRPXqJdVjyC7p3zytFUuChA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6CSvUO031203;
        Fri, 6 Dec 2019 06:28:57 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Dec
 2019 06:28:56 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Dec 2019 06:28:56 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6CSscJ119732;
        Fri, 6 Dec 2019 06:28:55 -0600
Subject: Re: [PATCH] net: ethernet: ti: cpsw: fix extra rx interrupt
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
References: <20191205151817.1076-1-grygorii.strashko@ti.com>
 <20191205.124225.1227757906747730493.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <6f133a89-7ed9-85a6-9c4a-6249346d26b0@ti.com>
Date:   Fri, 6 Dec 2019 14:28:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191205.124225.1227757906747730493.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/12/2019 22:42, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Thu, 5 Dec 2019 17:18:17 +0200
> 
>> This is an old issue, but I can't specify Fixes tag.
> 
> This is never true, there is always an appropriate Fixes: tag
> even it means specifying the tag that created Linus's GIT repo.
> 
>> And, unfortunatelly,
>> it can't be backported as is even in v5.4.
> 
> This I always don't understand.
> 
> You must elaborate and specify a Fixes: tag.
> 

Thank you for comments I've sent v2

-- 
Best regards,
grygorii
