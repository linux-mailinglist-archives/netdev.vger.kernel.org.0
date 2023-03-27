Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736826CA186
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjC0KgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjC0KgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:36:00 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BCB2727
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:36:00 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso4771231wmo.0
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679913358;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5q6u+/en5W/OizPNApBtoGQskHOefpjtyQjLNoH8Vpg=;
        b=OSuu3FAbqRlk7iDFyHjLFBPq0ACmrQc9Gw6qzW80XIdQw/nvvocaIoOKs300PYIHYm
         U0K7kc09zdw/CuX6SGAe3UZkVDPo0PJl1tS66xBw8Pcl6wYfoFRzeGzKhLxpHQgSQzmG
         j/BvxDyGbH/V1RsaZ5t9oPPth8LcDyESq5wMEOspTAom3PZBHMflOmgWDiLblmbePwdO
         v4c8qM6A9VqXye+1kbTIqLSYwFNXmUqGT15ty1OQguMhg12QUIVoY0iCURhck/dfT7F0
         Jc7m23bI+NBouFVXHOiz6+RoxSxFiOJsCa3cac2HvhkpegbCA1UbtaLCndG2iKDSTTcx
         o+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679913358;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5q6u+/en5W/OizPNApBtoGQskHOefpjtyQjLNoH8Vpg=;
        b=Gyjg7fKWRo/2nlxdjI+u4IXpU5mGE2R7nKpUFTlUE5mDsQF8lmlS4ygy/iRQsyW/9O
         rDzRqDr8cN27CM0sx5eMGxtEHlXzCsPDnpKKA+FmMSEFyvkVUo25j1FWSMBdlL6mBnTF
         sCAXBD+wieDlgOdpLrzkuXGSa2KNcF9ruHgKBETWoik9io9KnU985gco+LikDz2Kwl3A
         vAJmYjFseZimP3cj+9DBTfxlr+91PCth0LuKXZBjKAN0ksh2jnOyXXO5WCVLXGpPkRan
         IgkIC1+pir1wiaC0tdbPZUMk4BSsQQ/rPfrA9s7cmdd1lJf2xPB1XVeFOzsJNZPQ0eiU
         tefg==
X-Gm-Message-State: AO0yUKUNPhkJUF9gVWsqizE9a5PzQb1qIVJQDDNNKTlcSCmaaj49zwXM
        hmkfPQ1CiqcOe6uNzQXuN2YEgLY+wBSKck6JFT8=
X-Google-Smtp-Source: AK7set+7pW/Y40q58pdB/+l9kLOEj76aW1mbyshdr59uoXuVvmFoy1iJbDbWjQ1zBqzYZYFAHiEE1v13cRK9awufg70=
X-Received: by 2002:a05:600c:5126:b0:3eb:3998:8bed with SMTP id
 o38-20020a05600c512600b003eb39988bedmr5939223wms.1.1679913358547; Mon, 27 Mar
 2023 03:35:58 -0700 (PDT)
MIME-Version: 1.0
Sender: missaisha.gaddafi2014@gmail.com
Received: by 2002:adf:fb0d:0:b0:2de:d22c:b822 with HTTP; Mon, 27 Mar 2023
 03:35:57 -0700 (PDT)
From:   Mr Ibrahim <ibrahimidewu4@gmail.com>
Date:   Mon, 27 Mar 2023 11:35:57 +0100
X-Google-Sender-Auth: XYcL_I3dEw_g1GzhYreidzK-3mM
Message-ID: <CAHnzjr2EXsALaLZ5G_=Bk7FxGZ8P71=1jTmxmtxc9bKRgNW3Cw@mail.gmail.com>
Subject: OPPORTUNITY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.2 required=5.0 tests=ADVANCE_FEE_4_NEW_FRM_MNY,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,
        MONEY_FORM,MONEY_FRAUD_3,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a business proposal in the region of $19.3million USD for you to han=
dle
with me. I have the opportunity to transfer this abandoned fund to your ban=
k
account in your country which belongs to our dead client.

I am inviting you in this transaction where this money can be shared
between us at the ratio of 50/50% and help the needy around us don=E2=80=99=
t be
afraid of anything I am with you and will instruct you what you will do
to maintain this fund.

Please give me this as we have 5 days to work through this. This is very ur=
gent.

1. Full Name:
2. Your direct mobile number:
3. Your contact address:
4. Your job:
5. Your nationality:
6. Your gender / age:

Please confirm your message and interest to provide further
information. Please do get back to me on time.

Best regards
Mr.Ibrahim idewu
