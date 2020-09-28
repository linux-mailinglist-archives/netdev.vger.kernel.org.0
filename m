Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4627B221
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgI1QoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:44:09 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:49864 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgI1QoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 12:44:08 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08SGi6TS012149;
        Mon, 28 Sep 2020 11:44:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601311446;
        bh=zcBi9TVE967uXZvv/aYibSy+BOpxnpnfqkW97UuDjLo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Mq5Z/xlE6ilbZoIR/S5XR61HlmVo1TUYT1pf7v+H+Sw2jxKWuNaF8aSHCJVWoo96M
         ca4j5NBX62xYnpAV9c9Bd6xOIdGWidusotLT/FCJ+8CQwDOpR5oPYWwzbLvyubGjTU
         9ULqKczF28BDF7tqtT7l6uTHKKo96xGVqyQpNt2Q=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08SGi66O083724
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 11:44:06 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 28
 Sep 2020 11:44:04 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 28 Sep 2020 11:44:04 -0500
Received: from [10.250.32.117] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SGi4PB016630;
        Mon, 28 Sep 2020 11:44:04 -0500
Subject: Re: [PATCH ethtool v3 1/3] Add missing 400000base modes for
 dump_link_caps
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>
References: <20200928144403.19484-1-dmurphy@ti.com>
 <20200928163744.pjajgxgbnj6apf3b@lion.mk-sys.cz>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <a963c44f-294b-baec-65a3-2d44ed3758c0@ti.com>
Date:   Mon, 28 Sep 2020 11:43:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200928163744.pjajgxgbnj6apf3b@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal

On 9/28/20 11:37 AM, Michal Kubecek wrote:
> On Mon, Sep 28, 2020 at 09:44:01AM -0500, Dan Murphy wrote:
>> Commit 63130d0b00040 ("update link mode tables") missed adding in the
>> 400000base link_caps to the array.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
> I'm sorry, I only found these patches shortly after I pushed similar
> update as I needed updated UAPI headers for new format descriptions.

Is there an action I need to take here?

