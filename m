Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E681FBD3
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 22:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfEOUyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 16:54:15 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:42910 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfEOUyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 16:54:14 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x4FKs2rH056136;
        Wed, 15 May 2019 15:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557953642;
        bh=+wUqRqbw1z4xlc63HNeRQzojTjDL8233B/q0TJ3CDqU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=A8Ng9owoXW5xqTffS3aPfLW8Ey+bkIZHgNfVox3ygbbiBBABQCxRXh06OkZ8Zi0ww
         sBv2bwYChvfIauYs74HPHMLklrNqtFgmBl8QS/oPlBveBq0xPcZcVxdsK6W7QKxnt0
         EE8xQOmslh2qdP1exvQZU8AvZ8H3fZCRVizCAHgQ=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x4FKs2lE060513
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 May 2019 15:54:02 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 15
 May 2019 15:54:01 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 15 May 2019 15:54:01 -0500
Received: from [10.250.90.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x4FKs1ew020719;
        Wed, 15 May 2019 15:54:01 -0500
Subject: Re: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <dbb7bdef-820d-5dcc-d7b5-a82bc1b076fb@ti.com>
Date:   Wed, 15 May 2019 15:54:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509161109.10499-1-dmurphy@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

On 5/9/19 11:11 AM, Dan Murphy wrote:
> Create a m_can platform framework that peripheral
> devices can register to and use common code and register sets.
> The peripheral devices may provide read/write and configuration
> support of the IP.
> 
> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> 
> v12 - Update the m_can_read/write functions to create a backtrace if the callback
> pointer is NULL. - https://lore.kernel.org/patchwork/patch/1052302/
> 

Is this able to be merged now?

Dan

<snip>
