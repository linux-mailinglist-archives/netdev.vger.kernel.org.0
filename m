Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4857550DC0E
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbiDYJLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241466AbiDYJKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:10:40 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90C9B9F2A
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:07:28 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id c4so6875843vkq.9
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=Gvm426NFDxQqHc39ydEG611xLBHJYCUQ6k9Tiq43GvE=;
        b=m0GZdpkUBIXIsS7s1rw6oiretpYoVVSpRi7j8fw4Xuz1XcB++zPxb7OX1i82f4PjMB
         jWBev5J8R6hPBI0Nsi9nQex42UFqknvx991dYthzB6xDnUhOB6S614ZBPVxKgbsPjbhj
         E5RfG08akbCKiH/sQiXQTmjHTrlTVWlabMAweK6KyoLZDcU8lKXP10fry6ofeZSRAdn3
         C9SlIbAcwfewZ2Dw2nlvWTiE2oTfSac5zhy9QRWe4LojN2UYCALEqHvMNxxJnrhlu4Tx
         ceKq73Hqu9d33dewwSGKlg+iA7jdqYMJODj+hNLNNhscBVm8H7amk2YJGk3zVnBCfsH2
         GZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=Gvm426NFDxQqHc39ydEG611xLBHJYCUQ6k9Tiq43GvE=;
        b=N2tiYpYwZ3z80DlfbooLZ2566tT4sGame7kZAf8VoOmAeGgDSAwHxxNzrRCjk6bnqY
         ed1+HWg3v9o4mR4ZGvdg4xSehqMAR3pYsxFUrF/ZZ+oo/P7MWT4ciw6ZOIAYdvI+u8U1
         vuZKK5xgmZhLBY1kcwJ26CxgYOFbKNYZzcqQxx1Z/GENjbecqaMr1S5muGiXBwb0wKAg
         bvZ+LbqoVdWa4DDvay2zyf1FKPyLE0CeGDmQxM72+YfegFU4z9UcaqK37SUZOrjx9xbU
         wkim08TRF+T5rjALykdw9z2xfqpCVir1blyptK5I/FPEMwwEG+VY+8LL9AFRHLzeMJjF
         E9sQ==
X-Gm-Message-State: AOAM530hdGijWNMVKfR1Qv76GjTHBGi2BOBv9M6+1AKNOWlrSosnK6wX
        3pgva2x+94/pk/Q7O7UE+oSAeCj14mSaQRduog==
X-Google-Smtp-Source: ABdhPJxyDdVV0dfG4CV1Wp7gY573lty2DwAjlktbD9EqjP16KOzHbqFYu3BLCqFJh3TmY2ggO675DUcO36QndZVuCys=
X-Received: by 2002:a1f:c148:0:b0:34d:9a00:d469 with SMTP id
 r69-20020a1fc148000000b0034d9a00d469mr295410vkf.13.1650877647656; Mon, 25 Apr
 2022 02:07:27 -0700 (PDT)
MIME-Version: 1.0
Sender: adbbnkbf@gmail.com
Received: by 2002:a59:b9ac:0:b0:2b1:4e21:b6df with HTTP; Mon, 25 Apr 2022
 02:07:27 -0700 (PDT)
From:   Lisa Williams <lw4666555@gmail.com>
Date:   Mon, 25 Apr 2022 10:07:27 +0100
X-Google-Sender-Auth: uUR6Fyklo78pKKbriadxwDv7Gms
Message-ID: <CA+P8mZT9iPB_puBqbpCMiVVDyafiVAwS=+PPKHeZ38H_o7MiUA@mail.gmail.com>
Subject: Hi Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
 Hi Dear

My name is Lisa Williams, I am from United States of America, Its my
pleasure to contact you for new and special friendship, I will be glad to
see your reply for us to know each other better

Yours
Lisa
