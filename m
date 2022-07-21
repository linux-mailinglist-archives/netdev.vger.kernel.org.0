Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4EC57D72B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 01:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiGUXDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 19:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGUXDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 19:03:07 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438958E4D9
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 16:03:06 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v21so3201746plo.0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 16:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=s2kCYD6a52pEQCxOoqjsFoNdEYBD06OR+vK3LBe9QaM=;
        b=2hZ1LM6/axQ8o9p1/NaUnK9MFmnm1IoDcPHqwXz38E2ogrj/gcg+50z6X7s8F+b9T0
         Uu6qcoYALVna30SEi4nst8DOZmp456nAtpsxfxCPWfKoPpcfxiw/KTQQFs9n2+oXYSyw
         /DRlk9Og6Qz6JZdfggBXP8ruPpSvcjiYbkorIIy0gdtGWr8UHdTTIfSZ5mAuNyhgROh1
         lk4PxWQGtdc9ZG4KHc1aVZPKfLo/i2N6fOl3P/xtv4+a67Fq8Zx89Arz9r8N3Y/+Kb0l
         Tq2SD50NR1qaNsTAyAQOZtuzBZEjS1ggaZOqEkHtLjn2YidoYIUAJi2pqX7khRLufnGL
         XYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=s2kCYD6a52pEQCxOoqjsFoNdEYBD06OR+vK3LBe9QaM=;
        b=Nd5z8oYCbBkbYtwLW67rHaaX9rKxBn/mpG+5jV1Ieh2kpoPcltWMH/3Nr3RPfBrReT
         gGoZlet9ZFDTNsh0MtopQF8sBR9h3gcVjAYgw4dWLMQxZ+Tw2WIU7srpNmdPUKnRroEU
         qkNvQ5s/CVKKMM1TDUiDfh3+KmsRpXXBmYXgk6p8S6+anWCzxT294d65RxHV2ncqFlXb
         DjAOoavpcy2uBEM8OXV42Y1LNXv70M84ybYi0K2bxjNhaZdT3wGfXPuYdy19DKl4qVga
         YI+87AK7dl+M+9euDgYDSMQg+ZOyZAhEg8L1fkuqS8XkLvGThvu8rlPDiQAWZA9R299a
         A4ew==
X-Gm-Message-State: AJIora9BoyxNEj1unfuwIcSAULQfn4pHmJhpQLqbSPEY5/ZA19N3Y/ur
        Z3EttYCdkZPRaOw2uCeb5EA8CevaUrg43Cm9G/WV6CROB/ZBThGL
X-Google-Smtp-Source: AGRyM1uv/6CEE0MPat0gHY6TKFIZjamfZIInAA9zHa8bI5xROGRuQP4T8b8V9TDusb3xsgA3dIsjpJtd8z2yhot4b+A=
X-Received: by 2002:a17:902:c189:b0:16d:31c5:12f0 with SMTP id
 d9-20020a170902c18900b0016d31c512f0mr573322pld.90.1658444584968; Thu, 21 Jul
 2022 16:03:04 -0700 (PDT)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 21 Jul 2022 16:02:53 -0700
Message-ID: <CAJ+vNU3Eu8Mv3ErH=mw0o2ENcEoWXLXWXX-_mTTg3vDkmnGrxg@mail.gmail.com>
Subject: imx8mp fec/eqos not working
To:     netdev <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

Does anyone have imx8mp fec and/or eqos network support working in
mainline Linux? I'm finding the device registers with the kernel and
link detect works but I can't get packets through.

I'm using an imx8mp-evk and linux master for testing. I find both
fec/eqos devices work fine in U-Boot but not Linux mainline. The NXP
downstream vendor kernel imx_5.4.70_2.3.0 branch works but I haven't
been able to pinpoint what is missing/different in mainline.

Best Regards,

Tim
