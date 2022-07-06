Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81436567D6C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 06:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiGFEkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 00:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiGFEkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 00:40:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D8D1A066;
        Tue,  5 Jul 2022 21:40:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 5so6808514plk.9;
        Tue, 05 Jul 2022 21:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=MmGKj54ODJwT6pO3OF9R2vigv1fqrjl9CeJkcF+q9NE=;
        b=CS79o7J9ryZ//VukOBRpaE6u6vgZ3bTyZH60br5FtZOz4bCv5olHo/sh12UyHQ8eBW
         wQ7ptNfdUbW/vLlQ0kRRhoX2R4cjt7goOCRxN8/dROYiOkfaMrK8vbquoK9phHx6IaQm
         cEDPmupxo+om0MN3ExmyC0GxiLfxG2M190TCjpBCcaTGKeQWiUqUVmRknQNggas8kl5X
         HZsFYkJ8wz38BXLxASIbhGDcCQORkmyCb2pZoojlfPG0HKKIOrPQePg9ngTU5QE89t+k
         R3JvmO4+24n+f8Fwxsyt73B0yzmA1BL84xd43rt3EsqKMFYYSsVxtiWL2mHb24jvPMQa
         0DOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MmGKj54ODJwT6pO3OF9R2vigv1fqrjl9CeJkcF+q9NE=;
        b=aph2LIGCc7kXBXvKiGBQkMwTiJlKH+pr05JGu384VZQx8OOzEhZN0kUFh7x45MxuEb
         aNuesW/0eQuZUX2rCcVgtnfyoIeN+ofR12GO6D+UCWPHX4lKjUcA+nVvp8GYKhmdzwbs
         paz1iG2ykze2felH2hSEe/iXnWgvevseZ6aHuWZfURS/lpwFwiJYZ8rykY81OQeR5mhg
         9FIrYUpoB6ox8TueiUC5m2WaDWiOhoe8XCMzvNvjdyV/bgHK4tLH1+W1O2v8FhozoRyv
         YOEcF5IJ3DkkVweBi0nu74vTtWxHki/Ln/5I3cwax1QbmOar1VXhhxg5Md2ybSxjHjDT
         WGwQ==
X-Gm-Message-State: AJIora8D4GF2UIBBqT7dnO85aGCB1VR3i67KjDMa+iXMb8Ch3JICXWBT
        9KWCL8Rthi1rXxRyYOrD3wY=
X-Google-Smtp-Source: AGRyM1tieaTsoRAO3fDcSy5lTYAoX9FIh0gFukpAwlA88ScTHgRmFHR3jbFKf/3bMWxsVAlAHK1QpA==
X-Received: by 2002:a17:902:7587:b0:16b:cb53:4463 with SMTP id j7-20020a170902758700b0016bcb534463mr22830120pll.92.1657082433762;
        Tue, 05 Jul 2022 21:40:33 -0700 (PDT)
Received: from [172.25.58.87] ([203.246.171.161])
        by smtp.gmail.com with ESMTPSA id s11-20020a17090a440b00b001ecb28cfbfesm15960664pjg.51.2022.07.05.21.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 21:40:33 -0700 (PDT)
Message-ID: <fde90f42-6ad0-ead2-3d10-6a37dbbd708e@gmail.com>
Date:   Wed, 6 Jul 2022 13:40:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] amt: remove unnecessary type castings
To:     Yu Zhe <yuzhe@nfschina.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com
References: <20220706011449.11269-1-yuzhe@nfschina.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220706011449.11269-1-yuzhe@nfschina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu,
Thanks for your work!

2022. 7. 6. 오전 10:14에 Yu Zhe 이(가) 쓴 글:
 > remove unnecessary void* type castings.
 >
 > Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
 > ---
 >   drivers/net/amt.c | 4 ++--
 >   1 file changed, 2 insertions(+), 2 deletions(-)
 >
 > diff --git a/drivers/net/amt.c b/drivers/net/amt.c
 > index be2719a3ba70..6b4402c26206 100644
 > --- a/drivers/net/amt.c
 > +++ b/drivers/net/amt.c
 > @@ -1373,11 +1373,11 @@ static void amt_add_srcs(struct amt_dev *amt, 
struct amt_tunnel_list *tunnel,
 >   	int i;
 >
 >   	if (!v6) {
 > -		igmp_grec = (struct igmpv3_grec *)grec;
 > +		igmp_grec = grec;
 >   		nsrcs = ntohs(igmp_grec->grec_nsrcs);
 >   	} else {
 >   #if IS_ENABLED(CONFIG_IPV6)
 > -		mld_grec = (struct mld2_grec *)grec;
 > +		mld_grec = grec;
 >   		nsrcs = ntohs(mld_grec->grec_nsrcs);
 >   #else
 >   	return;

You already sent the same patch[1] and it is merged[2], it can't be applied.

[1] https://marc.info/?l=linux-netdev&m=165577785300445&w=2
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/drivers/net/amt.c?id=d13a3205a7175d673d5080ddf155dc69aad6085c

Thanks a lot!
Taehee Yoo
