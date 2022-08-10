Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E147358F33E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiHJTf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiHJTfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:35:24 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A4E5E30B
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:35:24 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b133so14597574pfb.6
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc;
        bh=6Mc3gKxwEhpxdHcItH8dFoEyMQ24jgfep9WWzG4wE7A=;
        b=iwNgGojXj4wRRvNnA+Fa34PJiTs3uOBt3jJmPBo4vIz6WoR2ecowtxguNvjxMN5Hck
         s27daNV3IBrDfPvQt6/CMMELbAG/klvOZFApcJxQSMyNUpFrimLZ77otysCF1En31PG3
         IvaAdq2t+9ixJuHGm/NZXNYv9iul6is46XVZS0NCgQ3vaaEx2n0McuPpXRqUOAktidLu
         laes+vFXadYt5Spmn/WOGZDpap6EHNH0FfOcJgf9Rom3qoJCodXK2FYz2+jLd7aTGvLV
         o+GCVSRFxQw+qkjF41m67slVGovGFWYN3SYDQTzfXgXhItpAqSI+Gg8qUF6Q4MwZYWEc
         He2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=6Mc3gKxwEhpxdHcItH8dFoEyMQ24jgfep9WWzG4wE7A=;
        b=sUJkaqMN0tDFsG4kfVirTT0hEGque1NMhSuzDTwHN2ylJgdFJk8f5CN03mRU7e5TeM
         v3RCPatyuGnGpATCzjQDv7IT2Lt8Srmdsp1KCClRv5pnTQ1JoSb5phauJBRnGRjK5plP
         T1ug4qw2bY2ge1y6G0Uyh/lQaqE5fcWOncvEjpS9iLvW0BfAyBVSw5vplTrXi2jSEowc
         oYMBGI2A1MhQKiYiQrJipn1eAm1jxXeIi4DtH9YuaWcOp4bc8FV1btYTncTqCFlHTYqP
         FzFoNob2ef5pHbZsOdl9rMI9iIWX/jE3BNLdZnna4D6vok0N3uj9JWh35qc9YlZLG9Zc
         xAOw==
X-Gm-Message-State: ACgBeo0oxpOLdhsTQ95GkYcSXVzK3KyEzSNzBFFr6/uHynS2Rp6qqKXT
        PSB0QmbmzgA60fqHmwboSn8=
X-Google-Smtp-Source: AA6agR5aCkNsZ/IMRyS/3v/jXysxMgvWg8XFADrqU7rUIyd8dLy8Lp4BKjFASNLZ36saBAI0YM+8TQ==
X-Received: by 2002:a65:490e:0:b0:41c:5b91:e845 with SMTP id p14-20020a65490e000000b0041c5b91e845mr23787783pgs.436.1660160123589;
        Wed, 10 Aug 2022 12:35:23 -0700 (PDT)
Received: from [192.168.254.16] ([50.39.168.145])
        by smtp.gmail.com with ESMTPSA id e11-20020a17090301cb00b0016db6bd77f4sm13605681plh.117.2022.08.10.12.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 12:35:22 -0700 (PDT)
Message-ID: <fe56af9da1bcca86ab8750bcadea4da7bfc768e4.camel@gmail.com>
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
From:   James Prestwood <prestwoj@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Wed, 10 Aug 2022 12:35:22 -0700
In-Reply-To: <9ec77cf1ffaa29aedd57c29ac77b525d0e700acf.camel@sipsolutions.net>
References: <20220804174307.448527-1-prestwoj@gmail.com>
         <20220804174307.448527-2-prestwoj@gmail.com>
         <20220804114342.71d2cff0@kernel.org>
         <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
         <f03b4330c7e9d131d9ad198900a3370de4508304.camel@gmail.com>
         <0fc27b144ca3adb4ff6b3057f2654040392ef2d8.camel@sipsolutions.net>
         <d585f719af13d7a7194e7cb734c5a7446954bf01.camel@gmail.com>
         <9ec77cf1ffaa29aedd57c29ac77b525d0e700acf.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On Wed, 2022-08-10 at 19:17 +0200, Johannes Berg wrote:
> On Wed, 2022-08-10 at 09:26 -0700, James Prestwood wrote:
> > 
> > Ok, so this is how I originally did it in those old patches:
> > 
> > https://lore.kernel.org/linux-wireless/20190913195908.7871-2-prestwoj@gmail.com/
> > 
> > i.e. remove_interface, change the mac, add_interface. 
> 
> Hah, I didn't even remember that ... sorry.

No worries, it was a long time ago.

> 
> > But before I revive those I want to make sure a flag can be
> > advertised
> > to userspace e.g. NL80211_EXT_FEATURE_LIVE_ADDRESS_CHANGE. (or
> > POWERED). Since this was the reason the patches got dropped in the
> > first place.
> > 
> 
> Well it seems that my objection then was basically that you have a
> feature flag in nl80211, but it affects an RT netlink operation ...
> which is a bit strange.
> 
> Thinking about that now, maybe it's not _that_ bad? Especially given
> that "live" can mean different things (as discussed here), and for
> wireless that doesn't necessarily mean IFF_UP, but rather something
> like
> "IFF_UP + not active".
> 
> Jakub, what do you think?
> 
> 
> (I'll also note you also have error handling problems in your patch,
> so
> if/when you revive, please take a look at handling errors from add
> and
> remove interface. Also indentation, and a comment on station/p2p-
> client
> might be good, and the scanning check is wrong, can check scan_sdata
> regardless of the iftype.)

Yep, I'll get that fixed up for v2.

Thanks,
James
> 
> johannes


