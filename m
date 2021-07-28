Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F3E3D871B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhG1FT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:19:29 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58540 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhG1FTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 01:19:18 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 16S5J96B066222;
        Wed, 28 Jul 2021 00:19:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1627449549;
        bh=ovNY00+txIuqmx39OXiCCx1/fI17gzc7MnTaFURyg4w=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=cMoLM7+qrusLNQXS3xS344KzjKFW5qkiDVhXe/wj/GBll+BffavUVoZa1XL2ii00+
         c1BNfOtAsHKBT/a7SUoaFJ/NKPXPDWRuKSiJubMofkZbxWtcJymBPLR0UXSPcIr5nv
         xdRzduD1NwUOcdbRN05Ac3YjjPOv2QK3LjrKVxvQ=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 16S5J9du117696
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Jul 2021 00:19:09 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 28
 Jul 2021 00:19:08 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 28 Jul 2021 00:19:08 -0500
Received: from [10.250.232.46] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 16S5J435090940;
        Wed, 28 Jul 2021 00:19:05 -0500
Subject: Re: [PATCH v4 0/2] MCAN: Add support for implementing transceiver as
 a phy
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
References: <20210510052541.14168-1-a-govindraju@ti.com>
 <2c5b76f7-8899-ab84-736b-790482764384@ti.com>
 <20210616091709.n7x62wmvafz4rzs7@pengutronix.de>
 <218d6825-82c0-38f5-19ab-235f8e6f74a0@ti.com>
 <20210727065416.k2kye47iiuubkpoz@pengutronix.de>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <7f0316f7-7192-8c68-1800-f4890dac3945@ti.com>
Date:   Wed, 28 Jul 2021 10:49:04 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727065416.k2kye47iiuubkpoz@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 27/07/21 12:24 pm, Marc Kleine-Budde wrote:
> On 19.07.2021 19:47:33, Aswath Govindraju wrote:
>> I am planning on posting device tree patches to arm64 tree and
>> Nishanth(maintainer of the tree) requested for an immutable tag if the
>> dependent patches are not in master. So, after applying this patch
>> series, can you please provide an immutable tag ?
> 
> The patches are included in my pull request with the tag
> linux-can-next-for-5.15-20210725 [1], meanwhile they are in
> net-next/master.
> 
> Hope that helps,
> Marc
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=linux-can-next-for-5.15-20210725
> 

Thanks a lot for providing a tag.

Regards,
Aswath
