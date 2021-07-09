Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944603C2549
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 15:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhGIN4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 09:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGIN4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 09:56:39 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEA6C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 06:53:55 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f17so12260179wrt.6
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 06:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3D+gFfo5p6RDWb5yI0TJMiYcrkwxYsjy7kxukfHMzOQ=;
        b=avg1C8uH27xW3nu845uw6mQFD3qdUmoHDm+r3k7/i4d3aARgzqiTNgPDModyw8cvpE
         X2X2dwRL+IslWUrbd2518TNPYMILsnbFlH9ByQ/ctK6H8Oya1ZBVqP1B0Lai+Y2M4Obe
         FkbarqsSoVYao7By9Jv1/0ECDXX1c9Otq2Yl4BTLvKJX9yZ4yix/tAOiawh+p7fnJwMZ
         RVjVm2CfRKITJvnCsxq/w9Rd1iv5P+IVwYNX867ttm/5wYQ/jdE6CyzAtiD1UPAo3n4T
         zLuhyKULv+aMeUSX7x8hDAdrP7b8PfE9zX3mNRiusgbGRNIZrBNYBTW/7Ejj8XKtU57q
         iH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3D+gFfo5p6RDWb5yI0TJMiYcrkwxYsjy7kxukfHMzOQ=;
        b=FKHbYHd1KK/1jwxsT/lAL+CFWYwA/MycXSIzxwOjlurMDaiu5m/cX0IU0Nlm5tNlg4
         X67ONz124wtOwT6ctHG/94Jgp8KwCI/DtECrYLBJbUT+rfcCDN16I33Vco3W3wzLWQBq
         M4xUKP4csOcadZ0JxEEVvvHCjE2WsJq5K/1rZplNp8/8A+pCBPR8Z83gNO05XGyuEK/n
         k+lGMbzSVYIe2q3AGC8KjDbvH1vcvdB/3UQa14XX8JiJrMt2v8SNJX4a0Ouu//So17FW
         6w/pUUDsDnipuD7S5GZM8dC8/bTON2aSsBMT5gvwyzNJ1SXfFIHPYsK8zgBf/XhkE43U
         vrPA==
X-Gm-Message-State: AOAM531NKfspT8R0nJtUY8+byhiHNSu7Is1di2EuSfpDgozZAtq+2OWY
        ed7D22nK3ee+bzXRP1wp1e5PQgA+MZC8DA==
X-Google-Smtp-Source: ABdhPJzOjEj/a25sdCwylej3QO5tL2mxCSu+yGaHKLi8q+KBcxj9eDZvzq9DUBWMEh9/E4SIl4c3VA==
X-Received: by 2002:a05:6000:12c7:: with SMTP id l7mr40063396wrx.177.1625838833886;
        Fri, 09 Jul 2021 06:53:53 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id b20sm5111392wmj.7.2021.07.09.06.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 06:53:53 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] sfc: revert "adjust efx->xdp_tx_queue_count with
 the real number of initialized queues"
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <20210709125520.39001-1-ihuguet@redhat.com>
 <20210709125520.39001-3-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <4d8a691f-b447-8dbb-08a9-9dd8ca38e703@gmail.com>
Date:   Fri, 9 Jul 2021 14:53:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210709125520.39001-3-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/07/2021 13:55, Íñigo Huguet wrote:
> This reverts commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count
> with the real number of initialized queues"). It intended to fix a
> problem caused by a round up when calculating the number of XDP channels
> and queues.
> 
> However, that was not the real problem. The real problem was that the
> number of XDP TX queues created had been reduced to half in
> commit e26ca4b53582 ("sfc: reduce the number of requested xdp ev queues"),
> but the variable xdp_tx_queue_count had remained the same.
> 
> After reverting that commit in the previous patch of this series, this
> also can be reverted since the error doesn't actually exist.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index 5b71f8a03a6d..e25c8f9d9ff4 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -915,8 +915,6 @@ int efx_set_channels(struct efx_nic *efx)
>  			}
>  		}
>  	}
> -	if (xdp_queue_number)
> -		efx->xdp_tx_queue_count = xdp_queue_number;
>  

Probably best to add in a WARN_ON[_ONCE] here to catch if these ever
 aren't already equal.  Or at least a netif_warn().

-ed
