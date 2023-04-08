Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B6C6DB912
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 07:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDHFd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 01:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDHFd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 01:33:28 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028FEC66C
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 22:33:27 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-50489d1af35so141801a12.3
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 22:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680932005;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=nAw4rh/oZyuh52D/530C8nJELcAdR6kyeWSAqBNNsZznWGMjmoYjYPZP0U2+t2URmR
         uJDT/Ql7FBesLXniuNUFu/ZPeiTqsGWL595hlfxPiQiEVLq6+fWuC5wlnOZdPuQ5U2Zx
         JZWYHm0wVHJGagm6WQToJ+yTbBIyC6rn4Q+nBNK0FYlLB4aAZ4LBbDzYnLIpP6sn1x+3
         3dzrMxz8fOCR/7Ret7RmTgk2xZiCc1qtD55UhWXRJhkzrf2DxM+Alu/XOewuib5hhpRO
         DrMpQ1xPM+l5fJxWU7ZZnaU0PUA+iW2GTVdrCpko1W9NNnyAUqHvpvr0JfW8exkKm0aw
         r+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680932005;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=kXMaBFI/xstkhWUNTlQdm2Bd6EdlNpx35xtgCZfKc5Kgd+3MMVCjJWIlrvymdP4eQ/
         MJUUX1SMk2/6MfqoE4Kr3od1PslXzkcm3DamS287HI5whYqwUoh3rSEZdGQh6YZm2Pf3
         2AKtYlVmrwwl/Jd0p7SZCoe+HBOuD4wc4RpwnvBOO+FYo3o9eQty6xL09FnRFAdrsJuE
         cztZuNZCHf3/yOZNrxgrlq+jUoJeC6NKQnXwaq+hQcjr0Vm0RTE6nhhHlzokmfIiBtMi
         qomPAxalRnZZpg/QB7LDa6oCbq2SmcBl7HfCCTWcd6/B6zC4+E7eJQfCOuQip5LSZMQH
         nZUw==
X-Gm-Message-State: AAQBX9dt4tueuvg5eQwOCNje49wxhDR3pl3x95vGuyiISTT8/gx6QuCY
        yFzGFk0zY4FmtOb21StFED8VC7UryNG9oeiN9J4=
X-Google-Smtp-Source: AKy350beoFER18ukZsOcoxUTcj00QkQGWduouH/jAYSj3QbhcMpnfOIoq3jS9lfhDwvdYFdJCU6+RMxwnVvtThQrs+s=
X-Received: by 2002:aa7:d701:0:b0:504:631f:abac with SMTP id
 t1-20020aa7d701000000b00504631fabacmr4757833edq.15.1680932005208; Fri, 07 Apr
 2023 22:33:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7412:8527:b0:b3:c251:b7ae with HTTP; Fri, 7 Apr 2023
 22:33:23 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <fdee9487@gmail.com>
Date:   Fri, 7 Apr 2023 22:33:23 -0700
Message-ID: <CABKnVjU0hkTfAdxB3CRxDXf1M3JdEu+5Xk7LoycL+GLB350rRg@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
