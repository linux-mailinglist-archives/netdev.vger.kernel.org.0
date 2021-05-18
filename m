Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ABF386E00
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344731AbhERAA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:00:58 -0400
Received: from gateway20.websitewelcome.com ([192.185.47.18]:22432 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238461AbhERAA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:00:57 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 4BD1D400F00C2
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:47:10 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id in94l2lJzAEP6in94lf1q3; Mon, 17 May 2021 18:59:34 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WP8OErJcmlKelJqczvCkV0X7DlzM/cT7AhezC/cjhUo=; b=moKGY195TE1gv/tS9z7buZ3Ac2
        jd7wq+MnQHUnASatBfxg6jtc9t3OjG8BiseeU1D0WUwRzFpU60JGFXlNvnA9zWRGMnvCYoU/6SVP7
        tsiGluyeOb2IRvgmksmyQLxUg4YmHwlABhrpo3yeIXCCpWnigmlUI56xGBlypqm92dIwcnbDf28/D
        Kz0bYfrsge0a1/Elr7Q09iZ5New631ZdpQ+Z1FKYe/v0qB7jdbIpMrREtBcVrFjio2FOitahrrT9s
        3gN/nkHK3BiI0cnX4HrClSQVEBi+an1PJ61GVM7VcqZds8ilTTNvcCLTbQEUi6TgHkF1RY6onsjEC
        YDf6bykQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53352 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lin91-001x2Z-FY; Mon, 17 May 2021 18:59:32 -0500
Subject: Re: [PATCH RESEND][next] vxge: Fix fall-through warnings for Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305094735.GA141111@embeddedor>
 <e5591c90-1a12-febf-1aca-257895f24d26@embeddedor.com>
Message-ID: <33df60cb-2122-730b-bff6-dddce39795ac@embeddedor.com>
Date:   Mon, 17 May 2021 19:00:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <e5591c90-1a12-febf-1aca-257895f24d26@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lin91-001x2Z-FY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53352
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 24
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 4/20/21 15:22, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?
> 
> Thanks
> --
> Gustavo
> 
> On 3/5/21 03:47, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>> by explicitly adding a return statement instead of letting the code fall
>> through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  drivers/net/ethernet/neterion/vxge/vxge-config.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
>> index 5162b938a1ac..b47d74743f5a 100644
>> --- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
>> +++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
>> @@ -3784,6 +3784,7 @@ vxge_hw_rts_rth_data0_data1_get(u32 j, u64 *data0, u64 *data1,
>>  			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_ENTRY_EN |
>>  			VXGE_HW_RTS_ACCESS_STEER_DATA1_RTH_ITEM1_BUCKET_DATA(
>>  			itable[j]);
>> +		return;
>>  	default:
>>  		return;
>>  	}
>>
