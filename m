Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAC52478D2
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgHQV3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:29:36 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40162 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHQV3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:29:36 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07HLTXtw036385;
        Mon, 17 Aug 2020 16:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597699773;
        bh=doqvZBfpaQHbW6i03ZaLmqIMDRIlnIWjNClqbAmxgBw=;
        h=To:From:Subject:Date;
        b=KgRWsauy0Mk0fBUHPp6QUJ8uUY69BJ8OEOUKgG6I/Ck03KO7rLtEOMmGyo2ufEXPk
         mp/XG9sgQKjSyYaMWGw3wFY1bLANxOyrC/DQ1QYQtvDo8SUCR80fCdCx0BcriT4M6A
         81XDIh559LD+msdAUqjHaGeYMtT8K4tGY8jiXd3M=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07HLTXgc031414
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 16:29:33 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 17
 Aug 2020 16:29:33 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 17 Aug 2020 16:29:33 -0500
Received: from [10.250.227.175] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07HLTWfR124761;
        Mon, 17 Aug 2020 16:29:32 -0500
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Murali Karicheri <m-karicheri2@ti.com>
Subject: ethtool enhancements for configuring IET Frame preemption
Message-ID: <b7f93fdb-4ad6-a744-056a-6ace37290a8c@ti.com>
Date:   Mon, 17 Aug 2020 17:29:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vinicius,

Wondering what is your plan to add the support in ethtool to configure 
IET frame preemption? Waiting for the next revision of the patch.

Thanks and regards,
-- 
Murali Karicheri
Texas Instruments
