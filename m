Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A299584C0D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 08:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbiG2Gep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 02:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiG2Ge0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 02:34:26 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EC582130
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 23:33:20 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id o16-20020a9d4110000000b0061cac66bd6dso2694587ote.11
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 23:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=u+aJzgLKYxCxG7diYbe+MxFeFJuQsJ40e2yjkxXDdZM=;
        b=lNoJkg99EXxXi5pWRd1AFgPe8h/pLpl21llOyww+M4TWweXqiUAEocn2hPDm+QUhI+
         1RI9Dgn71lHklTybJe+mv4zJfcjAS6qwAqFd+GGl/c7c0O/tQAk4+17yQ3pvPqqWlREu
         8TvWtU4DuZk8O0TWahkrEGGnDb3PzJHmkAU8Rmxnei4Xi4TgEzhURzrwzNPxx1KuF8fE
         eRGgU5VnJinKNlVf6fWjXbEjOdH/7VtkDDvk4z5hW/lytYadaiO7BGN6aRFxWYXkD2m5
         aG194Gasnaep+Cd5DddK7Mm5aD0vRjnRY7ndHcRXMrYLPdfgfT+QdvEE5nH+uEEzZc8V
         IKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=u+aJzgLKYxCxG7diYbe+MxFeFJuQsJ40e2yjkxXDdZM=;
        b=D3xhqgBIq87k28PBzGHqhn4VzGxZn5mEiKHh373+y7rCoAlVTS0f1lkVYmQXfN1Zq2
         BrHY8XbwEEL9zIG+bpLKn8y7IWibvF8My3MMnaP8eqiYcth1N0KpgeU+hG1zVwibXbQ0
         h0Zf2pr5HDnRpO4VSTaj7lDsVZcypcF3/NSgV1bEVff6uv9ykZ17dISjDCT1ZZJyccDF
         oFW9f2DwltaXAB4muv+FNfPKzQ8fwKDdd8GX+BP4BOUI+PCt9WQD9WgE7yPm4f/ctTvI
         yA7Gz3CW78a3r99BvnFWwP9+P3DbBe0E4761vtmGIzV7Y9YNLRCvlhQI4n1vJtvWKU9+
         TGmQ==
X-Gm-Message-State: AJIora/qUneSuaoTX0tSCuNlxkhSgMbQutjLtbm5SiW8ZJ+oF3yTM56t
        GG0HUTeOzaYrmSWZlnIZXs0PM9PoRsJxRIaIv49wg24I1+xcxc45
X-Google-Smtp-Source: AGRyM1s/1b6/UmBwa3h2/Oa3G2GQP7NjKP6miACspRo2ARPa4T2I0AQZ4H2xPnDYRUsXsN4mO8rQJSu5rh1aYa8Re/o=
X-Received: by 2002:a05:6830:280c:b0:61c:ae90:2ae8 with SMTP id
 w12-20020a056830280c00b0061cae902ae8mr921653otu.251.1659076397409; Thu, 28
 Jul 2022 23:33:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:4409:0:0:0:0:0 with HTTP; Thu, 28 Jul 2022 23:33:17
 -0700 (PDT)
Reply-To: stefanopessina59@gmail.com
From:   Stefano Pessina <omololuisiayaka784@gmail.com>
Date:   Thu, 28 Jul 2022 23:33:17 -0700
Message-ID: <CAA5MpVYOhJfxSqVaYL63By9i+MJcEvJ6ONNKFeaY=Zx2XnY61w@mail.gmail.com>
Subject: =?UTF-8?Q?CONGRATULATION_=E2=82=AC1=2C000=2E000=2C00_HAS_BEEN_DONATED_TO_Y?=
        =?UTF-8?Q?OU?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:341 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5890]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [omololuisiayaka784[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stefanopessina59[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [omololuisiayaka784[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm Stefano Pessina, an Italian business tycoon, investor and
philanthropist the vice chairman chief executive officer (CEO) and the
single largest shareholder of Walgreens Boots Alliance I gave away 25
percent of my personal wealth to charity And I also pledged to give
away the rest of 25% this year 2022 to Individuals I have decided to
donate =E2=82=AC1,000.000,00 to you If you are interested in my donation, d=
o
contact me for more information.

You can also read more about me from the link below

https://en.wikipedia.org/wiki/Stefano_Pessina

Warm Regard
CEO Walgreens Boots Alliance
Stefano Pessina
