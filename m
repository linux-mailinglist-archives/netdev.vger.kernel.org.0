Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA6A1D0F18
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbgEMKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:04:40 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:10925 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732876AbgEMJrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:47:37 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15]) by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee95ebbc226b8f-ccef9; Wed, 13 May 2020 17:47:19 +0800 (CST)
X-RM-TRANSID: 2ee95ebbc226b8f-ccef9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [172.20.144.88] (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee85ebbc22539f-3d20b;
        Wed, 13 May 2020 17:47:18 +0800 (CST)
X-RM-TRANSID: 2ee85ebbc22539f-3d20b
Subject: Re: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
To:     David Miller <davem@davemloft.net>
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
 <20200507.131834.1517984934609648952.davem@davemloft.net>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <febc1254-ad7f-f564-6607-9ac89f1fcf40@cmss.chinamobile.com>
Date:   Wed, 13 May 2020 17:48:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200507.131834.1517984934609648952.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David:

On 2020/5/8 4:18, David Miller wrote:
> From: Tang Bin <tangbin@cmss.chinamobile.com>
> Date: Thu,  7 May 2020 19:50:10 +0800
>
>> Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
>> to simplify code, avoid redundant judgements.
>>
>> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> Saeed, please pick this up.

Does this mean the patch has been received and I just have to wait?

Thanks,

Tang Bin



