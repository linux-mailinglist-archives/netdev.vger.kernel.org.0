Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EC46D3C8A
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 06:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjDCEmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 00:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCEmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 00:42:36 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B77C8A4A
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 21:42:36 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id q6so12337924iot.2
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 21:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680496955;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a+ZUuxUTAoz+nMDIAxIHUE5qjUM6hZWQNbOQhvaBX2U=;
        b=YcS9AXzIsZqy2H5nPgG4m+qSAoj4vulDRClsjQma9857tuZT5BBy8uz3OURPguoT4+
         1AKal0s1FvCVVr52raUmQREpwG5TdTIR6YP7acWZz6z/PqkmjkzD1qiMdEFim3qo4jRj
         ZhGC8aGvWiIFfhnsXNmXde8DtjFTdo31fpUMvul3+SgZ/TnwBtxlGCnyZo8914bhhQq1
         uA7f01+2QNkBjnTBGssSJ08gUbw3Bid34RWTa+rBfc21vskiP0gvGER/tIgxXYMWzjIR
         6yjQ0sRwJHKIyp6b+aLxBKhoKNB0eBHh+EeVWNLz06wGsgAxLBUKdc3mUaJUbozYuTuN
         SB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680496955;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+ZUuxUTAoz+nMDIAxIHUE5qjUM6hZWQNbOQhvaBX2U=;
        b=BOfSOrVlnLNrVVUk8vxHn0OQPWLnyAMswOV+pjUcHEFy5TZ0RT5jogz1Y3OKPMT05a
         UwxckgqyJuozFP5C/H0XhxmfV46gSIr5Hdp+ZjA8DVA0umX1SqdcV03AhSOQ+d4V2nS/
         CU0ms5Ymhw83fU/JaA+qfe4YSK48I+VGmIXlWBngB8lqW1CjL4IqnzV3X63gutmQcX7m
         19XIS33R99LEraqJvzSD1WQtC9pSMAh20drY+BIofWDkWSkkSMKPZYKydl5xdnBM1or1
         bP80oX0sYw3/zeOwQG46oUe85bZgLk0bDss0/XJ8LjJ+gz2jUrTeaVjBhEM42NQyg3M8
         41Og==
X-Gm-Message-State: AO0yUKUpk7112vlauO8HN8BMEOyZ59UvPrT30fMZ/thm6mNSkabfeMye
        N4PP5DgRiNhma49rtFD9jHtRlKnXYMLlWI+U9uY=
X-Google-Smtp-Source: AK7set+0/PZg0kJzt2raUsYkCxcpds/syDlZuPB5EOh9zcBNx9DAgFRfm0DaQF1hjuYFODx/kZufPFZunQRUddnkDQQ=
X-Received: by 2002:a02:228c:0:b0:3c5:15d2:9a1c with SMTP id
 o134-20020a02228c000000b003c515d29a1cmr13062666jao.2.1680496955237; Sun, 02
 Apr 2023 21:42:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a02:b605:0:b0:406:a977:88be with HTTP; Sun, 2 Apr 2023
 21:42:34 -0700 (PDT)
Reply-To: ch4781.r@proton.me
From:   Bill Chantal <blc1427856@gmail.com>
Date:   Mon, 3 Apr 2023 04:42:34 +0000
Message-ID: <CAP=Yh0vZPaTEXPJroL-r17yGH4yUVMSuwqJr0fC=zRp9WRyWOA@mail.gmail.com>
Subject: SANTANDER BANK COMPENSATION UNIT, IN AFFILIATION WITH THE UNITED NATION.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        HK_SCAM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_MONEY,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d31 listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [blc1427856[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [blc1427856[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.8 UPPERCASE_50_75 message body is 50-75% uppercase
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.0 HK_SCAM No description available.
        *  3.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SANTANDER BANK COMPENSATION UNIT, IN AFFILIATION WITH THE UNITED NATION.

Your compensation fund of 6 million dollars is ready for payment
contact me for more details.

Thanks
