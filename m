Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F14F53D649
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbiFDJoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 05:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiFDJow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 05:44:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92CA1B7B9
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 02:44:49 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d14so4203604wra.10
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 02:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=NvFjF95Ia14lzoWclY7y2Zpf1m8DXukmA0Hxb2EsKbg=;
        b=ac5Ayyp7kmhQLXYOjhvHyd44VQHtYnaFaMI2wh/cfR9R0ZPRT92gI5LRj4xP2N1U3j
         oeQYT5qBbCZvQcraofQeZLqxjPoVyx/b/dW7So28ESiJxZuKyOyUjOZdHiPQ4H+KxYq1
         urEAFlaC6FQKC6+yV0R4ZonZuKwrbdC2/+VZqiXhrdycON9Ui3O/JGHdnn4yIlVJNrZw
         RtY0DmNwEzQ2r5atrMxanpjdQZ0wbqEk8Hr9Aw78Mivq+EyUGVfflgB5245aiTuEwaN0
         +q6FAoAG0J8NP5WaITs8IU7tOcY+rJBBT2UvNLAOxOVV1kOGqlONnv6pE2UEpQohxZKu
         REew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NvFjF95Ia14lzoWclY7y2Zpf1m8DXukmA0Hxb2EsKbg=;
        b=zCzOA354JQb2UEI7K1h4j/2lv2ccmzf7z53F8vRp0/KGH5ZQooC5rtEJmXFzFdr2VL
         X1um2iQ1kGKryvcR6q28IK6pHCxHkrHi04lrAOPKPmeVJW8qkirylXIgNPipLbSbOHQq
         U+nsjlYCwVYkhCQaucade4xhyu8Y3JvqYujASQ5W3d3pzZ9JIpxKKet0kcZy+1skC+zG
         w5qkhv5RN+1g0MPVsdehf6TWMvglelszqakd4w4F0HHD6p6MCeg1uKrMMrSfrW2IunnO
         Gnv7rJaP1rAaN8z7oum/MFZBOmX2akl1kHa+eUsi1k/jPNcZqr3J7nyuafVnIBBmCz/U
         Ze0w==
X-Gm-Message-State: AOAM530yeVwlgoTuK45U48yupa8hDoYP6te2h4cigzur2C4xCYle0R5I
        JiGfyjsKGt2qroUqUxujul4mzGCRzixiRQkNWuM=
X-Google-Smtp-Source: ABdhPJx0pNsRhhTa+pBnv7dRqrKL5BPptIVZFc6bIgdOmR1MHXdpsnlDkK0TVmepAFVvP+uHDK8VPTe07D7zgPs43DA=
X-Received: by 2002:adf:e90c:0:b0:216:9ab:312c with SMTP id
 f12-20020adfe90c000000b0021609ab312cmr2855400wrm.707.1654335888582; Sat, 04
 Jun 2022 02:44:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:504:0:0:0:0 with HTTP; Sat, 4 Jun 2022 02:44:47
 -0700 (PDT)
From:   Simon Ajafor <barristerajaforsimon8@gmail.com>
Date:   Sat, 4 Jun 2022 09:44:47 +0000
Message-ID: <CAJkFdfmy-FcZ7FDth6-on9xQYxn5-39y-n1YA+DXxP6uF+-org@mail.gmail.com>
Subject: Dear
To:     barristerajaforsimon8 <barristerajaforsimon8@gmail.com>
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

Good day, I am barrister Simon Ajafor from Lome Togo west Africa, i
have very important something to tell which concern your family member
here in Togo,
Sincerely
