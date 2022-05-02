Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994C2517831
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387419AbiEBUgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387421AbiEBUgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:36:44 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B60DB1F6
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:33:12 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 16so19756325lju.13
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 13:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=Gk4nfCem3ECRa7Gml0J0mN/3RZoOAdfGaQAqyHPKtiI=;
        b=Rwzm9VRKNN56nw7IiSQVZnsi3PSMlHTis14QNlhlNOI0xYsrA+6pOcd+8guWWk1aeK
         VU4BSgDbho/ehlhM4p57syivmcaNgrICddWq9UiqoJGMDrGCHBt8j0fgpigE3jvtQ6dO
         SVt7Vmv4klfMxYlvLVzdPipXtgwV5tiAAzBeAO+KnhxeOF1BQtqeKHHFgGQp9oJIY/VI
         WCZ2kgV41lZv5H9+RgrCxX8649ibXJB7iWab1GTPxp2JsAImDj6SkEe+U23aYpJMVpkJ
         QoX3jFXMVfx0nACsFZr/YFl3j8iGMwDPmUnkPmwU7mr/CHde4qAySVxQMl0dxCZtnvAw
         wp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=Gk4nfCem3ECRa7Gml0J0mN/3RZoOAdfGaQAqyHPKtiI=;
        b=a1a54bz2xqucAXMxpggX2mp/BJez3gaN/UchZISUZy8Fu2Qh9AqJBk8MVQyNB3b/6V
         sm8e1eLcFXFuckH18koa/ZfkWTKcNgHkNu0gO4puW3lCYZNsk4RY2jRxH3I/KFIi6fYu
         zzuqxek1GMBZVED3ompsIomkeQI25EKjssEDOwprMV8s1SK8NvsC75xJmGR/C/lHwid5
         E/sxqalH1uxn4z9f04kHUZUAGiHrefEBlxz+6xGiGrvDnbLIcjJLWcKpMQC7MHcex+OB
         qS9oybE6VLx1ZRJjOG8y57jcBk8EY5RkXicKLyWbpt4pgCHvYk00xL2IQ3WTT0z42nac
         k1tw==
X-Gm-Message-State: AOAM531h08I9qtQGTjYuX10+mBlIVlBhNHMxLiTLu+HPH7qReZLsmVUo
        wB8lymxT+AwH8nT9a31LxHllTS5NyKivr8iK20w=
X-Google-Smtp-Source: ABdhPJxzDIsqiOFhS4ygX/8r5fiEqowe0tn6tzVFsA9up2bSD88dAznd410wJWFsc01oLcH0YNrMf8p8qLjfSY8eUI4=
X-Received: by 2002:a2e:9dca:0:b0:24f:2924:9295 with SMTP id
 x10-20020a2e9dca000000b0024f29249295mr8540778ljj.480.1651523590462; Mon, 02
 May 2022 13:33:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:688:b0:1a8:2581:64e0 with HTTP; Mon, 2 May 2022
 13:33:09 -0700 (PDT)
Reply-To: johnwinery@online.ee
In-Reply-To: <CAC0r5QWWDUOxkF5zY89ezmcNpvZPWHGS01H21+id9UM783h_5g@mail.gmail.com>
References: <CAC0r5QWWDUOxkF5zY89ezmcNpvZPWHGS01H21+id9UM783h_5g@mail.gmail.com>
From:   johnwinery <humghrysking@gmail.com>
Date:   Mon, 2 May 2022 13:33:09 -0700
Message-ID: <CAC0r5QVyPEzz8Vkw_jPQ_ktQFFpNrnfFnh0-GgUntvuJrYU5CA@mail.gmail.com>
Subject: Re:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greeting ,I had written an earlier mail to you but without response
