Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86699606882
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJTS4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiJTS4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:56:20 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FF41413B2
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:56:18 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-345528ceb87so2133707b3.11
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qKZQaYvyG0T9Uj1OTzAaNf0j1uBekm8T04WhuHWE0ug=;
        b=TWj8mFoGdDV5wLOGZBcmn18fryi6dkhScm8djDvkWFisMziwxY0FPgPxFWCxZrtdbe
         11QuiZr0rRcUvYFQFCe8a3KjHEj1TK0uUSAV30A3/op/iLlV0aV+eaQxMPmSPgb0Gr0u
         pjFuFfFh+8LWZ13iHBVuBOrsMU+z235E0Ztmxn+0Ziz2aeMuIO8cTaDYxv/UthmLD3fW
         ymOvFqdjSjP3T57+XZcbJbv339m9bsW5Yu4uDmIQ1iFio5KgVHwK1Wtjyhm6XdGEM0yU
         7zsKoGwYT4SzsJDGzA9nIRlmaneB0f3hUD5wIJeGBkIDPpZ1PeUQlULCtlefwvdOL9kx
         6Jag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qKZQaYvyG0T9Uj1OTzAaNf0j1uBekm8T04WhuHWE0ug=;
        b=QHdoyNCoMObrk/5QtKW1WYvUbd0KMaYTq/7Hp7Mg89AV860vS0m0jganjX5RJwWrSq
         TaXzOI4zlswA/RO0lsebQYBLj1W+Ufp040QZaweG3BCaWnB9Ul0iQHXq953Qv6LHHAIi
         lE3tuGAcrD5oqYI936SG+HJfvzCiZH3gzgF/+yTruXU+/irviC6FGY1ZpenxVyXHUBES
         RkNWlWt1xKYNTqv7aTpgVZhkDEX+1fvmzDLmyeYZAfNOwLSlgGx5UxreajBNYrZDDGR/
         o4QjKmW810IBsHO7+OmF7iMmFcxNiLbu/xnfcQBCUP6Zb5LlmtZ7/B+uiQYUexT6x/KL
         cXUQ==
X-Gm-Message-State: ACrzQf1vn2UdtUsB+atx37xOg8VTTIZRcck0Mho8+dNX70cn0eajPKdJ
        +uKA7jaaZFhmSGSlE5ZhsZiiqx2+oaQHxM62+7s=
X-Google-Smtp-Source: AMsMyM4lNRcBVD909upzEuvyEYhdtIFjZrVQpExAq24vS+9JMAT35EAOhU2EgxMVOL2538w5zq/3tEUX0TcXtK9Rucc=
X-Received: by 2002:a0d:db8b:0:b0:367:9aca:e47f with SMTP id
 d133-20020a0ddb8b000000b003679acae47fmr7096416ywe.400.1666292177795; Thu, 20
 Oct 2022 11:56:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: anabellemarieclaude@gmail.com
Sender: ezeblessingchinaza2030@gmail.com
Received: by 2002:a05:7010:224f:b0:30b:2c86:372f with HTTP; Thu, 20 Oct 2022
 11:56:16 -0700 (PDT)
From:   Anabelle Marie Claude <anabellemarieclaude@gmail.com>
Date:   Thu, 20 Oct 2022 19:56:16 +0100
X-Google-Sender-Auth: Rl1a3CgLjBqwNxUi9LuBEb8-eh0
Message-ID: <CADEx5XggDMt4XJ+7yO4Y6EEdjAmYMyVtn7g3M=2FsiSMqwX=YA@mail.gmail.com>
Subject: Hello
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

Good Day,

I will like to disclose something very important to you,
get back to me for more details, please.

Regards.
Mrs Anabelle Marie Claude.
