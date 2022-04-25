Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B769550DA02
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 09:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiDYH0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 03:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiDYH0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 03:26:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F60F644C
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:23:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t6so16020802wra.4
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BJCkP/xDRhy8Vjb6ec+4qXNfdgzz+95k9BZ+z4XJQIg=;
        b=EMgQj4/qQv/4Ntaa7EM406CUhEurRLCE7f9YY5qpSyBk1dGJGYTbWhxjG/WiUiMNiF
         6Vdhbbs217J6GhOPnY7WDQaz6FlADFPtz7dWXKIYRNb4KxbA4VqEHRWaTCaAbFOCIg+K
         wanvHfX9MlC6OEsfyiYq3746PPiqlUitgZa8B3mwODw07Mnk19iw5ny2liYHs1sWCn7w
         wBuY47LeON4fBNLQae7PJmf6bpG0ScAtLVPoxQXQI+t7P/mb6OKgdPBeEVG0h4KmFeid
         62ml8kpLv+Gof6hTUW6F7dmutGlvrG7mVQbdZLj5GoZLCQ/S/g6uIJDFSOX+LOQAXxx0
         i9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=BJCkP/xDRhy8Vjb6ec+4qXNfdgzz+95k9BZ+z4XJQIg=;
        b=OtGeALR3o1oBhMaGueM19qAbQ/9CBYMqUOx63nGzkqXpOk7qO1Z6Yd5Py9LRV7A2hx
         9onXf5j/RcIGDe7+k2WDynAb4l8UUdP5MfUUb74L3T4qF4jJmq5yCylz1eu+cyiWmPMg
         5IDw7H5p+o9Dx6Aa1+Xrsq43ztp/QUV4/iCiN0999elvCO+oaoLiklYrqFXTKEbwAwy+
         NuFoMPW3h0ylzn6V3qguf6/Esy0hh5tnryzp+xQb9tHaIVUUy62DzEJmQ/3JJoxkEgI6
         3xkZ4eJ9w17FfTrW7UgrBhK0nn/k+p7i3xynosDROxMiLYe98NJCHuytrphcrYvguLMg
         gV5w==
X-Gm-Message-State: AOAM530EMD6kGvt/t8yCl8eUebf/jkbmLMA8PfykHsAKQIY7M+W0JQyM
        EmJg2LQ8LCijygGor//x2lzjQ1XmRdo=
X-Google-Smtp-Source: ABdhPJz6VAyMThOjIM6anKGOktDKiEYXZoyXc6xsF3MpSJmKFvNhislY0yEd98RiBK1rz/sTTW1SFA==
X-Received: by 2002:a5d:6ac4:0:b0:20a:dd04:81da with SMTP id u4-20020a5d6ac4000000b0020add0481damr2043456wrw.705.1650871379839;
        Mon, 25 Apr 2022 00:22:59 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id z6-20020a05600c0a0600b00393d831bf15sm5790592wmp.46.2022.04.25.00.22.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Apr 2022 00:22:59 -0700 (PDT)
Date:   Mon, 25 Apr 2022 08:22:57 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 03/28] sfc: Copy shared files needed for Siena
Message-ID: <20220425072257.sfsmelc42favw2th@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org, ecree.xilinx@gmail.com
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
 <165063946292.27138.5733728538967332821.stgit@palantir17.mph.net>
 <20220423065007.7a103878@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423065007.7a103878@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 06:50:07AM -0700, Jakub Kicinski wrote:
> On Fri, 22 Apr 2022 15:57:43 +0100 Martin Habets wrote:
> > From: Martin Habets <martinh@xilinx.com>
> > 
> > No changes are done, those will be done with subsequent commits.
> 
> This ginormous patch does not make it thru the mail systems.
> I'm guessing there is a (perfectly reasonable) 1MB limit somewhere.

I think the issue is with mcdi_pcol.h, which is 1.1MB of defines
generated from the hardware databases. It has grown slowely over the
years.
I'll split up this patch and see if I can manually cut down mcdi_pcol.h.

> I think you can also rework the series and combine the pure rename
> patches. Having the renames by header file does not substantially 
> help review.

Ok, will do. I do not want to make individual patches too big.

> Try to stay under the 15 patch limit.

I'll probably need 2 or 3 series, and it means our Siena NICs will
not work after the 1st series.

Thanks for your advice,
Martin

