Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5815431DB
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbiFHNrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 09:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240483AbiFHNrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 09:47:32 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DFF1D8197
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 06:47:30 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f65so8733909pgc.7
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 06:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=5qhdiuPG2azU5M0qVLOQEvO3YubHAplKI2SWdC6ZWiw=;
        b=O2i8zWNilgdd5hJYHu6mfsgeaUtZo+TcUgO++G5UHrQs3LVSj4zEre+sh4CdmmeVnR
         sGnYXIeoDEw6Is5nIFK9Q4jd6MtTJUAYsF7VWwngCESQkgztBP2gkk/BS/eM0rGWNGST
         GBy4MneSJgIxeCSC+f2S5mhiwDAuvRa9c22vHD4J/6dDyUVGeexvA3WxMCkJKx8QoeSd
         OSm2kaP71tmosHZXvCQKIQRNmNq4O+odwoVF43sa+rfx7NEcwiAnXYAgf4hbBP2tlyBO
         w7Seh8IxD53MoEVoLAu/z7sPDEWFKCh2hSf76X8Xf7KMbe2LfWVhjr3lxDwqrcWqhVax
         X6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=5qhdiuPG2azU5M0qVLOQEvO3YubHAplKI2SWdC6ZWiw=;
        b=hn/6TZWR+OjlFOAj2c22qb4LWRU7WrQLo1Fp3A6OE3fpun6meUNNEUq42fMnppjNP9
         NaEfBExU5kSwuSydd1149TXT36R8x7NppI6jUTndHjThtJRX+TPqB0Fwy5kcRmw1zSC7
         8ka/UCF32f3wPqQlk1z7jelkiw6BnMEmoXEDQPKQy4V7oJe1PgBiSbqOBCVIq+yw4m78
         7GqqISyDm6bHczrhNuREnPEnQrhtlo3elLCQUYWuA71FaypmYDH0DqrPPIAu9aOU60tJ
         psFoVmXk3+WmSd1uZ7sb3S+RHchiTXoORrAVm03l48HPd2jMp5bv6ZevjGJkTbJsF+HC
         zOtQ==
X-Gm-Message-State: AOAM5325uUb0dDNbELO4kv0VFdT5RAuuIY646yEAWw9CVWNmMEPFVl50
        irkyynuL5RNxFk7xEXgnHbKWylgblIs0m2hofPI=
X-Google-Smtp-Source: ABdhPJywpRbYZmFmyuQZsoHUqk0kQgnzo/5wNwicaaBEe8xkq3+Uuz27wnDz+OmV/RmMzk+W3C9Hlk92tdTCpwRlQtE=
X-Received: by 2002:a63:1d46:0:b0:3fd:df71:dac0 with SMTP id
 d6-20020a631d46000000b003fddf71dac0mr11229696pgm.258.1654696050505; Wed, 08
 Jun 2022 06:47:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:4f49:0:0:0:0 with HTTP; Wed, 8 Jun 2022 06:47:29
 -0700 (PDT)
Reply-To: jessthwaiteandjoe@gmail.com
From:   "Jess & Joe Thwaite" <giftbasseyibor@gmail.com>
Date:   Wed, 8 Jun 2022 06:47:29 -0700
Message-ID: <CA+SUxHAYmJ8=vtfnHF4H+ctimjqUu7R5uzb4QLT9_HN0+KXWvQ@mail.gmail.com>
Subject: Reply
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

I have an urgent matter to discuss with you that needs your immediate
attention and response. Reply now for MORE details

Best wishes
Jess & Joe Thwaite
