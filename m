Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C5B604213
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 12:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiJSKxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 06:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiJSKxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:53:13 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB26311819
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 03:24:31 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id n83so18683832oif.11
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 03:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QVwK6BJas5dsH+X7/x67OgWXeXCjicgS7g7JP00oQkA=;
        b=oBQlB4bXuPtm+ovgKHzBHpuwLEhUvhUJKNVAd/IHlr+gj6M5EhTZP0rsIeUJLhZgvS
         mYWlR48q/oF1vWfrpzrEWht5Bb6BiqWKUMw9ax4y+Zebs6sRseWZnTf3XmaKdMbyuC6u
         yHE0gyupyT+b1fznilUFyLOobh5azdtM5GyyQZ+JyW7ZMn9lSYeOx8nQbFV6Z9ZQfgDQ
         Nqz35nvcW8cUYxCK3ZQ0oYFTXZDDuCGcFbiUbn6pqGuU9Ke89Q38Rdk2VbD0p6t7WYLq
         lfGO/JfKZS7xyXJY0GRN/WkAHHEsa0sMwuaBfsxyKUaYZqCW/gFyc0c5zHm7r3Jk52Nw
         absQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QVwK6BJas5dsH+X7/x67OgWXeXCjicgS7g7JP00oQkA=;
        b=Zw0VxCk2NmZK2xjS///C1AfrGqnZozbbtCDs7wyum4uSFdM8I/ojEvPZp3aysUZ/aI
         PGtdusRRtOeiaeVlQanr3sVrrBWkuY2hN+9nwwul21VvK0yjjr7dt5wruqoij2LAIJr3
         BKmD6vZCImucHnc9Thzd4+lVgnsxeizvc3ScOpgcnsdEjPgeMEEM7ggeeQ7Zcw4br745
         9mhM23V7l/889OFwlR2Mpxp2dR/7HZpaqUc80jQeaOGhr8lvUqxGcELcgS1xDONKLA8m
         MsfruRev3OMBrx8WUbuBvckRQP5QqEcvtXRSScsMFZhXPv0lAnwy0CuGZm1Nn4RtaM49
         F62Q==
X-Gm-Message-State: ACrzQf0mjC4RUuXvkcRO3nnpTBmNqeesbTdWv6Cq4VhXqJ51iq9OINtw
        d9sMvg52VB9kcQJx8xsGtefLx10evRvXiMpjiREQ6b3vTAagb8ou
X-Google-Smtp-Source: AMsMyM5wGfrsvsy51z7TaoD0HmjWME7eFN58+AwWFc8yOpSR2jRZjVT4eufVSwqGFx87rgq9ryV8rr02cE7n7op1q7w=
X-Received: by 2002:a05:6808:1a1f:b0:354:b33b:8b0d with SMTP id
 bk31-20020a0568081a1f00b00354b33b8b0dmr17231669oib.171.1666172853643; Wed, 19
 Oct 2022 02:47:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:675b:0:0:0:0:0 with HTTP; Wed, 19 Oct 2022 02:47:32
 -0700 (PDT)
From:   "Dr. James Mark" <delfaveromas@gmail.com>
Date:   Wed, 19 Oct 2022 17:47:32 +0800
Message-ID: <CAKDVxK-Ety0bbjXN=gaqrwYU_ymec78_4JL1SnGH3deSjF=qTg@mail.gmail.com>
Subject: 2 000 000 $
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2 000 000 $ vous ont =C3=A9t=C3=A9 donn=C3=A9s par le Dr James Mark qui a r=
emport=C3=A9 le
jackpot Power-ball. Contactez-moi par e-mail pour plus de d=C3=A9tails.
