Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949E26DAA4C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjDGIkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjDGIkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:40:12 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B315597
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:40:10 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id cr18so36351143qtb.0
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 01:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680856810; x=1683448810;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21T2ruoV7Hb2byNjXRrKdStLSJ9N1tOpZrLYkVqWI4g=;
        b=CwlPxAdktolG/Xqz35Ye2QF0+WKU6v/zcKt6qOPDcN4gNkL9vJOMdR9Df3Jj9R7Z9y
         WNLXMDnDQI/5HecK5VyXJoLsvvhkhb/x/T/UMWuP1jeWAmLZyYdsyLiJS/wG1PPaVgRj
         RogpOa4m2IrCh9ouVxpWVK6MJuzMMjNgKlRgHDiGnjxh24kZw5KifVv9q7kpd8Xkmpj7
         qQizzUoZoAbbZ6sR6ElwsdPlCXMUFWjIHu2gCga77sbOgmdJl/EulSUaadOlhygTJ975
         23RIty65WTOulGT8F18UIb6WcOmSn9PMwMwWXerfRi6X3mpeOx33Aopj1Hs32e2OKiBV
         7N/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680856810; x=1683448810;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21T2ruoV7Hb2byNjXRrKdStLSJ9N1tOpZrLYkVqWI4g=;
        b=vTyja9u2xvG5wNHIlEe7cMmQ6EfABHFRee72A10Eew2YVWhGQ7rNhmFdNs1ODKEO+p
         l3oFcca0hroITBER42zq5eiFAX1lFiUtyTuEdFNanqzgzY3jMlgS18BFIkzSzdHC9Mob
         3isy9sxkgLNgu31kE0THdGSqGfWncP8GJD3/xmQkiEeVHTg/gDjHSYO+28Y28I/ziYXs
         hMXgnIQpjlZusmNNFJOr/ooyl6aXczNLKiaAIpiqRUyvabvCqqb7bqbhdRoKqpzWBg6w
         lbY9uxLHxYexZfqT/ASyTt/6UVDNAX5Hd0AmmQX6kMNV6Xs84tIe7D+zzmZwgcb09tws
         64sw==
X-Gm-Message-State: AAQBX9evC6jjP3Nzo5UoTXwoz2H6zpPrZpRjgWOFw9CRAFw6TKb0i0yq
        ioHnNU/8FILxkFirlNlQ/qHZyP6n4gwIRBNXn0s=
X-Google-Smtp-Source: AKy350ZHsiQbquw4CgW3Yh6gBc0sOpk0OHZs7pxDg7MPwSfvqnHh47PHzV4gL3WeeDFH102m2BQmI1CDY82dEGG3a5I=
X-Received: by 2002:a05:622a:1a08:b0:3e3:9041:3f6c with SMTP id
 f8-20020a05622a1a0800b003e390413f6cmr643912qtb.11.1680856809824; Fri, 07 Apr
 2023 01:40:09 -0700 (PDT)
MIME-Version: 1.0
Sender: mr.adnanali.muhammad0@gmail.com
Received: by 2002:a0c:f4d1:0:b0:5ac:aa56:1c49 with HTTP; Fri, 7 Apr 2023
 01:40:09 -0700 (PDT)
From:   Mrs Suzara Maling Wan <mrssuzaramailingwan12@gmail.com>
Date:   Fri, 7 Apr 2023 08:40:09 +0000
X-Google-Sender-Auth: wICtMX7_QerT5TWvK4obhJ0cr7o
Message-ID: <CAN40Ry7kcZD2rR_BSHTOA2UAS7GwEAvGXc8EzP6T=wJJ-QoxAw@mail.gmail.com>
Subject: Mrs Suzara Maling Wan
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mrs Suzara Maling Wan, I have a desire to build an orphanage home
in your country and also support the poor and less privilege in your
society, I want you to handle this project on my behalf, I have $4.5
Million Dollars with Ecobank to execute this project .

If you are in a good position to handle this project, reply for
further details of the project

Regards
Mrs Suzara Maling Wan
