Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DC1527F8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfFYJXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:23:48 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39402 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfFYJXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:23:48 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5P9Ngis127249;
        Tue, 25 Jun 2019 04:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561454622;
        bh=CYAkaJKHP3gcd7IjXGCKkql/c+Gj6Kmc00gAPP+4+Aw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Ut96TZQP6QMyDeZpIv9Bx0iIoY422Uk6pcLRwMRqr1rlPUtObSjrRNuG5K5e8ssn+
         zVcwWtj3LQh4kH1FhSiar8d+ZTNAvxj42LHdZkHAcZrhAbXIziwP8HKWIPDOvbfpMb
         Drad7srDQlnpE+YxvBynx9QkYxQzbsPIZJfOUTwI=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5P9NgC5120111
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Jun 2019 04:23:42 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 25
 Jun 2019 04:23:42 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 25 Jun 2019 04:23:42 -0500
Received: from [172.24.190.215] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5P9Ndis104580;
        Tue, 25 Jun 2019 04:23:40 -0500
Subject: Re: [PATCH v12 2/5] can: m_can: Rename m_can_priv to m_can_classdev
To:     Dan Murphy <dmurphy@ti.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
 <20190509161109.10499-2-dmurphy@ti.com>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <820987ea-e43e-4702-e0df-8369914a3c93@ti.com>
Date:   Tue, 25 Jun 2019 14:53:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190509161109.10499-2-dmurphy@ti.com>
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
> Rename the common m_can_priv class structure to
> m_can_classdev as this is more descriptive.
> 
> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Acked-by: Faiz Abbas <faiz_abbas@ti.com>

Thanks,
Faiz
