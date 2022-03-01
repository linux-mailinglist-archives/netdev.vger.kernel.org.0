Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE224C8907
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiCAKM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiCAKMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:12:22 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459D38D6BA
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:11:42 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id bm39so12596628qkb.0
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=MUtd8G+Pe0V8JRIEIDk0lg9RnQsSwrkz9lTrZ67/YuY=;
        b=IBjr2oMrWUceEWJVU6VaurbJoqSCxgR/Qo+9mx/p9QSO5iZV41Nndoa+oBNhW9zF9k
         AMs1Vjxrt8S7wym/r37IL0yxvbF1ggCecCjujJ9YZn6VVC5Bo4lRfQChnNQczwPMFxMk
         VSmYKw0q1fmI5qj0J28zDt0rCSHwpwyOBZIfxzuIEC76tDLQ+8A+LKxZodI/dZXjfbJG
         yfDrOzacdei2zA3lgVgSF9UKuJHYEnrMRuzJqljO+YhT7yNVguWFduj+8vjrt2F4yFxO
         a/Co50RFngAEiknyMnTZNHyEIvtSPkRhLHWOAOsvHRwyvomt+L9mNcMlLKUVIS0mXdrx
         5xRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=MUtd8G+Pe0V8JRIEIDk0lg9RnQsSwrkz9lTrZ67/YuY=;
        b=zHllEQmDmwiP+z65IO6PJvn8ucBuKqxsknYDI3Ar5UN7Fh+P+iH+reMwAKOVJylPIs
         9i8Yo522wFdDzbJR/7TjBj63UKk40lypv/NyiJOkqQeioL4bwPhszWRPUdK83HYp9umJ
         WXqfuEnQ9cR4y2rQzoi7+bQGphC0ey2Cko5N6lwIV7fO4tDSazZnC8MKS6jb8+VU8Fj3
         5AkNhQDjsNphYjiWMt172ShPmyG5PSdHWbhCEfX+fNlsOKerUQNV3L54RX6Xyy9YPHGV
         V7lhfxPTZb3pftTyKG4ZguFMTM76yJtTlgV7tYDiFfSRllmJ8OSXcm4eNdJERcE5wOXv
         9L/Q==
X-Gm-Message-State: AOAM531DHO9l7/uq3SU+5w+/Xyy8c9I7Tnh+hDYCUzFFoPCXSL1TtXFE
        VgHCq5fH2Ai2IdjFadlY8IdC7xq4VjnSGTp6X9Q=
X-Google-Smtp-Source: ABdhPJxgdc0O0gv62ZV7s10DjlCct8BQdk8IH5oK6x05IsqpytYbaf/Ny/Dh+Ik5xreP3ey9wKvS9T4rmQsC6tDNK3k=
X-Received: by 2002:a05:620a:a82:b0:508:b41b:c44b with SMTP id
 v2-20020a05620a0a8200b00508b41bc44bmr13411558qkg.100.1646129501050; Tue, 01
 Mar 2022 02:11:41 -0800 (PST)
MIME-Version: 1.0
Sender: kone740150adama@gmail.com
Received: by 2002:a05:620a:448f:0:0:0:0 with HTTP; Tue, 1 Mar 2022 02:11:40
 -0800 (PST)
From:   "Mrs.Yunnan Ging" <yunnan1222ging@gmail.com>
Date:   Tue, 1 Mar 2022 11:11:40 +0100
X-Google-Sender-Auth: 92TYFFwUwr4nZRGweARFHq_sNsQ
Message-ID: <CABZuru=8o2ny59P-bv5i=zQvO7PuO2ZgUP-kC+O7WxeX_sBvgg@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it with the critical condition am in because all
vaccines has been given to me but to no avian, am a China woman but I
base here in France because am married here and I have no child for my
late husband and now am a widow.

My reason of communicating you is that i have $9.2million USD which
was deposited in BNP Paribas Bank here in France by my late husband
which am the next of kin to and I want you to stand as the replacement
beneficiary and use the fund to build an orphanage home there in your
country.

Can you handle the project?

Mrs Yu. Ging Yunnan.
