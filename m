Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6DB671F3D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjARORG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjAROQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:16:25 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33CE7C854
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:57:11 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id bx24so3682615uab.4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbCVlee58SNRljTVR7wTvz7D3A0MvcLCtUjVncuzsEg=;
        b=L0LhIE3ANXdVEs0Pz77p/bINhu3DRj2kw8cRZZTu2E7anpRXeaATnZ6kjWGjeXjqC0
         cRjnurppOtnMQMd7spquOYt8OH6hBkTdhoDBvPHWMKBU2k44S0gicDasr2ZWA0/gnUjQ
         R0f8+DyDvNm4ETXt8gwOzDgWXu6XIs+Ocy3XJDiMLibTpM2+FLd9DBDDNU4AxNXAhHR4
         Db6VVdZLls5a1nuvuZ3a5qDT7JdK8HhFH9f7mkDe6S1qEyC7ch7lwcRaNXCxNWs1KaWz
         odSr0rN9145RuQpp1mF3XtUOcLX3495pVNSPilwdoX7z5VV7bt1FW/msIGX2iTekS0QH
         12Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pbCVlee58SNRljTVR7wTvz7D3A0MvcLCtUjVncuzsEg=;
        b=Kme012DQdRpzn9Xa5lUAGYszMgtG5pwWgSqpPMbwUlXX1FfRwS/J4CK8Wdx50fn6vy
         htIKxIb4YPgZGk9jG5S/gvgeNvT7gxXFgo3M1KefldwjdzqLHvNw9ZAtxPb/4oWOgFsA
         n3HjSgqrxfiixkSmNPbaZ7/NKQXP71b2MrBaMdYh4IECKS0fPVgJDbURicVcHQKD98SH
         Z8t4Ba6sT4TaEVlrKFmlRPKjOwuZDgwE1xkTZrJFl9peUQSCcEXaHoFCr+PoeN2FBiu5
         tkOklri5UwK17zZpPVcBukWrIaWcd4mMS7bDWsR9shNpkc/uW5nJ9FPECVvRO8xiB7l/
         8DFg==
X-Gm-Message-State: AFqh2kpLIuTO0wq82NbFN9l3LiWA1YDbZpp4XhyDDVWg9xV5VsISSKVx
        taZav4UuljadIaeZpveIYvlm3nDx4zns4wqYgvo=
X-Google-Smtp-Source: AMrXdXunolvj+5qNuLyNiu0KV6pYUKTbjGYk5ijOU/xNAhxPT8WXu/n5zWoVV7QHvfJ12voImYLUqfyTgJ1DGRQcTf4=
X-Received: by 2002:ab0:7405:0:b0:600:97a2:8a86 with SMTP id
 r5-20020ab07405000000b0060097a28a86mr735632uap.39.1674050230827; Wed, 18 Jan
 2023 05:57:10 -0800 (PST)
MIME-Version: 1.0
Sender: br.bcha02@gmail.com
Received: by 2002:ab0:474c:0:0:0:0:0 with HTTP; Wed, 18 Jan 2023 05:57:10
 -0800 (PST)
From:   charles anthony <banthonylawfirm21@gmail.com>
Date:   Wed, 18 Jan 2023 13:57:10 +0000
X-Google-Sender-Auth: evrhQMN6AMN_xynX27h9P-tPJ_U
Message-ID: <CAP2kOeQ3ihnpf1MP9q1qVi+5=MhotesqYgHaPuJ=G13QXFoViQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello

My Dear, I am Barrister Charles Anthony, I am contacting you to assist
retrieve his huge deposit Mr. Alexander left in the bank $10.5
million, before its get confiscated by the bank. please get back to me
for more details.

Barrister. Charles Anthony
