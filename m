Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFD25668FE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiGELQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiGELQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:16:31 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCE513F3C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 04:16:31 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id y77so15792661oia.3
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 04:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=yaAH0g1iegHwxNu2nPfuEqNmqOnCr/4aJROLcY5axoM=;
        b=doy8/nQpUD24fxROYDPLDjL1ElEIDjdvGKKkhi0NB1srTNaZf3GT1JCOnoWJND4PJH
         GH2iAFU5vF1iBw4dwPkKOWBdT8RNTLmqIg1TzU6uF3uLR1ULu8gU2XWl1RMV/tfGmBNd
         WLsxE+C075nxIGF2xZ/QzimmCM0Vwj96pesLzcFjQekknt+V85d5ykv5Fpm8W19hCcnN
         sJFKHCSv1uhwS9jJ3hVSWx5D8t/BGD5lfaZzkiqt0bESoHQT+hOKa2s+QjWQaY5Td/I5
         p/2yB7cgIhmjpdupuCjP3BJGmk2XWcBJVJXxRI9toev+AXZlDXBnKv7Ms9252Fc9uzEZ
         p7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=yaAH0g1iegHwxNu2nPfuEqNmqOnCr/4aJROLcY5axoM=;
        b=fwjC8H2OJv4dJuLjgLwacQrKAkeXRvxosKMFPTbkIrzHrUXOUMICUdajM6R7cQ90N+
         S3yucXzhqasuHk3zfXcC5g/dCzbpnbMjLUN4enKTJSPXSb4OG/ymDUaUA2/FL81n4uSs
         jx7kICWu1mh74lBM5o8PBBtkf+105NYpv1jvECSdZk09LaGLK3frvzSJKCkrB8MwwLmv
         rcDhYOq1e0aHIYaEIaI+aVBJr5DO6HJYa3gYwJeaOWnTX4cOxDUezpaxe1l7EWOr6kKg
         bx+zeBUO4cYeq7SEVHC5UBNmavMKzGbopaalBuq53OwAq+7fEOKqo58d1y9MpRhD1sEs
         J7sQ==
X-Gm-Message-State: AJIora8ntqPd5h0PMjEap1lf4oLrPJFbmce94RCxBTBBEWuPPlXbqqbg
        /Q4YJ7moPUXlF9WNgl1SGe4YH1sqIPHNKkH46MY=
X-Google-Smtp-Source: AGRyM1sK85Got0uSJWfGJVbJjzUDalhZaArV8nEr2SMMoGdiQk2+Sl1SdzfU6TY/4jI0lrrEd+cXdo+o34ANXeRMxzI=
X-Received: by 2002:a05:6808:130a:b0:335:c055:7681 with SMTP id
 y10-20020a056808130a00b00335c0557681mr15740151oiv.37.1657019790400; Tue, 05
 Jul 2022 04:16:30 -0700 (PDT)
MIME-Version: 1.0
Sender: angelmill1993@gmail.com
Received: by 2002:a05:6358:b115:b0:a9:f0a3:1706 with HTTP; Tue, 5 Jul 2022
 04:16:30 -0700 (PDT)
From:   Maya Williamson <mayawillmson@gmail.com>
Date:   Tue, 5 Jul 2022 11:16:30 +0000
X-Google-Sender-Auth: P61CXgZhKTFGVzUns5_v4b9GNHw
Message-ID: <CAMYY8oDdn=MibkyRxttXJiJ3m=Nj02a=ctCxjRU2vq4YYj4OjQ@mail.gmail.com>
Subject: re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
I'd like to talk to you

Maya
