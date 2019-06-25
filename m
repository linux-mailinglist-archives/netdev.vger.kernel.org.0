Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79D8527FE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfFYJYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:24:46 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:51150 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfFYJYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:24:46 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5P9OapP052130;
        Tue, 25 Jun 2019 04:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561454676;
        bh=zWtyiVKQv1Kc53PEsd84A1unG9JyF64ZEbVFqS74fng=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=MMkigt+/CEtb/tjDDXjXVlw2SX9tr76dvNIhpUdesdUlpHWP0EyaEUCEjDReqVIOp
         03Ym5I3EMwr/B84aJ2ODm6Wc7YMxr81o0jxYg5tbEK7uEuxtURfBv5aR1lA4Olptqn
         rYvHAWV6v8kD7ehtFL15olNgEKQc9jXGzmLKqfXI=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5P9OaHW121033
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Jun 2019 04:24:36 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 25
 Jun 2019 04:24:36 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 25 Jun 2019 04:24:36 -0500
Received: from [172.24.190.215] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5P9OXMs086333;
        Tue, 25 Jun 2019 04:24:34 -0500
Subject: Re: [PATCH v12 5/5] can: m_can: Fix checkpatch issues on existing
 code
To:     Dan Murphy <dmurphy@ti.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
 <20190509161109.10499-5-dmurphy@ti.com>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <f7f61ccb-f6e9-1e74-a716-96f246944b64@ti.com>
Date:   Tue, 25 Jun 2019 14:54:53 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190509161109.10499-5-dmurphy@ti.com>
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
> Fix checkpatch issues found during the m_can framework creation.
> The code the issues were in, was in untouched code and these
> changes should be done separately as to not be confused with the
> framework changes.
> 
> Fix these 3 check issues:
> CHECK: Unnecessary parentheses around 'cdev->can.state != CAN_STATE_ERROR_WARNING'
> 	if (psr & PSR_EW &&
> 	    (cdev->can.state != CAN_STATE_ERROR_WARNING)) {
> 
> CHECK: Unnecessary parentheses around 'cdev->can.state != CAN_STATE_ERROR_PASSIVE'
> 	if ((psr & PSR_EP) &&
> 	    (cdev->can.state != CAN_STATE_ERROR_PASSIVE)) {
> 
> CHECK: Unnecessary parentheses around 'cdev->can.state != CAN_STATE_BUS_OFF'
> 	if ((psr & PSR_BO) &&
> 	    (cdev->can.state != CAN_STATE_BUS_OFF)) {
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Acked-by: Faiz Abbas <faiz_abbas@ti.com>

Thanks,
Faiz
