Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D67B428035
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 11:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhJJJ3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 05:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhJJJ3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 05:29:49 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48D6C061570;
        Sun, 10 Oct 2021 02:27:50 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y15so59641820lfk.7;
        Sun, 10 Oct 2021 02:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jhLHHKsRgIXRKbK8ZViv7DyxamZZkr1nUmJCQZHRsrs=;
        b=J3k59v9AtUgSRC7sm9DECTeY1RHurohsR9nQBbucTmQux536UKwBjSZh3rrFwxZf5L
         FaipH4EOdRLbHbfjHOJofBehEAkD4QNfdZsMTQxfF/7pG2TIzBBgo/01oBn8YvsaibXm
         Uqs/kzbFl+so8TMe4X3ihO6UVcjM2z/hePmk806M4xC0PUnMzAAdhdraUwZCTzfOREZY
         jVstOY5BNGiZrHEg3jw+wr4HQr1fKaAipxm9zwVM8VP8mFQUa2BwwcafGj+T+hGPWP3w
         OAwUFEQvtDzWIrNcLiIkiTqkEhkc0BZLc+aqtCAYYmJ5++cNYbbNddSp3x/MJeVWM0Fx
         YEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jhLHHKsRgIXRKbK8ZViv7DyxamZZkr1nUmJCQZHRsrs=;
        b=Mu9tZENEo29b67nePrkm8gZ7ziwiQ3jqZiyFdxZh0tAO7zXebr487Y/8Na4g7NErTp
         sTjR3I58/sjfsnz28/1PCox+kjnJZnvxwLuYkE76N4z++aLV8YmBFSI+hBDqrjDxLpPv
         JKafVjo3sbnBfRqeBAOY5ZefvYYU6JhbhRI9TZguLo+pQHOdnaMwZ7jAL1uWaWeF/5BU
         lRtafNqVJk+TXXdZwFGv/end/Zt+JpATl8MjiwjtG3FRT+cc8HS6cTLlKv/ctjDak6di
         GS8pOC/gRrUThhgy4ltoXLIvJAHLPxDcLX9FLBE35cbbpwnKG8S4Bnge4cGa6Q6fgYoa
         Lxow==
X-Gm-Message-State: AOAM531lSHneschQo09bLVoNWrlZIC/UPydjhRuk2H2IYulCNfZ2d2PP
        yjbbpjBMwAtDmSGYuv34VP8=
X-Google-Smtp-Source: ABdhPJxbX2v8MJcxFMTahq3Do2RU5w/nx1MjijBe7XZPCiHDOioTjLDBPV2HXO8z8LLN9uh/CO9P6w==
X-Received: by 2002:a2e:b60b:: with SMTP id r11mr14982897ljn.30.1633858067044;
        Sun, 10 Oct 2021 02:27:47 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.85.147])
        by smtp.gmail.com with ESMTPSA id q15sm29738lfm.276.2021.10.10.02.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 02:27:46 -0700 (PDT)
Subject: Re: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
Date:   Sun, 10 Oct 2021 12:27:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2021 10:29, Biju Das wrote:

> Update EMAC configuration mode comment from "PAUSE prohibition"
> to "EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through;
> Promiscuous".
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> ---
> v1->v2:
>   * No change
> V1:
>   * New patch.
> ---
>   drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 9a770a05c017..b78aca235c37 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -519,7 +519,7 @@ static void ravb_emac_init_gbeth(struct net_device *ndev)
>   	/* Receive frame limit set register */
>   	ravb_write(ndev, GBETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
>   
> -	/* PAUSE prohibition */
> +	/* EMAC Mode: PAUSE prohibition; Duplex; TX; RX; CRC Pass Through; Promiscuous */

    Promiscuous mode, really? Why?!

>   	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
>   			 ECMR_TE | ECMR_RE | ECMR_RCPT |
>   			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);

MBR, Sergey
