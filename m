Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B9B633552
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiKVGai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiKVGah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:30:37 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F55C19C18
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:30:36 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q71so13231667pgq.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 22:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CC+f9UJ73buj9gyDwGhwuamBVlQIIX7fjpZcH4yy2OU=;
        b=VObR0t5gTd2cE/JCTW8P576XBXM9vIeyzUYjsNr8BerDlnaFbCd8Upw5k1NlDL5uPR
         7nU/t6usxXwcI61RyU33yeg89Z57fSIQTaPX51iX4CGDeunt1U2mbxJXmmVtrhU2YEBj
         FIyFFEZqYlPijS78TSLv0LF8XyPrLRSfVgdyfa7n7dYHHoZpuX8JoNVkJ7u30DoKxnD9
         WJIQNvwAIIhQUVRXDlnmvuCXENLBjpszhqIwJC1p88jKBLDUYsETJGtimhPe+eQaa+hY
         75K87HmJgOB4ZuF88jJy/Utk3MC6uGMit1vRzRWeetnv8MGenwrasRCHfAzvPFgoXZN0
         2jIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CC+f9UJ73buj9gyDwGhwuamBVlQIIX7fjpZcH4yy2OU=;
        b=cD8iOnTYfsUBTJCOyPyeI7Sm9XiPdkOgOcF1cjM+WfwNMYZI1R7BkZQBqE/QNzlNuF
         EORy+TFlTO1Wjo3oQ+CIsyAA8tJZvYuDQK854Gyn4MEVdolhx08/OPjsPFRw/L6APDCu
         H9+K6Tl8SGUj6bDYqohBmdhsTdr/85lbwwAxtDGnWP9GLNVyD7cI2bNsCmGmTd2sBGka
         xGnydwpzYecJj1y+lRDH9arr2yfyt3LWoI3XstsT7ax5qTxmjD1F+XH4RqDCwslIfPPS
         NP7KPxmr2910nq/80ELm8Q4rlvfIIC5/oA2mlAa0xmqov/fJ8o4d/ieb8VC5tyzvi4Jo
         rXrw==
X-Gm-Message-State: ANoB5plFy833rlgn/dqlFwNUSEy6Aw8mH4xXsp1OfDn5Z4ty016cYDij
        TCBRmszP88TUR08bKixXODPC4lKw+tGH2A==
X-Google-Smtp-Source: AA0mqf7CeiI7Xso7pEAugyaMGLUbN5jlEp+bX0G2KHs+dRh5DQjFpG5wZ8IkqIC0nL3Bn8IrMJ8CHA==
X-Received: by 2002:a65:6b87:0:b0:477:467f:3d68 with SMTP id d7-20020a656b87000000b00477467f3d68mr14154203pgw.610.1669098635970;
        Mon, 21 Nov 2022 22:30:35 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u5-20020a170903124500b00186c3afb49esm11022843plh.209.2022.11.21.22.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 22:30:34 -0800 (PST)
Date:   Tue, 22 Nov 2022 14:30:30 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [Need Help] tls selftest failed
Message-ID: <Y3xshtySEmcoh1su@Laptop-X1>
References: <Y3c9zMbKsR+tcLHk@Laptop-X1>
 <20221118081309.75cd2ae0@kernel.org>
 <Y3mcParyv6lpQbnk@Laptop-X1>
 <20221121093324.74fc794f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121093324.74fc794f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 09:33:24AM -0800, Jakub Kicinski wrote:
> > Value of CONFIG_NET_CLS_FLOWER is redefined by fragment
> > ./tools/testing/selftests/net/config:
> > Previous value: CONFIG_NET_CLS_FLOWER=y
> > New value: CONFIG_NET_CLS_FLOWER=m
> > ```
> 
> But these only list downgrades from =y to =m,
> none of them actually enable things.

There are some configs upgrades from m to y, e.g.

Value of CONFIG_NET_SCH_NETEM is redefined by fragment ./tools/testing/selftests/net/config:
Previous value: CONFIG_NET_SCH_NETEM=m
New value: CONFIG_NET_SCH_NETEM=y

>  
> > And in the config file[2], all the CONFIGs in selftests/net/config are
> > set correctly except CONFIG_CRYPTO_SM4. I saw in the config file it shows
> > 
> > # CONFIG_CRYPTO_SM4_GENERIC is not set
> > 
> > Is there any dependence for CONFIG_CRYPTO_SM4?
> 
> none that I can see:
> 
> config CRYPTO_SM4
>         tristate

Thanks for the info. There should has mis-configs somewhere. I will check it.

Hangbin
