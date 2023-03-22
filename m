Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06736C4A56
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjCVMXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCVMXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:23:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E661E1D8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:23:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eg48so72025867edb.13
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679487829;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKO3ohsBWGUhAlloy+4N6XU+uE9FlkRAAJDovVxUKqw=;
        b=KRb5CkW2sk227RRhQ0EHOQNYCVH0Ht6nV7MJP//EHS8OnxUSA6+XWy0ZEQkFGt+U1V
         n0gY8ZEgcAReYrNEoi45mq9SKSFl3vfljc+BHObGInrg7IhBLM86NRqQRXP9kCNCKVeQ
         5Mg2Mo71pg2pvugoqqCk7+6xDzpW+UqdYuqGa5MGkOgivFrOskIJrDdihEYOQ8+4BxmT
         Mma+OLObjz0p4eQSTmbL5U/ijYtyxMd9voUcOQ9dxpQsz4S2IhkJ949syMd1waVF2GXJ
         8jT4PAAibMPbHme1uXB/zkG5ZDcpX9aFSpZWxAPHp2wEqu46HtzPYtgxnSnceaZpUk94
         1T8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679487829;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qKO3ohsBWGUhAlloy+4N6XU+uE9FlkRAAJDovVxUKqw=;
        b=qsKgFtstXGbvir48u4x5LsrgzIJlx7fvPqjS0WHL98O+wt/aoL4c48Hh24Z/1ESKji
         tr7rdUkgpZG3Hgx43QWKJ2y1Zl7lKkPndnm5vCiW9Izehi48NC4m0Gd5hhOT1b67lJvc
         0YY+QwNYWu/OXKCiHkbLvDQ29H8ctWfuroRbSD/yS/p3LgUOq5adz5a7fwK9qg7+GWvE
         Wg3vUYxL9ADc4javoZrrOEnkM1di2LiEoBDwxYdSLu10h+dFOdF2LNlED31ISeY+vyLm
         4TyJajxNq4/7/0vQvr9Pb0i3+hhgeGFuSIInWHnJFkfKSq76QyDM2aG5faco4q4JHShN
         mvVg==
X-Gm-Message-State: AO0yUKUPRu5ZduXF5RKEgIRVaQhpf19NfJYoSUjOGD0QAi0wrO4ZyGqJ
        noUaBztqgqOx/eyCs7jhi7yCMQcDd8gvSaTOi0kpaNp97Ns=
X-Google-Smtp-Source: AK7set9CcH94GwONMyMAUmycT3dNEn698ggRHPLY2n+otcIPJ9GSpTWu7gxsR9llgkDGLqUH+2KVk4SVsEsKWijc/FI=
X-Received: by 2002:a50:9990:0:b0:4fb:7e7a:ebf1 with SMTP id
 m16-20020a509990000000b004fb7e7aebf1mr3294795edb.6.1679487828659; Wed, 22 Mar
 2023 05:23:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:7253:b0:86c:9916:d904 with HTTP; Wed, 22 Mar 2023
 05:23:48 -0700 (PDT)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <tonyelumelu67@gmail.com>
Date:   Wed, 22 Mar 2023 05:23:48 -0700
Message-ID: <CAAVnhxLUAHL2ZyW2k8LfK1JasfC9K6+YhNqmY8CtFAHznBmuSA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 

Hello how are you doing? I want to know the situation of things over
there did  you receive my message?
