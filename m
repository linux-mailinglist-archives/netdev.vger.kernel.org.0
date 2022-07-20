Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534C757B96F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbiGTPVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240966AbiGTPVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:21:08 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966093B959
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:21:07 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d8so6638605wrp.6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=C0rDv/ipVopOm17ii05Mpxte2A9Yf4I/7LluSTqFJNlQitXXnc4lyIC51wDrZ9h7aI
         CvQV2GaKJ4AqF4tZ/oQUo5HoHx9V9SftREzE+4GdtuElZd0ffyF2fO1wmje/CneJDU5L
         doM7S1eSJipGXM8tIcJ4ZZtBbrRDtItugrzdoIQPCeO36iYshdRqDYRH13RIrLOPsqgI
         c+Bko788rmQgLoJ2aKuduT03xWDy4KFmU0rh2OvnXuGkUJLdhoUSVjMNzT/nuWe/J9Us
         ixMguHd+4TM/vqtxzdvXtVl44lEUwhBiqTDnffj/vmY7/DmFtKo6fDzNBqyzvE94YI17
         dNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=oSVlRYmZVVl+ZGlAfk6e0oAwVzai4vgpyF2fBXZFPvWKgV0+8GhmCKPo9Yit+w4mG0
         K5toQ2OkQAmoFzCCfJVLRL4eTHbJlei6UNW6/3++M80kwDkdrCDYYOkI61wHu6PnwL+7
         WGhdztcOYsTlPCQsW7NClIOnfuROipZJ1vTlRaO7yktiRz1JWif/l9gMc0rHwpOJi8xR
         G5Zf+ZUm8qa+mbJXj8vKVmLb0uKLgEP9dIN8zXZWFMvVNqPpw5BhknbOVZSIc2xde9aw
         nkGWXpDYAGDIo9VmMF5Z96b9x2FjVss2pWi1RRUOfBilhbA17QnVQwLqvjcEBsHmS7xz
         +rsQ==
X-Gm-Message-State: AJIora9lwJGrH7CNQxO10Ud/rSrzRLyLRP0H7/RGvkM8+5fmv6hjEpj8
        elZcmkIJ9y06IkL7V6EXYpzl5Pwq2+FHsBFgmTPRgHWPcat0uQ==
X-Google-Smtp-Source: AGRyM1vVxjClCsHqicrpc8pzGH3trRNRbV5S6vKiGBxNKAJgxObXCw7ARMTya2g3JPfVcVHlOJDMmGzwn6Io0rM5cBs=
X-Received: by 2002:a17:907:a072:b0:72b:57dc:e84c with SMTP id
 ia18-20020a170907a07200b0072b57dce84cmr34626027ejc.579.1658330455811; Wed, 20
 Jul 2022 08:20:55 -0700 (PDT)
MIME-Version: 1.0
Sender: modumaajiyusufari@gmail.com
Received: by 2002:a05:6408:1551:b0:198:d808:8e96 with HTTP; Wed, 20 Jul 2022
 08:20:55 -0700 (PDT)
From:   Lisa Williams <lw23675851@gmail.com>
Date:   Wed, 20 Jul 2022 16:20:55 +0100
X-Google-Sender-Auth: Zx6qRqsGttlNnwbGtXFZOM96DSc
Message-ID: <CAD5cse3Tf0FwOXp9bSQ0com1stEc9DS_3oK-Nd3q6LGsVkyq1Q@mail.gmail.com>
Subject: My name is Dr Lisa Williams
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lisa
