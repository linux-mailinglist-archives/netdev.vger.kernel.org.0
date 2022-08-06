Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4558B605
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiHFOSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiHFOSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:18:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8F411A22
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 07:17:59 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 12so4928481pga.1
        for <netdev@vger.kernel.org>; Sat, 06 Aug 2022 07:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=2ER2WW01ET2wH1WV2jGlyhputEhjwKA2tNpxchjmONE=;
        b=ilBHK/J1hqBrLwaUKoS8EYROLGxOsh8/TetRDPMcw5OKVt1sYjPRC14naiiR/o3Ip6
         s6jBHW1mqjLgctZnVk1xbbpcHUl7xD15F6PEjZk1fq3QKDliBybFw4+YW8xoidqzda6S
         5izDC4d4tdk/UTTbb/8PzL/uKDb7NLTsJvp3uu66x8yh0fdFY/w1tv952+8H15jL8tZE
         gcHZQ1bvr0+f2pNWdOTzZFmGS58oZmEf4lGaOos3meO3faILK1LmKvlwxHT6+0iPiWtw
         iaDNyoWo+JewELqUa1tyWxUq1qK0qk+tQhixLIvD5u4HS4PRzecdcSKIbSxE0vZsLkXI
         nUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=2ER2WW01ET2wH1WV2jGlyhputEhjwKA2tNpxchjmONE=;
        b=knm7rIJt3PPp6UTbZSFSqbDWzo1lop6lhprX/dSqOZwJMiL/KhH4OtKquEdJq2E233
         5wkNhXa9GkwkMPxP8u1rtyN5apKNrFPLa1lDE/GoR0N4PwzGkLfcdivXkNdc2h+BmU72
         IGZvNwBsXb4BHApTCeq2e0vz9GLEaAszuzA7fGLzhqHUU5UmhtTXxRDfAT6XI4HVFx09
         5q2ij3ima7Vik33gdQqRZLP7Qn5lRGQRXZMs7WiVUJ3vhlSAoR7MwrYinq80ksUDmvaG
         2su5UWkKf3ggZMcUM1JERiEmbO35XHMVvxr+XaCZAcgcu/LFDdehILDnnBQ6f4Qwdjh0
         QfyA==
X-Gm-Message-State: ACgBeo0hNICnKt4qNfAs+ort7E7kpYx+zx7HYRz1YnHdUpujJeKx/TdC
        PWP9XIcmXJCj8yEpYBaozOUOy1tE3tiDR1vyJ2o=
X-Google-Smtp-Source: AA6agR7GJ0h0MJELxsYYKhiTwpxLW3fj/5EWjqMttjrQfxl+crfStxypYNqc0Mwihp5VyEpVvBi59KZ82omPy7K16EE=
X-Received: by 2002:a63:8b44:0:b0:41c:df4c:7275 with SMTP id
 j65-20020a638b44000000b0041cdf4c7275mr9595528pge.434.1659795479172; Sat, 06
 Aug 2022 07:17:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:902:d50c:b0:16f:14c5:2d63 with HTTP; Sat, 6 Aug 2022
 07:17:58 -0700 (PDT)
Reply-To: Drlisawilliams919@gmail.com
From:   Drlisawilliams <furlanamanda467@gmail.com>
Date:   Sat, 6 Aug 2022 16:17:58 +0200
Message-ID: <CAF=1E6Ua1Mqc1ZdkdiczVgi+ajr0+U3JcKWxnDXb_E8fX3L_Cw@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:544 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [furlanamanda467[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [furlanamanda467[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [drlisawilliams919[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
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
