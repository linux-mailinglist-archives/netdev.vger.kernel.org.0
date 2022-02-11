Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321F04B1EF7
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347513AbiBKHE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:04:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiBKHE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:04:27 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38689F4B
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:04:27 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id z1so8204599qto.3
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/fuJxEvQ8hWJBVA+YQn5WV9w4flp3A4j0tI4rSSd1Ck=;
        b=Rcy5r0adJeoSUyL7W/QR30JnXzvAAl0TOePsl9bc446MCcF4DzkEJe5x5/Z33B60K6
         twTFq+DI8oyZua4/XRcT3ZJPlOzSgC36NNVHvLnFgm594Sd6yy6/HezGz6+7x5/mGHPw
         2e9Rj++spx7sFDfgsE/2FjaGGH5pQEdGvJ+7filMlELC1sCqaQcD9Oygf/6vme8N8vDM
         rfkm7cw0yZUAtOv5cJ2aZSYogG8/CzATye+kB1PMb/0IIQaKRuBrgPw/Ky0v9BeBXW9k
         5CGxfdOa8eB01oM+tuQ6RKCb3mgs3RuRYzvtdC/JbjdHqVwSb8T/UtjJ2seMptjZeKDF
         ifaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/fuJxEvQ8hWJBVA+YQn5WV9w4flp3A4j0tI4rSSd1Ck=;
        b=ms3ZntWdqmS1HqlWAvDGbv+rw0hmxqkhbQZV4XuMoUYPh9PDj4c6S8T41z2CsMa7zn
         z/S6r0iIvi/fgt69ZPegFW5IMnTZRSq8MReNmShwwN3KZcGO7sFGkEIePGDnYgPe51R4
         NRmBRwhLkYbBqPpmGYAtPbDvEiK55pcWRA2NhjsMGgCkCO3DyBFqMpxBBVDuleTUzcHU
         9fzMhKinm0BML8I60gWnZlE3we3fKoSy38ecNai5fsKZhK9NvwmlREtF/4cuZM8KUfbT
         WifbeJLgKCmGZxIL3Dz8qeG9+pPOPOCAT0l7ylWAkq8HGstaTg3jC+riYY6+S9vRkDwD
         /0jg==
X-Gm-Message-State: AOAM5302s5teQ531dCQ+LilFah9MmpviETaTGYZhxxGTRhCnct0gPZ7d
        +q71japz4/Io6y4gGG02SHyPdbfTvLUcOfqxrco=
X-Google-Smtp-Source: ABdhPJxHMsdIWWCtwEZmNGQ6J3vOf4zLJeAy5aP7jJrVqIuaUV9a1OJK0qig7EPm094wmBFN+dYVWYgT/NVABnJsmI8=
X-Received: by 2002:a05:622a:214:: with SMTP id b20mr179876qtx.470.1644563066000;
 Thu, 10 Feb 2022 23:04:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6214:c87:0:0:0:0 with HTTP; Thu, 10 Feb 2022 23:04:25
 -0800 (PST)
Reply-To: danielseyba@yahoo.com
From:   Seyba Daniel <mr.sirdlin@gmail.com>
Date:   Fri, 11 Feb 2022 08:04:25 +0100
Message-ID: <CAE4PTYLQdg7FCMLN-Vvtckk+mYvqht28NmTZ+KLp58xaCT4eLA@mail.gmail.com>
Subject: Seyba Daniel
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it, which you will
be communicated in details upon response.

My dearest regards

Seyba Daniel
