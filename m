Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8543861484C
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiKALP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKALP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:15:26 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C295925E9
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:15:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a13so21324669edj.0
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 04:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMoJiIYg0efDU5sJbNvPQeE+VSky9YZdIg/0trECDYc=;
        b=gwXDLpxvvb78dycYG7jKHDf/binuLoUiEdhpI6BSyTOHMeQAxG0Km3YSaDSUPll6fn
         DgmC7iEOCA4x6YzyVDgE3GrfRI8u21E5kym3ZunxbHY0cWKlDUIEz5UDI9PIlly9mqw4
         iPwfZXPwuLuEdlsEiFUdww9MyPlbTdLDWWo27bLvKpn5yWRpYNthoa8OPa6dTxG5rMY6
         Tj+dV3CrZ6cGbM6+EduueAyNmCZElAWoLB/ZAt+2ExX/ck0jDtJ54kQgDLGHCNFhskC8
         zgpYAUa8yFis5CpF0Jm4hZiapW/6gGxFFg/t1jUUyEnFhxm9/wnUtNAxRd32+h8ap/35
         HVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NMoJiIYg0efDU5sJbNvPQeE+VSky9YZdIg/0trECDYc=;
        b=lXRUOwy1J9y2HbFz1z9ty3hgzPEJm7lhAZNSuC66S4wzgjigNFRfMB6S392AIa8IQY
         LF0z8oZjzH3qwaYLnkpihUmABKVMjGdY/Y+zCSIrXtQaClBxbGjkIZstORTh9ajyp3sY
         07kL7j+fyhfHaBTW079Py5GQbjAL9wHWK8DHo5ungUI8gxfQwRQQzut3zy8FUFWQC/1C
         uDvDvXCU1+UkWqsJc6fFmRhG/oXMjaCor38ntdpJgMHLNSMZrO6Vpx+cQh43TlokaoeD
         fTkma/N6oa1Vb+1wq/0i45/HwgRVYvhi+p6Ev0JF3BcRG5u2/PNKj2ywkFsLE/TjA5sL
         DBSg==
X-Gm-Message-State: ACrzQf3olApoEiWIQh5gjn0D8smIZtikVy7LiTbiWfOl7tAJ9hz8eQHY
        0Gp8REHVM4zRfhUfh5/KB5xUz+pbTwV0vO4QMBQ=
X-Google-Smtp-Source: AMsMyM62x1HAAiv39OUXwj/O25gFR7zV209ZsPTqzjhQVi3TCFzqcWUIFOWgDRU/42py2DCvWhMoGMbeSyI9BCYSVFU=
X-Received: by 2002:aa7:cf0b:0:b0:461:2271:8559 with SMTP id
 a11-20020aa7cf0b000000b0046122718559mr18770533edy.92.1667301324038; Tue, 01
 Nov 2022 04:15:24 -0700 (PDT)
MIME-Version: 1.0
Sender: mrszoraisla03@gmail.com
Received: by 2002:a05:7208:4293:b0:5c:ead1:341 with HTTP; Tue, 1 Nov 2022
 04:15:23 -0700 (PDT)
From:   H mimi m <mimih6474@gmail.com>
Date:   Tue, 1 Nov 2022 11:15:23 +0000
X-Google-Sender-Auth: I1wUWQzPG4DbAjwcMceZ7IYzbQ0
Message-ID: <CAOoxkms+x+VaSsxkLdUVAg_Wd9yfgnh+5Jh2OXMLF=TsSt3xfg@mail.gmail.com>
Subject: If you are capable to do this business with me, please i need your
 immediate respond
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrszoraisla03[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrszoraisla03[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52a listed in]
        [list.dnswl.org]
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 FILL_THIS_FORM Fill in a form with personal information
        *  2.0 FILL_THIS_FORM_LONG Fill in a form with personal information
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If you are interested to use the sum US$9,500,000.00 to help the
orphans around the world and invest it in your country with the below
information for more details:

1. Name in Full:
2. Address:
3. Nationality:
4. Age/Sex
5.Occupation
6. Direct Phone No
Warm
Regards,

Mrs.MIMI HASSAN  ABDUL MHAMMAD
