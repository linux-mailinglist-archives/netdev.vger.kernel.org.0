Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309B652B8F0
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiERLdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiERLdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:33:24 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E4A5C878;
        Wed, 18 May 2022 04:33:20 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i40so2584758eda.7;
        Wed, 18 May 2022 04:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gJ3rsnwq2b/rwZyiM+K6St2dD//MHaJRGiRZ+2rN6jw=;
        b=boSZSG16VTmcUf9r+ZEJo1bDXBXu800Ay6RdbxwGTxtnWhZtEKXO1kS/q9r6t4Tbci
         qL3ppu4OcqJi0yGfUQ8PEQXAM37v19+vWyt/KkmPyWYi6F0LLZnjXPCGdz/3bKRQkXZT
         lacgus8QOEdvO43y/iK1HshJzwZ7xXyaUplatLnYfmn6pXxRT82uMM4Ni2/WHTR2II8K
         ALtwTOzMDdk6fjrCaMfZyt2H6ggyBkfLPti/+alKhAF/HQkLqC1+TCdXR0w9sBbi7H1e
         1GE0pCaRFMH3c9+2fLt8NFmnwIkMfkpwnJWn/kpqhAWWfbEdxxxPjRoOzTV/7SuTb4wQ
         SHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gJ3rsnwq2b/rwZyiM+K6St2dD//MHaJRGiRZ+2rN6jw=;
        b=buWKwSzrfJUXVJQ5jCuzZn3JGe3F6f+ajsWYfur5yGEyavNFP+JXdEwKBEps+kOxw9
         X4gI12v03touR18QQmmv6e2WJqDegjLZJ8H3IdJrqqCOJPXS7IoszjmUm97i8JREzUWe
         LDxxrG2DU1wvUdQsaynZ/Jqd5CUqX3KpMdA/LpiqkuMQ1RBJqXS4hGmonFdtHo3GCENi
         LZsO+CcdrBzQOnCQy9cy+EP+H5P7njGMXwxYYNaSWdJfTh1o30RbEUWvQsLSu+0LCs25
         f+4vH//BDp0nnUYorBTj186o6pZo+YKD9JLgxkuSU1C1Rxu0zc5QvwYDJfrliUBuvgH2
         S0RA==
X-Gm-Message-State: AOAM532EHBsDkXMqEt+Uoe16kOJ32QISUgnmWntyS+uvpmtggXKizjLg
        ytfQQ2DX9mdCKesglhXwsi0=
X-Google-Smtp-Source: ABdhPJyxtALu03Yuzdg/AfJ0FAnnybpgKbzcjrKmwL/9vAr2Byxm+xGrgpvROIgpruNaQz1AgwGHxA==
X-Received: by 2002:a05:6402:741:b0:42a:8fad:8f67 with SMTP id p1-20020a056402074100b0042a8fad8f67mr21895251edy.285.1652873599246;
        Wed, 18 May 2022 04:33:19 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id d19-20020a1709067a1300b006f3ef214e05sm852697ejo.107.2022.05.18.04.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 04:33:18 -0700 (PDT)
Date:   Wed, 18 May 2022 14:33:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH net v1 2/2] net: dsa: lantiq_gswip: Fix typo in
 gswip_port_fdb_dump() error print
Message-ID: <20220518113315.w3p6vzj3djat2abd@skbuf>
References: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
 <20220517194015.1081632-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517194015.1081632-3-martin.blumenstingl@googlemail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:40:15PM +0200, Martin Blumenstingl wrote:
> gswip_port_fdb_dump() reads the MAC bridge entries. The error message
> should say "failed to read mac bridge entry". While here, also add the
> index to the error print so humans can get to the cause of the problem
> easier.
> 
> Fixes: 58c59ef9e930c4 ("net: dsa: lantiq: Add Forwarding Database access")
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/lantiq_gswip.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 0c313db23451..8af4def38a98 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1426,8 +1426,9 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
>  
>  		err = gswip_pce_table_entry_read(priv, &mac_bridge);
>  		if (err) {
> -			dev_err(priv->dev, "failed to write mac bridge: %d\n",
> -				err);
> +			dev_err(priv->dev,
> +				"failed to read mac bridge entry %d: %d\n",
> +				i, err);
>  			return err;
>  		}
>  
> -- 
> 2.36.1
> 
