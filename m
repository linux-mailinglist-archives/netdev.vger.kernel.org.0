Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EF1792C8
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbfG2SHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:07:10 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47296 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387445AbfG2SHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:07:10 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x6TI76sc006197;
        Mon, 29 Jul 2019 13:07:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1564423626;
        bh=AKFELG+ezMD88zUiFgJwQ2qYzeJA1maECZ/eCcsQ5BI=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=CBKqAuwj48L5GMVzsMDe9zcI4EbfErf14jumS2A0llT4PJlGH5q0skLfRZS7tKBPj
         zYLvV0zahvOBAI/YSVUYRFb/J2mdQjFpIkn5QRbS+iqsD+yxbDZUQ6z+D7dKVzsblR
         puBi1Noqjc7uAPBW8bSmiu0R8siLIUCRCItPAUws=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x6TI760D030092
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 29 Jul 2019 13:07:06 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 29
 Jul 2019 13:07:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 29 Jul 2019 13:07:06 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x6TI75uW080583;
        Mon, 29 Jul 2019 13:07:06 -0500
Subject: Re: tcan4x5x on a Raspberry Pi
To:     "FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu)" 
        <fixed-term.Konstantin.Buecheler@escrypt.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <845ea24f71b74b42821c7fce20bc0476@escrypt.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d1badcdb-7635-705d-35d5-448297e8fafa@ti.com>
Date:   Mon, 29 Jul 2019 13:07:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <845ea24f71b74b42821c7fce20bc0476@escrypt.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konstantin

On 7/29/19 6:19 AM, FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu) wrote:
> Hi all,
>
> I am currently working on a project where I am trying to use the tcan4550 chip with a Raspberry PI 3B.
> I am struggling to create a working device tree overlay file for the Raspberry Pi.
> Has anyone here tried this already? I would appreciate any help.

Are you using the driver from net-next?

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/can/m_can

DT documentation here

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/Documentation/devicetree/bindings/net/can/tcan4x5x.txt

I did the development on a BeagleBone Black.

Dan

> Thanks,
> Konstantin
>
