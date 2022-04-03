Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A2D4F0D11
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 01:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376748AbiDCXwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 19:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376738AbiDCXww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 19:52:52 -0400
Received: from mail-yw1-x1144.google.com (mail-yw1-x1144.google.com [IPv6:2607:f8b0:4864:20::1144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098A03878E
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 16:50:57 -0700 (PDT)
Received: by mail-yw1-x1144.google.com with SMTP id 00721157ae682-2eb680211d9so12040497b3.9
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 16:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=XsschJcLfC39ayLiVt/DNcvB/JlWwZ35CFIHFiyvyxI=;
        b=bVH09nzYzUdCOVSXvNaRGJvy+yf3KS5wazHziOer6XiwF2fCUpT1+rwkuEjjhyP6fc
         /YM6KEI8/8srXyhlTGZHCgMqtDUCFhwLdx6FO3Eues5Cy+dejRETPL0gh7+gvLPFadvV
         3fjMUfKdhbw9Fl/r/JfWdmaLVBxF8Y/o0n4oQDmegtHY9zjLeSEHJX87DE++TKxXFyIA
         P+R0JYefbExGGHBFfVEC/paeaYcSp6E8vhiFYua5/mSLC4ZPsMHEQM16xfbnhFMJK6Tc
         HOvky0Rzb2nqOMRIvu7g+mbPv9XfDFuGyXi4s8dLPYyQd44RL8m4Xqhkmg527tbtD9Mm
         9Hkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=XsschJcLfC39ayLiVt/DNcvB/JlWwZ35CFIHFiyvyxI=;
        b=bvDH7xjbxCykUnXTNJT03fxSLrC8nPgn2/8jYgBTVxQAi+WTt+td7serwAJSWigCaP
         vTwvJSVgq4hrPQhDNwRfG6UCKCrYeVLlSiGOizIAvgdELJYPQi4nsmN88crPUJgYdI3X
         I/hwChUDptkmr8h4unRipQU9y6w1PMqgEdnK+wxVtqEEzDljTJiGFM7EGogHXT7TcbGs
         nTiUWLwo/ubu1wTdXmFq8U1uA7cYCzWNz0A1n/8UV4JaDjXQaGMbcuNsLWnML4Ks4SLY
         ChODechLcVAZo3f6xQPBTJyi3gDgv2xp3FheLccBP5FK0pT+ZZN33L/dZgKt4t4BEQ+c
         M3gA==
X-Gm-Message-State: AOAM531VutZ7raubvilU0TdvWHjIZ49lcrXCrLQzxKWUN/VZt+DnP/ys
        ynNnkgFzk/DK6H7ytpJwTb67Poq5r0pzMq1rivM=
X-Google-Smtp-Source: ABdhPJwocRQDGtSkuF8llXHBrTqBzTKgYOzf4B0ShGcemhN4uSbeHj/l1wvFq66C0HTp52mnV7i+eJNYTXX84re2HcA=
X-Received: by 2002:a81:f201:0:b0:2d6:954c:f463 with SMTP id
 i1-20020a81f201000000b002d6954cf463mr20356131ywm.168.1649029856162; Sun, 03
 Apr 2022 16:50:56 -0700 (PDT)
MIME-Version: 1.0
Sender: bihalo1234tay@gmail.com
Received: by 2002:a05:7110:904f:b0:173:9a41:7543 with HTTP; Sun, 3 Apr 2022
 16:50:55 -0700 (PDT)
From:   Madi Zongo <zmadizongo@gmail.com>
Date:   Mon, 4 Apr 2022 00:50:55 +0100
X-Google-Sender-Auth: WbJVR942TcNAw1dGVT3hyLg5C0g
Message-ID: <CAM8HdsM_1o7dow3WrkGbqHnb57N1D3RHxk+mbx3Lwg8AdZsuPw@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear friend,

My name is Madi Zongo, a banker in one of the banks in my country here
called Burkina Faso. I have the sum of $27,2 Million for transfer
which i need your help.  If you are interested, please reply me
urgently for more details. Contact me via Email: zmadizongo@gmail.com

Thanks and best Regards.
