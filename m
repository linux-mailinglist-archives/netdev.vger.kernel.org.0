Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B802131CFB
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 02:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgAGBDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 20:03:43 -0500
Received: from mail5.windriver.com ([192.103.53.11]:59312 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbgAGBDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 20:03:42 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 007116u9016944
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 6 Jan 2020 17:01:17 -0800
Received: from [128.224.162.195] (128.224.162.195) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.468.0; Mon, 6 Jan 2020
 17:00:56 -0800
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
To:     David Miller <davem@redhat.com>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
References: <20200106023341.206459-1-jiping.ma2@windriver.com>
 <20200106.134557.2214546621758238890.davem@redhat.com>
From:   Jiping Ma <Jiping.Ma2@windriver.com>
Message-ID: <15aedd71-e077-4c6c-e30c-9396d16eaeec@windriver.com>
Date:   Tue, 7 Jan 2020 09:00:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
MIME-Version: 1.0
In-Reply-To: <20200106.134557.2214546621758238890.davem@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/07/2020 05:45 AM, David Miller wrote:
> From: Jiping Ma <jiping.ma2@windriver.com>
> Date: Mon, 6 Jan 2020 10:33:41 +0800
>
>> Add one notifier for udev changes net device name.
>>
>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
> This doesn't apply to 'net' and since this is a bug fix that is where
> you should target this change.
What's the next step that I can do?
> Thank you.
>
>

