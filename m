Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B6A500320
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 02:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiDNArQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 20:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237899AbiDNArP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 20:47:15 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0142F2BB0F
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:44:52 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id i8-20020a4a6f48000000b00324ada4b9d9so622372oof.11
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BWRPMUEOpkJyZVrX2rJiheDu07QMGGykV+FBRoYqbGU=;
        b=jVTh2fZ3JUDNGI05iBWQfbpUzztbORrNvrzX9GWRjSS2DnojRyNmVQpRaZXYai7Dyb
         uMFP8005+sK93Kpq14+hdq6hA8aX9vJ631RUvteLK3f8DriL7jpYaXngJ7GN/HIvueLT
         IPLFtZJxujZdj5cqht+ald+VncMOaKXMqv+dWJ91SxbsnN6548X0DeMu1zqtQEOJ5t/F
         iP5t4fU3uGlSMl7nKI3o4yoNA0AatYm/ZBSZ+tlCUv2xSus9OwyzAUDTj7rCJZcvfURO
         Qsi5Vbn8/1V1bCK1wN+/Kjc52a5FeqmA93jyf8mTbEtqvLhD0k8516IfGK9ycOOonUBh
         z5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BWRPMUEOpkJyZVrX2rJiheDu07QMGGykV+FBRoYqbGU=;
        b=Ai2FgQqWIdIJix2SRl3sIJUW5QDo6SGnLZpkdH4LbGoLv6TPbmnX41usNcP7QkgG9D
         iRAyWTUHHiCef/koSv14uKnR0QguSrQBrgHv2dnJGAM2GeYIRJpX7bg4OY9AomM1doo7
         xW00GZz6l26lOsuA8hLOOV+yLrwr2gBUko59tJoEKavQMXy7XAlOnq+AjMxdLsyePVhc
         JcviY9Lm+uj4i2HvgyT1PH8fAENImq6zmNx4RziTg0TLVdDSysvWhMBAanaEI6JkTcyr
         CCk2NtjI49Uovbt7pBz2EzY1BOBAsw25//jj0vruPVUb/Vn4PMhRr3qWs7DLD3ofd9NQ
         wQ1w==
X-Gm-Message-State: AOAM5320dXTMdgO3X4A1E1ZvJt2s4RPkV8lHGPbOms5u9t+IVY7ZL76s
        b0ww8dirSf7BUUmku9RzQE0=
X-Google-Smtp-Source: ABdhPJx07pFJAOHDzKhsN5LxbL+WUYpSQFpGEVrJZtHY1R1j68tFO6CYacpmnrKMulZQJ60WxZj+bw==
X-Received: by 2002:a4a:6b49:0:b0:329:99cd:4fb8 with SMTP id h9-20020a4a6b49000000b0032999cd4fb8mr91437oof.25.1649897092352;
        Wed, 13 Apr 2022 17:44:52 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.69])
        by smtp.googlemail.com with ESMTPSA id r129-20020acac187000000b002ef358c6e0esm196486oif.49.2022.04.13.17.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 17:44:51 -0700 (PDT)
Message-ID: <ed68e688-0157-51a6-d6d0-5b66735343a1@gmail.com>
Date:   Wed, 13 Apr 2022 18:44:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH iproute2-next] iplink: bond_slave: add per port prio
 support
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <20220412041737.2410062-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220412041737.2410062-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/22 10:17 PM, Hangbin Liu wrote:
> diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
> index d488aaab..7a4d89ff 100644
> --- a/ip/iplink_bond_slave.c
> +++ b/ip/iplink_bond_slave.c
> @@ -19,7 +19,7 @@
>  
>  static void print_explain(FILE *f)
>  {
> -	fprintf(f, "Usage: ... bond_slave [ queue_id ID ]\n");
> +	fprintf(f, "Usage: ... bond_slave [ queue_id ID ] [ prio PRIORITY ]\n");
>  }
>  
>  static void explain(void)
> @@ -120,6 +120,12 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
>  			  "queue_id %d ",
>  			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_QUEUE_ID]));
>  
> +	if (tb[IFLA_BOND_SLAVE_PRIO])
> +		print_int(PRINT_ANY,
> +			  "prio",
> +			  "prio %d ",

those last 2 lines can go on the first.

Also, seems like a man page should be updated as well.


