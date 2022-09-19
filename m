Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE205BD596
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 22:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiISURv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 16:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiISURl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 16:17:41 -0400
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA014A125
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 13:17:41 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-3450a7358baso2937727b3.13
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 13:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=PbJaF2Xe298LcCrOkcxIMTcsECcWtDqVMCE1wJTlLLqlpDgrajBJjmUpZkHJ5yLfbC
         /LGC9/KYQQM070TpkkueuxRRKg4Jxjw1sx9pBxy2kTO66/36BX35CnTwIGKcEafDLgFb
         nq7e3isWyU4nIUmoS1uAI65RcqgSXSR1ZYw+xP6B3Udk8ymyfSq3sph9dyQp5RyvSdSR
         TD5tcNu4ag3wZM/m+opYGbrS8tSo2tmLLAqINEr9Nqeld2lS8tZ3hj4zZdm1qU+Asn73
         ccjQxztkgpN0xZnS0cXXHKdlN4ZVsGudjrKRR0hXpBHoHDqPM3jV4m7Q3a3bDyqLEamh
         7puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=AQfbZTwQyJ3XfMXN7zPriK+uViJRpshkQ21pA4muPb9+u3gNbpug5qNNdimiABt/DN
         4bQkjaZel4js2JJ36KhQ9UfufAQwuazGTX/GjBu5K23sOBxp5OrVFZeu6L1qcgeXhioo
         fbI/7y2gl1k2uNUPjAWFBspIFAn5t7GkUZrGvBG/+pycv0u8909bRVxCxMwXm94qNb4Z
         EoNsFughIDI4RdLLUjbVIT+3xR60vfwpJMKYnkeW0Ymp2a290Egp6hJy3/QjiCa58yu0
         hBpW873LGSZfBtInk6O6ncVlkYrMa1Ozj3ZgVwhnt3/J4rYmCdmHCA5eyeoO5EoblwOj
         osYw==
X-Gm-Message-State: ACrzQf0GdASmI4toe0wLHkHnlQtBqjKlkxFWjHvOSQmcnhHe06SCqWLB
        vacVk1IA/fhNV52Qmrvne4LIkxtQlcUZhbkZ8+0=
X-Google-Smtp-Source: AMsMyM4l/cEHTrnHtsS+JRoHlDgVoveiQs09//JBgZ3QTEXxMMGDIpQBqPJUSqi5k2zFD9d4l34Um5BIJynlAkijEQU=
X-Received: by 2002:a81:2555:0:b0:34d:dfb:48b with SMTP id l82-20020a812555000000b0034d0dfb048bmr3686575ywl.390.1663618660104;
 Mon, 19 Sep 2022 13:17:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:289:b0:2f0:1279:d56 with HTTP; Mon, 19 Sep 2022
 13:17:39 -0700 (PDT)
Reply-To: lisawilliams46655@yahoo.com
From:   Dr Lisa Williams <daouda76104963@gmail.com>
Date:   Mon, 19 Sep 2022 13:17:39 -0700
Message-ID: <CACGepZU90h8e3CnO4Qh3dnSB61PiDfSp+NFPqK51VvuizuNg5g@mail.gmail.com>
Subject: Hi Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1142 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [daouda76104963[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lisawilliams46655[at]yahoo.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [daouda76104963[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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
