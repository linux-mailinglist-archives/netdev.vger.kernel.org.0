Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A54B0E33
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242029AbiBJNNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:13:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238484AbiBJNNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:13:46 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491A81142
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:13:47 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id d22so2989292uaw.2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=NzzVW/1vd45RzDVBR4a5aawa+enykAibp41p99pWNHU=;
        b=ouNoeeJldTSf278b+1icpIWeqdKWnrA7bxzeTKeGh5zj0Lr03ECftB//b9mJzDU5os
         O7M8t9k2hKce83FaW2EE3Zu1V14+0ekNnCxq50ysfEUzg+Z2YYbA9z0rtXy+zyVZWrzh
         8aSzPkxQ5G+hfgSFLtuPvLdYOZ89QAOXF8CjyRSNo5+NBcREWt1JUI3upeONUX8vC9XM
         UiHPpw34AwEUPLsUVBU1ydT2j/vx7nUhjWQuv1PAv30Q+JUlb3lPXSVvsqE5oAlVqXUx
         2qgeOAKA8lnV3KPq98tZc+nebIFHS9RwRb6LBuly3FTLiZn8RyV+Py8eLAyvMSHWnEci
         b8mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=NzzVW/1vd45RzDVBR4a5aawa+enykAibp41p99pWNHU=;
        b=Fd3U7zEYNpsdidbIxYbONB/hg+AGDTZewACAbXWX4AUDLpjltBRmeUxTtAZjKKjF1L
         JUWgaw7l+psHOg4zZ7PLysbDhqp2BvQbBzwNdQtrPgFyFw/Vl8rUGFmM0vzewWfNH+sE
         MhKNH+KZdk9EAZjmCtUQ56+e0X/GANWg1kP13ewAl9gJrAa4OCiL4A57w3RHAWgkYvKX
         uBFSR6KVZayWW49dKQr5ATZLyQW3fu28OlluXDWOxTZrte9cbAGB494hlm0EgbRIf26D
         CA1rE97ajsQ9pwe6/3/nQK6xMA1sRL5JtpEk57kIQNL91xMGM8rSiZVzpd9uKNU4hEnq
         ZIrQ==
X-Gm-Message-State: AOAM530XziNQzqjXErRqd/f0+ndUkVAQPFFjqJ2y53c7iakmEIKW0xf7
        ScpZjhVbQcOTi0vvGT/7GzTMV7nuvQieFCGR5kE=
X-Google-Smtp-Source: ABdhPJzSrHxnAay6AWbruHrpqj5xdIhSx2X2aPDJYCSb0PWEgSU15Ag2oMWzmRAMISCBZUkI5jZLA051L+V/RC98tt8=
X-Received: by 2002:ab0:1511:: with SMTP id o17mr2393463uae.79.1644498824686;
 Thu, 10 Feb 2022 05:13:44 -0800 (PST)
MIME-Version: 1.0
Sender: rhodamohammed2014@gmail.com
Received: by 2002:a59:9c45:0:b0:28c:2fd3:12a7 with HTTP; Thu, 10 Feb 2022
 05:13:44 -0800 (PST)
From:   rhoda mohammed <rhodamohammed01@gmail.com>
Date:   Thu, 10 Feb 2022 14:13:44 +0100
X-Google-Sender-Auth: o2qnHJwDvtPiwxvm3Z-Mr2arn6c
Message-ID: <CAJ8HPr-paO_YDcLkStufxHc-L5uv+U7dJ5ebiFsAv6h8y8wiTA@mail.gmail.com>
Subject: From Mrs.Rhoda Ahmmed H.Mohammed/ READ AND ANSWER
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.1 required=5.0 tests=ADVANCE_FEE_5_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:933 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5004]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rhodamohammed2014[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rhodamohammed01[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  1.0 ADVANCE_FEE_5_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  3.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please reply me to my personal email address(
rhodamohammed89@gmail.com  ) for more details , Hello Dear,I am
Mrs.Rhoda Ahmmed Mohammed, the Wife of late Chief Ahmmed  H. Mohammed,
a native of Mende district in the northern province of Sierra Leone,
before the death of my late Husband,He was appointed as the Director
of Sierra Leone mining cooperation (S.L.M.C) Freetown, According to my
husband, this huge money was accrued from mining cooperation, diamonds
and Gold sales overdrafts and minor sales,I am looking for a Serious
Investor that will help me because my late Family wanted to kill me
and collect the Deposit Certificate and Agreement Certificate from me
but I run away from my country with the Documents,I want a God
fearing, honest and trustworthy person that will help me receive this
money in your Bank Account and Invest the money in your country or any
country of your  choice, it is very urgent please.I will give you the
full details as soon as you get back to me through my personal email
addres rhodamohammed89@gmail.com   )Mrs.Rhodahmmed H.Mohammed ,Please
reply me to my personal email address( rhodamohammed89@gmail.com  )
for more details ,
