Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A9163AC08
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiK1PRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiK1PRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:17:14 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0449A1C122
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:17:14 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fy37so26591562ejc.11
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 07:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T8QYZXgTEVGsU6AUoZBpg3oCl/bFUQpnBIlnbvcc3vI=;
        b=oRL4NHy2qOWJX9FR2GQdrssZ2OeQEZ3/MbduQF56ZUnAB8F3NGDjArDpOHchbxoavK
         KXwLxzSjz8a1Lmli78EKQ3Q9QzVhipIe2+3xekJMKi8eHc2UkodCAqz00Y92F3dkTjO8
         Cqh6koIPcsJkE/RI++wWJ3oDQfBsA5utpnKEgc/1Qp3T2BwoTGtZv6Ah63kNQOapAPot
         28iC57jPowH5VvY9issN5RXhSUCwI3rpZlG+JKRnw6xSIjl0b3gHUB4oieIWx8PKaqVl
         bIWIfOihrPGdyKtlyzMGZJzCPQFfA0EH9jdSDWRwcUJK6vGwwjWH1Oyd2Eve6BLlyYH2
         IRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T8QYZXgTEVGsU6AUoZBpg3oCl/bFUQpnBIlnbvcc3vI=;
        b=JCCUDch5s+/zv+Blv3IlYF0wNsS5qSQbeUgZ3dGc/D++8kccHKjQSbLFrpzmXW25xk
         /wu/xCv50Q46x67XjnJfzdchz28p40lt+0p0UYYnk3z4pcBY3L+Ns6LIlMWVWkhlGY+7
         VWBWCaD49hYA5k65IcKEUw+Qx8aJDbbL/Iw9Uo2t+YxYZfuEeXYr4NIL1/1hSVhd60Hb
         FegdgFndnztC7iTLZ3vT2fZ8aYEnJkFNtcsLS7K9flQbDeOkyRActC8IxE4Fdpq0RGJV
         GI9pSQsNgHe45qtqyeZLm19Qhhgt9BtXg4YRjl3VxDXWH57l0LWmEA5IFtOxTxGu3ni6
         Nrpg==
X-Gm-Message-State: ANoB5pnGdJLsFtwyxYxXQPBMk0bTCl2IlcKT1B+BkrGjBfxalSK3dI5m
        6EfV3pH/Qp4XDIrxROkg6ijmxbiegCa6zXVewC0=
X-Google-Smtp-Source: AA0mqf5nZT53BtmR9xXzwNBHbMmYJffZTPCLpSn4gyHrHJJJnqRwVUXMHlrUeboW0cri7jS0bMZV6JfAny12b3cf1Ds=
X-Received: by 2002:a17:906:1e8a:b0:7b2:b992:694d with SMTP id
 e10-20020a1709061e8a00b007b2b992694dmr38802918ejj.651.1669648632500; Mon, 28
 Nov 2022 07:17:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7412:a403:b0:8d:aac5:3018 with HTTP; Mon, 28 Nov 2022
 07:17:10 -0800 (PST)
Reply-To: sgtkaylla202@gmail.com
From:   Kayla Manthey <sgt.danieldailey12@gmail.com>
Date:   Mon, 28 Nov 2022 15:17:10 +0000
Message-ID: <CAAQwz2KjFUypn4EOeBs1Q3HGjz5W31AHYRChRAOA76MBqGKgrQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Alstublieft,heb je mijn vorige bericht ontvangen, bedankt.
