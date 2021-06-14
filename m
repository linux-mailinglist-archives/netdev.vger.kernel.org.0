Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD0D3A66AD
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhFNMfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:35:24 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:60160 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbhFNMfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:35:21 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15ECX0g1126397;
        Mon, 14 Jun 2021 07:33:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623673980;
        bh=K9aA0EEHDadNv3Gx8t1nVIU1t9/F1DE1N2f1aCytT/Y=;
        h=Subject:CC:References:To:From:Date:In-Reply-To;
        b=laiaxztoru0AR/pQx7GoqGtV31haRRB6fir93GR4p9T6bvgFkUxHCq0IptbY0to0V
         35WMAu/x8KS5pU/Zfhkyj6QYZ/GyVT2fj3DCl4y8O18M+3KeDNSSvG3DsbYaKzfMhj
         MWzLE+GUrkL3IJxFVJgzxZ8cs89wUv27dtlrqq3E=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15ECX0Es064241
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Jun 2021 07:33:00 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 14
 Jun 2021 07:33:00 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 14 Jun 2021 07:33:00 -0500
Received: from [10.250.235.117] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15ECWshU005055;
        Mon, 14 Jun 2021 07:32:55 -0500
Subject: Re: [PATCH v4 0/2] MCAN: Add support for implementing transceiver as
 a phy
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
References: <20210510052541.14168-1-a-govindraju@ti.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <2c5b76f7-8899-ab84-736b-790482764384@ti.com>
Date:   Mon, 14 Jun 2021 18:02:53 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210510052541.14168-1-a-govindraju@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 10/05/21 10:55 am, Aswath Govindraju wrote:
> The following series of patches add support for implementing the
> transceiver as a phy of m_can_platform driver.
> 
> TCAN1042 has a standby signal that needs to be pulled high for
> sending/receiving messages[1]. TCAN1043 has a enable signal along with
> standby signal that needs to be pulled up for sending/receiving
> messages[2], and other combinations of the two lines can be used to put the
> transceiver in different states to reduce power consumption. On boards
> like the AM654-idk and J721e-evm these signals are controlled using gpios.
> 
> These gpios are set in phy driver, and the transceiver can be put in
> different states using phy API. The phy driver is added in the series [3].
> 
> This patch series is dependent on [4].
> 

[4] is now part of linux-next

May I know if this series is okay to be picked up ?

Thanks,
Aswath

> changes since v3:
> - Added phy_power_off() in case of an error in m_can_open().
> 
> changes since v2:
> - changed dev_err to dev_err_probe in patch 2
> - used mcan_class instead of priv to assign max bit rate
> - Picked up  Rob Herring's acked-by for patch 1
> 
> changes since v1:
> - Used the API devm_phy_get_optional() instead of
>   devm_of_phy_get_optional_by_index()
> 
> [1] - https://www.ti.com/lit/ds/symlink/tcan1042h.pdf
> [2] - https://www.ti.com/lit/ds/symlink/tcan1043-q1.pdf
> [3] - https://lore.kernel.org/patchwork/project/lkml/list/?series=498359
> [4] - https://lore.kernel.org/patchwork/patch/1413286/
> 
> Faiz Abbas (2):
>   dt-bindings: net: can: Document transceiver implementation as phy
>   can: m_can: Add support for transceiver as phy
> 
>  .../devicetree/bindings/net/can/bosch,m_can.yaml    |  3 +++
>  drivers/net/can/m_can/m_can.c                       | 11 +++++++++++
>  drivers/net/can/m_can/m_can.h                       |  2 ++
>  drivers/net/can/m_can/m_can_platform.c              | 13 +++++++++++++
>  4 files changed, 29 insertions(+)
