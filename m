Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA53E57BACB
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiGTPvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiGTPvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:51:41 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35F64B496
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:51:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e15so21480386wro.5
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=48fj8+SEYseTJxEMnEnTvEGFV8gDAw0PWcc7VlH/EIs=;
        b=WYodSGXn5BRD4lcNm2IMZ+/DuGjmlHuhlcaHy9sNuG57HQLQ+pEFClgEtleaglz0GS
         ahoB7/zGo44BAUGfjvvNAxyx572+LJi7OkpzoPdJT3l5XGe7ewKHBwPDPc1IyzBSCdsJ
         /tJsciQ7cGY3i9WqBmEGbILi1D5v7opYbg95MM9qjRbJbztAz8ggDpJOkUfRw9LO+g+F
         GXXlKr6bLM8eCNL7nxiJ8HXe7mkQhSdx1CwtY8/xTNOfuwQNx+aMbW1oV9Q8x/j+6ayF
         NV7MW8/fo8s+bZBE2fjyoUVCdIprgoWvuL2kFlfC6i8W979R8g21Zqx4uuOW8rlghDHX
         w2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=48fj8+SEYseTJxEMnEnTvEGFV8gDAw0PWcc7VlH/EIs=;
        b=tqAZuCgEGztUxVBJFHv1+VVeTN5IPFQnSEgF5dih1HRlf3+eEC9pMlENotuUQITnCg
         yLN8WmrxXr49lHlUlpS2RGffYY0Dvpfm1uagjY5ZXu+dI8eFCaLdCjNqTu25DDgTa8NL
         xUQNbepiGTvPwR6d1QlWs3OTk7YPvm+cZ7DNYGJ2GRT5bb5BYpB1fZOZUK0x2KLOY39V
         BhiTDZ+5b8B5+klss8gheznW+cfjxkglPbOFI6oz7JtXmmNXh7tvS05J6UfFHWpkTAc+
         p6et5HwTpRJAL9mLpKl4t47OVsHkPC9c1ozkFTfqKUNxqOzveEWMOcVYZbW4i7lVf0VJ
         VZ2w==
X-Gm-Message-State: AJIora/F66h2yJmdeUO0/M33ZcKrI9OnJ15JYTWWvgK7HBAbzW1oRKpF
        VHvYWshJGaWpy8nsciKr64m8uy7tpF0QwV5h0r0=
X-Google-Smtp-Source: AGRyM1uMgNfwG3oPgy70AVs3PAuulAsDR0LVyWIpisZ1nu9c47PilKXxE0LYGSehSn8by+OCmgZ4k2XK9VrQAW6W+/4=
X-Received: by 2002:adf:ee85:0:b0:21e:485a:9720 with SMTP id
 b5-20020adfee85000000b0021e485a9720mr3301932wro.579.1658332299449; Wed, 20
 Jul 2022 08:51:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a7b:c404:0:0:0:0:0 with HTTP; Wed, 20 Jul 2022 08:51:38
 -0700 (PDT)
From:   D B <kosdav71@gmail.com>
Date:   Wed, 20 Jul 2022 15:51:38 +0000
Message-ID: <CAN6u_H8to_D5MEzecmP8TQW3V01oyJierV+5-ZGY=XBgbMM1Nw@mail.gmail.com>
Subject: Re:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Afternoon,
Please am still waiting for your reply on the mail i sent you yesterday
Mr David
