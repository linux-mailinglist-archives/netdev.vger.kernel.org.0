Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF97D3FE14B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345758AbhIARlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345543AbhIARlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:41:00 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9159BC061575;
        Wed,  1 Sep 2021 10:40:03 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso245738wmb.2;
        Wed, 01 Sep 2021 10:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NwiEX4/BmUHjFjLm/pps/RMvagHoU8AMBDUAk6ldmoA=;
        b=XqttsRYNlYYkM99XNLfcCtTtSZ5/0zYjcvuvVsEJ8NRRrDHdiIsmRx1HmOpglU73Ha
         TyUch1MzJwDhPjWpjOss5Hm1kzwms3qYBfBlz2h0FSyzwdJhVArezy+quIx7QeFI8r1k
         Q14ABlDcTc0OQdeVeSb/ZEmJyD/EuuYq8kZmn2IA7Xg3B524PpLcI4mItpEXF8WXmI3b
         BidUOB03PeFecnHivH6QhzEni1pstRz3qskOjTiTPr79OKOQqWW/J7nBRbrkeeGoLSeq
         ZpDd/eqCB96rVMPFuVSrdggFiLvuPVI6NdseTFGqf0lK6v4RLCXwazGcgOha55P61L/p
         LgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NwiEX4/BmUHjFjLm/pps/RMvagHoU8AMBDUAk6ldmoA=;
        b=OwPZmM6Ig3Cu4A1jL/UbrpfkEeQdxdLixLnZjC10zTjO9KvjigZj4Cr3w6UwpEpp4T
         jz/rHSLbZTS9GQ9SoSmiQnwwBFSHuSW4ZEEaAB3QMOj8TshGGzhS3zkGZht+ndre4OBU
         Q8V/RNzcr3VxIMYnGv58jUKEwsWp5ZmISddc1lBpy/SLLokbTDOM0RwRq3Tj44NtqKZT
         tgZACsUhzNSXkW7m/U0jwvKuDcSor+6+jnRQOxRVuyQedb6ocmZTT4+4cv+Iarlov4xE
         Z9ExEuHB4B+TDtCHIC+yM8mfTt1LmHuakb1qPnE7MnSdqp68/jpBJt2aXr47bE4GgPjl
         RmPA==
X-Gm-Message-State: AOAM5315G3VpixgrNSXxWLZE8AlTjuMSbGjg9sE+vlTFNepaWOnFg6a2
        aIh171c8ZMDh3kwoxTmxsKvPhsOByD8=
X-Google-Smtp-Source: ABdhPJyanR3u0J1KdpUYbubSEoP0tYiXAY82tfxGC7QyoAaVGAjxr6KWybOhdcy81G006H+UCFJxqA==
X-Received: by 2002:a05:600c:a05:: with SMTP id z5mr585300wmp.73.1630518002158;
        Wed, 01 Sep 2021 10:40:02 -0700 (PDT)
Received: from debian64.daheim (p5b0d7864.dip0.t-ipconnect.de. [91.13.120.100])
        by smtp.gmail.com with ESMTPSA id k16sm96413wrx.87.2021.09.01.10.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 10:40:01 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95-RC2)
        (envelope-from <chunkeey@gmail.com>)
        id 1mLSLF-000Jxk-Pl;
        Wed, 01 Sep 2021 19:40:00 +0200
Subject: Re: [PATCH] p54: Remove obsolete comment
To:     Wan Jiabing <wanjiabing@vivo.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
References: <20210901024744.7013-1-wanjiabing@vivo.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <1ac57e49-30e0-3ca1-c324-3aea2aec598b@gmail.com>
Date:   Wed, 1 Sep 2021 19:40:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210901024744.7013-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/09/2021 04:47, Wan Jiabing wrote:
> In commit d249ff28b1d8 ("intersil: remove obsolete prism54 wireless driver"),
> prism54/isl_oid.h is deleted. The comment here is obsolete.
> 
Instead of removing said "obsolete" comment, why not copy the
excellent comment about that "frameburst technology" from the
prism54/isl_oid.h file there?

Cheers,
Christian


> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>   drivers/net/wireless/intersil/p54/fwio.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
> index bece14e4ff0d..1fe072de3e63 100644
> --- a/drivers/net/wireless/intersil/p54/fwio.c
> +++ b/drivers/net/wireless/intersil/p54/fwio.c
> @@ -583,7 +583,6 @@ int p54_set_edcf(struct p54_common *priv)
>   	rtd = 3 * priv->coverage_class;
>   	edcf->slottime += rtd;
>   	edcf->round_trip_delay = cpu_to_le16(rtd);
> -	/* (see prism54/isl_oid.h for further details) */
>   	edcf->frameburst = cpu_to_le16(0);
>   	edcf->flags = 0;
>   	memset(edcf->mapping, 0, sizeof(edcf->mapping));
> 

