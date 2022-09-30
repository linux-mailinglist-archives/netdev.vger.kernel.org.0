Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1C35F12FB
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiI3Tth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiI3Ttg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:49:36 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBC618274B
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 12:49:30 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id a129so5912718vsc.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 12:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=8ecYicVNlqCwpTD7keug9XpsIRW3LWPQcbFkS4Vo5hc=;
        b=DHRUTWoCgSU3gxzxOwiqouc/1il8CWryFt4Mx0nJgMNQyFrC9SpYuLuFGVfzSkfYGk
         bBwp1QC0Zg1vJjiDh0/MgpwbuevHqNx9BYu61F2M8Sz9SK/1cWnVvajY19wFPnCZJqNi
         fc2prSbjN1D0TdM8AolmgBCWlH9A1jTE8aKAL6bc4YxxRepzy/IpbtnQFPOsnWXfb1EK
         R7/W2BXNdjuW3kbcA9RiR8oVNEXn8jWJuPX1l8gwVy2eeN96e8wkPaOhzZH2+KUal7aJ
         GfkaoYACBPeM71IvgFI6vBYpin+rGHlvhlOQKnhzVffg+psp+nSrAXCeS+VFOkA5cxNH
         yfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8ecYicVNlqCwpTD7keug9XpsIRW3LWPQcbFkS4Vo5hc=;
        b=Ysu1ayF6gwcvQQy577HOV8xI56iEr+rVtdoAM1YXTJvDRItZbBvj7hglALSWueX/3l
         oAWV2X/5cQ24GWXSRlRHgbrRs7HnYJifLe3q/o4sQeQl2BjuwwfV6hkmCaTK0inXqutS
         3ha5j/IM9KmPMJR/0jN3j6qM5JWe0jwYpcEk0egrlZQ9yKx9HRrDqR22ii6wRTDMyeFa
         mvSe4LpZWQa6gH3JQSh9Zqi9JY7f9Z2p2WaztBke3hh81cehgnHSafkxjcwWKt8VcqFk
         /iS/xJvAqFBNQU1ya3Y2ocW0BQsnUFfRZUEuglQ+FQVLeS2Y7SYph4vQl3PiMzmT/gQz
         ybqw==
X-Gm-Message-State: ACrzQf2AioXwgWWgOXb4ZuCc7GbRGdKj4KbQnuA3nHBSSxgQdCMmh8T7
        cmuYPx4hGaeyT4pp2HE4Z3rpibe1tqxETgN5U6w=
X-Google-Smtp-Source: AMsMyM5gT7YiGby9PzIfMjZL3wpkaABr/cmjXM7a8ZTzcNdiUsS8g/SZvfPPd0EPnZZ7yFe4b0pw77k5dmD+yQU0vGU=
X-Received: by 2002:a67:ff82:0:b0:398:95a9:f31c with SMTP id
 v2-20020a67ff82000000b0039895a9f31cmr5479070vsq.9.1664567370017; Fri, 30 Sep
 2022 12:49:30 -0700 (PDT)
MIME-Version: 1.0
Sender: zulkifiliibrahim38@gmail.com
Received: by 2002:a05:612c:13a2:b0:2f2:9f6a:debf with HTTP; Fri, 30 Sep 2022
 12:49:29 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher001@gmail.com>
Date:   Fri, 30 Sep 2022 12:49:29 -0700
X-Google-Sender-Auth: OwHaOr08gO_0KUTnkehTY1NfWLE
Message-ID: <CABJzvcwJ3_reOEKRYJ2S6QeANSr3DBqm3_d0FnUYEZVzEBSP9g@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you
