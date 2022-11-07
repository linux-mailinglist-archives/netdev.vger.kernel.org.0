Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C771061FE76
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 20:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiKGTS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 14:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbiKGTS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 14:18:56 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089472A241
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 11:18:56 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id sc25so32743011ejc.12
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 11:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bp8XhHX8vCsgJ552WAvOupPjSfRXYVlDx8Jyt9KTX/M=;
        b=DKnLQL7zecQciSrRplmR4xGYAuQ3zQVhA5G+6VIUP0JY78uWpNcm0uBLMTJM/Yo9AO
         c2gPqXF9KeqQ4LV3MxmHmA0Ey+jPFyPjQxicpltzHt5c14UIYbh1zcbm88td8KQXiXur
         i0GUd++d6utvTqlrrCvR+SG4HB9SgjE2Q7VAsXcUlV6bnna5p/R+QBzri+0Yftk+ncPX
         K/QRAcauLG3SIcqOXDglh4H6Jv4aRUGTenJ/QIDNmksBw6ums34sEKtMwe3pA+rlyicX
         Ret7QGA6ZiTpnttfPKuH4MfKgNGr58Tfp8PmtHBRagA187jM9UV5rTRO1uCMsqPeVPR5
         j9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bp8XhHX8vCsgJ552WAvOupPjSfRXYVlDx8Jyt9KTX/M=;
        b=NqoS1VQsJ8oMTm4smQx6QS2rAwdaHfK/qY2otFyOd6e6giOm0cEfautSi6nBDiPzDr
         uZ4qy227ku5WRVRomh0i/ySjeONjy8fS7F8bFr+Lych08/5Nn2bMH1IbX8TYGkM/bXEm
         pB8RfiZRh8pFJ5uDKVdqoo+V8F932EjX9EJBq9a5v3EMxcfC3PwY7Cl+nVCCQz592R8V
         XZLu546okHE07g/2KpKRFQzzs4ol+AbwOLqQngoERT2FlI5g1rFsFRBK5XUQUdQ4aEEp
         bcMliWDckblg8oBJt/pzYXibLC57U+LEdh2PePt6WQv6dwKzJySEYDKj5UoKt4eeUSnu
         GT8A==
X-Gm-Message-State: ACrzQf1OljRTc8POGGMyjxlgL/mtgbn3qJFmR69LuZtCHbYyAzPKoTPC
        CDW8B6BXKMBusuqvyK5n/DIIlZxQ8GviOIyeYxY=
X-Google-Smtp-Source: AMsMyM4rI2JZ5+pAO02P0U62+Pkyo+p69wP6PzR5FLiiBbfiRy2C6DNt6mG/6RRUg4rFCx0e/7uLE74JYd0RUPdWRy4=
X-Received: by 2002:a17:906:f74b:b0:78d:95d8:f8db with SMTP id
 jp11-20020a170906f74b00b0078d95d8f8dbmr783339ejb.592.1667848734376; Mon, 07
 Nov 2022 11:18:54 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:c0a0:b0:25:e51c:221c with HTTP; Mon, 7 Nov 2022
 11:18:53 -0800 (PST)
From:   Chawla Manoj <attnahmed2@gmail.com>
Date:   Tue, 8 Nov 2022 03:18:53 +0800
Message-ID: <CAF2fbXaA7bjfN0Z+LsgxE7YnRNAH3uYAj=eEkYmtbrNaMyFung@mail.gmail.com>
Subject: DNDNNNN
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello

My name is Chawla Manoj, a banker with Emirate NBD Dubai,
I want to seek your approval to share some information with you about
a deal of which I believe will interest you.

please kindly let me know if you are interested for more details
about the deal.

Sincere

Chawla Manoj
