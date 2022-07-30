Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18133585B52
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiG3RD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 13:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiG3RD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 13:03:26 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A6213EBB
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 10:03:25 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id v185so5617859ioe.11
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 10:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=dLVcL6nafMxW7HU388c5QP7uLuUNlVX3AXiksId/cY8=;
        b=jPXbk6FCDP9Vkqzd1AJyJ1lw9Ha/jR9fHNlFuLR70Yhh2il8TZ+mBbITh04QD5skxi
         Z3/EPgz5VUJVac2DYk8XkaH70M5IUyKS0UgPfnk7iyIPsZc2v1TGfm5oz2sfhho0g8jr
         b3lH30JEdKU/BPL0nJzzMNxpEiwmmgfiX3poAidAtrxfXAxur/Y4n2L296y/ZJen33is
         XVH4kPeLLKsKVf4t/GaplR+EPhIfycum+3zCSkrDzoAer3uTKEhb6dXui77n9tp5reNq
         ePsG8hxPMy0cLI1r8kH2m+cgCJa3CSp6OI2BTYcOV77e43W2PGb0Sey16DqZrXhZZ3rn
         fJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dLVcL6nafMxW7HU388c5QP7uLuUNlVX3AXiksId/cY8=;
        b=Mn0ZrBr/8NUIKU7UnVG1pQ+2ZmDHsfB3Hw7yltbY84lEXYwneJPu+ClM4ieSnDBKFm
         h9gObm+jKyESHucy4ZSKqeidnvfmryKtioeyBwJ+NL8V0j90xgpSU+px9z8gebMbz28S
         E8fOXmfCwYuAPnZJNbnM5TDqyyqVnVdsxlagfS/j9fjIJJpG/3ZiIHdvJT04M+rF+e4x
         zk/BaNEPcjTvFNZz9+bOVQYHbz+qFxkG+SKIeAmPYEU4s6b/134+xhfyWM78cUg2A2yY
         nVW0EzH3CdFIMPxIw+G5bU3eoTIXyarqnCr/OX8szeKZP4D1uLK0WjojW14sHjN6CSap
         ChRA==
X-Gm-Message-State: AJIora9c8OErWBcdenSj0CCmmTmxxzTdDhI9X4i7UYR1vqpEIt6pCGar
        3cYkPlg/02iExcXOxemgFDq2pbX2vz6ufbwELIg=
X-Google-Smtp-Source: AGRyM1uB8Q0hF6qeZYcsccTfJdOCMl6izVd1ENJFHa1GzhaPVdcS6F7chxS/vWPfXgbVRJ5ZrKKVkRJUP8KkqHutFJ4=
X-Received: by 2002:a6b:f302:0:b0:67b:e1c3:7cb5 with SMTP id
 m2-20020a6bf302000000b0067be1c37cb5mr2864389ioh.206.1659200604619; Sat, 30
 Jul 2022 10:03:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:16cf:b0:341:47de:211 with HTTP; Sat, 30 Jul 2022
 10:03:24 -0700 (PDT)
From:   Anthony havilah <havilahanthony7@gmail.com>
Date:   Sat, 30 Jul 2022 18:03:24 +0100
Message-ID: <CAKB-Z5u7P-tcxnmG6veuS6cY1fbVAcWHSq4awk2T1=U8ZsUukA@mail.gmail.com>
Subject: HI
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cordial Greetings,are you still really checking on this email? because
since my last message to you till now, i have not hear from you.

havilahanthony7@gmail.com

Remain bless
Havilah Anthony
