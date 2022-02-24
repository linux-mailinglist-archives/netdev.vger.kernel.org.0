Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3E54C20CD
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiBXAuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiBXAuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:50:01 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86E9EFF91
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:49:24 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id i6-20020a4ac506000000b0031c5ac6c078so1156648ooq.6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=9oUhhe9WhBbu4JoH4Pz+I0OHBn3Qr9dI0a7PR0a2whk=;
        b=GHkiLuN+7SFVKNZQgtg/MjpNFOROGin7DIiHPUSfJbl3y1+N0Ed4YUgs7gUwnAxspS
         rpgWs5axgemlKIIuUEaT9dVw8YH9ilVCNoNlb8Fg2WeqsMmZOc/zpGsMO82WsiPJfDWT
         asTB7fJ9JvU3s+f/BzM7VvbjQJacQuOFILF7iVBcu6fVD8Mpv2JinZjBduTp57k7d3xD
         1yJsZpIJROtG8vZvUFcFeBpOd7/52qvFEvU06MaeIfn8ewVFPpkEyQTHE/mr7aBfj8LK
         pZy/0Q7EbBoZv7ZUKEPabP3lnoGvb8DnhMBsrF87frOhVPbiZXIQAIwwVrUjHjC+OH59
         H3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9oUhhe9WhBbu4JoH4Pz+I0OHBn3Qr9dI0a7PR0a2whk=;
        b=TA1XSi5FAz31GpJpN1B7uN9S3nXmLb+f1upFqstudQpOCHcZFfFPnaKjlghcD150DW
         smaHV+/dPuvqhAK2DLR9a8oDQSNGRghFVPotBL/7XIpfNkdG/2NthmXGLpgbzO6KSUh8
         bswmTA04O+HaiAr+lu1BNx67JN2ZXy8kLpE5wemXDsEJ8CK1LzVaxIdwD4yf6CXKwU+H
         f6ugQYjY6w7g8ix/N+06vxq3TiADbGQUn8cyDhVp7EArG+m3p613PUCtv2xcEauDZoQ8
         l25WYE6VVthxEDZn67KfhPGGsbceCIq0eDY1xa31DJb1UMDDxWkfPi/pxrSwYCuAdMSY
         fswg==
X-Gm-Message-State: AOAM530Ttfq58yg0+Vyvxn5bH5bfQVJ//JRa3sIogXZnXrRP2V1YfB9p
        RV4EnYIakapujlXB76kVN5VaWQFid1D/hj0IZps=
X-Google-Smtp-Source: ABdhPJweayhREGKrc8UPAkRCHe6p2GcLq7d9dRkdh4uKizv8jJc+eLR1auaUDp37BRyMuR3beawvxpRThL9S/6fDDeY=
X-Received: by 2002:a05:6870:3124:b0:d6:cbac:6900 with SMTP id
 v36-20020a056870312400b000d6cbac6900mr53620oaa.24.1645663629805; Wed, 23 Feb
 2022 16:47:09 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:7c48:0:0:0:0 with HTTP; Wed, 23 Feb 2022 16:47:09
 -0800 (PST)
From:   Miss Reacheal <yaovialokpe@gmail.com>
Date:   Thu, 24 Feb 2022 00:47:09 +0000
Message-ID: <CAHEe1Kp53BehTWMNQASxJG5vKhz_zpdcQ5VF15X0pYkWUD3B_A@mail.gmail.com>
Subject: =?UTF-8?B?UmU6INCX0LTRgNCw0LLQtdC50YLQtSDQvNC40LvQuCwg0LrQsNC6INGB0YLQtQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

You received my previous message? I contacted you before but the
message failed back, so i decided to write again. Please confirm if
you receive this so that i can proceed,

waiting  for your response.

Regards,
Miss Reacheal
