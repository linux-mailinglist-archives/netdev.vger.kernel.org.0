Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66BE4BAA67
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 20:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiBQTzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 14:55:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiBQTzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 14:55:22 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8037A1451DC
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 11:55:07 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id s5so751286oic.10
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 11:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=mnHy2tprAvCK6GYCrwD6RMRxuBe5el0o5ZNAVtBOYAw=;
        b=V6KyvbIxMlWcGGAGmVRWl85zqg3m5VkCX5XewEiYysgHISkcSu9g/2268fRtmNjd3a
         p7RF5sgzLBLQ9alTRUaIwEVOrwEkU+3mX/8KGG2Bzplq/pCeMbJ3k2GVANh/DTt5PeU1
         0zv++pw2knAHNquXIAWpl5zWnbW3ZIP0fw9Zd8KBgusfmbHAF02L2h/MLKDOzdmehk6q
         qte/e168QqtmTLbMqD2dLEGCUlQPrq/tKSelrrfQ9GmBZHqM+SCGJUOTTzbe7eooR4Av
         JSgg1xZ2bfMCec3Ag9L83GAqewMZCsGzT7ELEfNCitHPjo4rVbt8apI0Zpjry/8SjCmU
         2evQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=mnHy2tprAvCK6GYCrwD6RMRxuBe5el0o5ZNAVtBOYAw=;
        b=1xhhH3VVhF8IM05AFNRo0H2k8mNV/JxflxKdd9kFg+qL4MduIyCv+FJVr2MdSdW6Bi
         xFMoZ1Rc5h9UK3PoY++KOcx9RR9E+2m2uFPNS8TIE+ba+5a2n3PklLOVGCnOyIhJWIzh
         BkMhUUrRfW2qtKiKdlA4hnG7G10e1PAcK0MISZVvH1qCwWad3EWb21bKU5OIa/swIsp0
         VfElZVLX7jgvn/I2m+j6tzbnHLs2rd42DDxumETJqjSsdN3Mw5h2X0Gn8mWe2pKu7Opf
         m4aQrismy2b4Qm4YG+t80F22hMsY0TDZemY6EzhXNNo9GIXkJ6zhks4kBr5jOxCNWIBf
         9sgw==
X-Gm-Message-State: AOAM530Q+7CUw6ls6dEaQXhXLAn4/Fqs3o9ucj62cnyE/0hmJU+86jmx
        dws1OaqFZMLJZOPKFt/bfaNlexOWqhcKqXMymdo=
X-Google-Smtp-Source: ABdhPJxTOXBvdrkXqFV6+hiMj8PjJlCppnBj6OkW+pE6CkzG9T6M+DmrTvVA33iVCWaqnnpUg8Z5/t7Ii8oVN+0c7zk=
X-Received: by 2002:a05:6808:1b26:b0:2d4:5f3b:d4d3 with SMTP id
 bx38-20020a0568081b2600b002d45f3bd4d3mr1822826oib.133.1645127706969; Thu, 17
 Feb 2022 11:55:06 -0800 (PST)
MIME-Version: 1.0
Sender: iykekolsaac@gmail.com
Received: by 2002:a05:6830:441f:0:0:0:0 with HTTP; Thu, 17 Feb 2022 11:55:06
 -0800 (PST)
From:   Kayla Manthey <kaylamanthey421@gmail.com>
Date:   Thu, 17 Feb 2022 19:55:06 +0000
X-Google-Sender-Auth: p3EJ6WvuOfy8Q6z2kzUo1Nxx2Uo
Message-ID: <CANxEKnhEFPXTPob8xBPSC0yc=5gj21fE3TLCnYm=Hy1UAtO6xg@mail.gmail.com>
Subject: Hello Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

Please can we talk?
Something just came up and it's very urgent, please I need your attention.

Regards
Sgt Kayla Manthey.
