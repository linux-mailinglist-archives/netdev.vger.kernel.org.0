Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79A5222015
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgGPKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:00:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7874 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbgGPKAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:00:14 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 65910E0921DE2CE7D799;
        Thu, 16 Jul 2020 18:00:09 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.238) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 16 Jul 2020
 18:00:01 +0800
Subject: Re: [PATCH] net: neterion: vxge: reduce stack usage in
 VXGE_COMPLETE_VPATH_TX
To:     Joe Perches <joe@perches.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-next@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jdmason@kudzu.us>, <christophe.jaillet@wanadoo.fr>,
        <john.wanghui@huawei.com>
References: <20200716173247.78912-1-cuibixuan@huawei.com>
 <687734b1623965b154752252968adeca35740c88.camel@perches.com>
From:   Bixuan Cui <cuibixuan@huawei.com>
Message-ID: <bf277e52-df6f-1249-9af1-6eea4aa663af@huawei.com>
Date:   Thu, 16 Jul 2020 17:59:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <687734b1623965b154752252968adeca35740c88.camel@perches.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.238]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/7/16 17:46, Joe Perches wrote:
> I doubt this is a good idea.
> Check the callers interrupt status.
yes, it's not good idea to alloc memory in interrupt handler,
I will think more while fix warning. :)
Thanks.

