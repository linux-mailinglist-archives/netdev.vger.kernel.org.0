Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5A724FC52
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgHXLKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:10:18 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33394 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHXLKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 07:10:11 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07OBA3cp096925;
        Mon, 24 Aug 2020 06:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598267403;
        bh=vhy+lFcf4NUB3k3T2KW/aXZiD6OvvZfTixhkehOLtTA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=H1F4z49nnK9dEeMvoVHhvqYeZV1x8jGX3yEkDuHI6d7LZ9J0fEARLurnXDq9NiQwg
         2/St8hc4mwojV+u5K56mpCqkvxzLQmhvdoMTM1qPMpq4oIvl6xE+WzVr/9ee6/YcrH
         7+ak6NDIHMLY7m+vhnxNRVY2aLMfFF/DSed87nJM=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07OBA3UX020603
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 06:10:03 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 24
 Aug 2020 06:10:03 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 24 Aug 2020 06:10:03 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07OBA2CF027716;
        Mon, 24 Aug 2020 06:10:03 -0500
Subject: Re: [net v2 PATCH 2/2] net: ethernet: ti: cpsw_new: fix clean up of
 vlan mc entries for host port
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200821134912.30008-1-m-karicheri2@ti.com>
 <20200821134912.30008-2-m-karicheri2@ti.com>
 <20200821130002.00002367@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <cca548db-7da2-7aa4-660c-bc3d22d3e023@ti.com>
Date:   Mon, 24 Aug 2020 07:09:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821130002.00002367@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 4:00 PM, Jesse Brandeburg wrote:
> Murali Karicheri wrote:
> 
>> To flush the vid + mc entries from ALE, which is required when a VLAN
>> interface is removed, driver needs to call cpsw_ale_flush_multicast()
>> with ALE_PORT_HOST for port mask as these entries are added only for
>> host port. Without this, these entries remain in the ALE table even
>> after removing the VLAN interface. cpsw_ale_flush_multicast() calls
>> cpsw_ale_flush_mcast which expects a port mask to do the job.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> Patch looks good but please resend with a Fixes: tag.
> 
Sure will do
-- 
Murali Karicheri
Texas Instruments
