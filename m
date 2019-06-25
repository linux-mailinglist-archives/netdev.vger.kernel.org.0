Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C84527E9
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfFYJWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:22:49 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:55356 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfFYJWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:22:48 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5P9MbUI047070;
        Tue, 25 Jun 2019 04:22:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561454557;
        bh=1/mUZIcmKcMKUlhDZhJFJhADMMx3PuNvQ2/i81d3u4k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=DUGkfD5pqiH2zkntwcPNqlvxUu56xDGOZHBFszfJIUBs5DHXhzClP8iFotAy5fu5Z
         KqnMiMacjFCQ+S1mbY6NNzF1t4wzMwJe4/apfj3ZPrkkzHV8faUl5kYipghfjPG/X/
         ENPNJ5B/oenPrkeLxKV9AkpAVAdUN22Xwm5bk2P4=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5P9MbHZ072424
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Jun 2019 04:22:37 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 25
 Jun 2019 04:22:37 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 25 Jun 2019 04:22:37 -0500
Received: from [172.24.190.215] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5P9MYqE076504;
        Tue, 25 Jun 2019 04:22:35 -0500
Subject: Re: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
To:     Dan Murphy <dmurphy@ti.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <e00499ba-3f26-d680-02c1-3ae2f433e2fe@ti.com>
Date:   Tue, 25 Jun 2019 14:52:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
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

Hi,

On 09/05/19 9:41 PM, Dan Murphy wrote:
> Create a m_can platform framework that peripheral
> devices can register to and use common code and register sets.
> The peripheral devices may provide read/write and configuration
> support of the IP.
> 
> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Acked-by: Faiz Abbas <faiz_abbas@ti.com>

Thanks,
Faiz
