Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4E5A2898
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344027AbiHZNbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbiHZNbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:31:15 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CFEDC099
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 06:31:13 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3376851fe13so36090047b3.6
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 06:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=j+uJ1+KwQjMpdNiCngwvlv2FTzZnzkokoCYASnN36NE=;
        b=MrUDDIPQGYviOs2nHH+CAmkxGWS8epYiTqw+8i75YgZh3dtxEunYsh8HiJZrjwxcbw
         A2jW3y/YyD4eAadyHwhr1NFBlu2QnnxVjLtKdaysVH1GUJyF6wxkwUY4UsJuyX+o+/+8
         +9qe6Rk2+8mtSr6bQvSMM570nnL4tSrmv0hKNH2l8AjY36Qkn9sEJd3oFLLwz1iL4+Bl
         vgWh+gAy+/8Qvq84MoY+WNxr2bzS2LGasxRs6nIQF6ZPNdVf4VsxlLb6WZS7wx0bL9gD
         UkjgGNJ1I5Q3Qe08f66+1qi+/W2MU7b65Oo5lEVUd6iNfU0j5VwY96Le1No2k4rx5lrX
         kerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=j+uJ1+KwQjMpdNiCngwvlv2FTzZnzkokoCYASnN36NE=;
        b=zERFUFEafKLVtDvKZ2Y5c8u7USDq2J3j03iNuZhq6aTJybYhS9sAV9BXacmTRjZHMk
         0FraoiZZ7l3KXT/jWrpIHwWHDOwNbPJDJcn+54zESqWFVdVUxsSxdsUmeiM7y3Yq6EU+
         NVeEN532Lgl5gbraLlq/NkvsvUS4WcjcDjXhLTQWBlXJSqHb5bNM9v/c/3/TLrc6Rqje
         xQVgB+2+8F473TYCt4AZjdn3v75aBoshho8z+84oj2TD6UXCiThC9qPct0RtUcKID1N2
         dIi37AzirmxgehksdEGWMghkw4kkCyeHNUHyoQhuGAhp/4HrMCErFI+5pe++G+LXeU4u
         Ytcw==
X-Gm-Message-State: ACgBeo3tZIzdQTfpoLUagBAxhZh74ufIkxDIBEdFnN59bM2Hy8tCxlbx
        CN+7yu3lrv8C1Uvg8kWUjbIPEcvt1kqiTAeFjB4=
X-Google-Smtp-Source: AA6agR5gWYyEQ3Z8I17SWy2s/OTWyM77dHZFIK/SCpKMDxeM5O3ohNoIIlyLTNVCHEicSaCNcw2KcIiZGpHZJk3a/38=
X-Received: by 2002:a0d:cb0a:0:b0:337:1dbc:4c21 with SMTP id
 n10-20020a0dcb0a000000b003371dbc4c21mr8643940ywd.297.1661520672994; Fri, 26
 Aug 2022 06:31:12 -0700 (PDT)
MIME-Version: 1.0
From:   Kofi Richard <kofirichard901@gmail.com>
Date:   Fri, 26 Aug 2022 13:30:59 +0000
Message-ID: <CAM0oKDs8XMBL7weyXL8srNk5o9CWfe24inaq+s6jnOvcpATDQg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi
