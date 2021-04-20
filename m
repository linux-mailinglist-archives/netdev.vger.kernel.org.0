Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05C53660E0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhDTU1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:27:53 -0400
Received: from gateway24.websitewelcome.com ([192.185.50.66]:13836 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233619AbhDTU1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:27:52 -0400
X-Greylist: delayed 1149 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 16:27:52 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 22D1E2120F8
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:27:19 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ywxrle1Fh1cHeYwxrllo8J; Tue, 20 Apr 2021 15:27:19 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZMqih+LZ+Av7eWmhGE/uwhisMT5HdTzF9c2GPKwl398=; b=J4Y3r8ufEYOysJToJOl3gjCpb9
        6y8X4qjt7672duhl/OX4KoYr1Sz2dw5TJJq7RKhONAU0agR5qHNZJkBMgNNQXqybxNzpex2mZXVS/
        jmI5qlXwyUmtRNcUfk0whzZOlCm8MobpaWE9PP2/kqRZr3iw6I8jaAp4lfC/I+A/yXenSqLmJ8ORq
        z5pNAfCgR+AVgRTDM6dP2qIH5FO0aOnuMxMd1BhNJ/dO/6PfRWim/VAzqZv1I/BpAR9drp1oBnOcx
        NSjQB95pLeOJgoWMb4birDGDde8cvdhBPpmavFEEvMapwLJpO/pjdWghX4yWtt/zk50ArWJP/gVbH
        b5Un7SnQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49058 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwxo-0037wH-M0; Tue, 20 Apr 2021 15:27:16 -0500
Subject: Re: [PATCH RESEND][next] bnxt_en: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305095024.GA141398@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <55348913-84be-5149-e43f-7982ecd73c40@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:27:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305095024.GA141398@embeddedor>
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
X-Exim-ID: 1lYwxo-0037wH-M0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49058
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 190
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 03:50, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of just letting the code
> fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index b53a0d87371a..a34810750058 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -2158,6 +2158,7 @@ static int bnxt_hwrm_handler(struct bnxt *bp, struct tx_cmp *txcmp)
>  	case CMPL_BASE_TYPE_HWRM_ASYNC_EVENT:
>  		bnxt_async_event_process(bp,
>  					 (struct hwrm_async_event_cmpl *)txcmp);
> +		break;
>  
>  	default:
>  		break;
> 
