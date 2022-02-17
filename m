Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60154B9BBA
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 10:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiBQJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:07:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiBQJH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:07:57 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D561907E2
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 01:07:43 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id w128so1962810vkd.3
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 01:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=r1zJaBUPNQBJIkixJM/WVkMBxWgtgajvPcDkUoia8nw=;
        b=ahrYWAM9b3GLazwNBT1EuFsh5VaPSct5jBhH1zitDdhIFCEvTQiHUmco72sFzmCWVV
         QzBMUv2tNkOE65yPD/OJ3gMZaaisFl1lBtJB3cEwZT5OhiLl7UWVMzkX9ko6dXnXAxp0
         Jvgh5mmhWHeLRDIisTnGgCWZxJxErtsqlriyZ5SYNi5wrzalACu/qDDTm2BkcP4vJKYv
         6hCYbhrZRU8meEiI9y7hU30VNqdXa3cxnOVrYUMNwQwsbdU5hxNAY8yqInmZiK7U6eeo
         98mA9/SPzx289i8CsRa3JIm5S+KhTlQ67smUuQB6oK+aZhsKc+irYIe3MQ5rvWNGsZ+a
         I20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=r1zJaBUPNQBJIkixJM/WVkMBxWgtgajvPcDkUoia8nw=;
        b=4+o95j4B0cRZ86fpHiaPh+neI+V6IcoazOJ8QtkADy6LG3opNHg3o5KOFjGKTcUERd
         wWz2AWPD/6hHOt3+PQInmn7SBnstx3Ghn4BASZAbsKA3SbWq3tIK5wM/+HW8TOYRU8TZ
         Myb/jVLCJvih9WdaxgCxaItiAnHBu+A8BsVI6idTokvp9Uo6so9jkcIy9o/zFR52hUWG
         xl7TamSrCxifzrDpnQmPF8F/PbEi3EGaT5TSTp3zX4XC5UbtWGdfXO71chzILqeCKCtV
         SCchjRD/NDsArFzbP+r1we6eZD/aOS8UdznMP5Q/6VpAtHkuO/kNtq5rQOaV8SU/2ALh
         glMA==
X-Gm-Message-State: AOAM531LJjj1Yl7WL1wibL3o8A0yNwb7wNiTE/RlQa4i91bvTiuqbAde
        yU/DQTyySZpER6COUE2Ag+L5cebU4Vir68+WM3k=
X-Google-Smtp-Source: ABdhPJzmzBlTVhuyZpG+E4qv5abkmbk336fXpkhQAz7jq0lPyKvWhxHSROavXvqaIfGLZopGxejhm4NqMlzx4agPB6M=
X-Received: by 2002:a05:6122:c8a:b0:330:d0ab:716b with SMTP id
 ba10-20020a0561220c8a00b00330d0ab716bmr714894vkb.8.1645088862163; Thu, 17 Feb
 2022 01:07:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: wallaceharrisonun1@gmail.com
Sender: misaishagagaddafi@gmail.com
Received: by 2002:a67:e0d7:0:0:0:0:0 with HTTP; Thu, 17 Feb 2022 01:07:41
 -0800 (PST)
From:   "Mr. wallace harrisonun" <wallaceharrisonun1@gmail.com>
Date:   Thu, 17 Feb 2022 01:07:41 -0800
X-Google-Sender-Auth: 5_9EsjgL2vZUokRPppSjr5jOcpU
Message-ID: <CAM8sdMYvJfjLh0Ej=ucUA4=6mb2UbdrTzVRfjZhuCNXJSez75A@mail.gmail.com>
Subject: Palliative Empowerment
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FORM_SHORT,
        MONEY_FRAUD_3,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [misaishagagaddafi[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wallaceharrisonun1[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.8 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  2.9 MONEY_FRAUD_3 Lots of money and several fraud phrases
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!

 We are writing this message to you from the United Nations Centre to
inform you that you have been chosen as our Representative in your
country, to distribute the total sum of $500,000 US Dollars, For
Palliative Empowerment in order to help the poor people in your city.
Such as the Disabled people, The homeless, Orphanages, schools, and
Generals=E2=80=99 Hospitals ,if you receive the message reply to us with yo=
ur
details, Your Full Name Your Address: Your Occupation: Via this
Email:<wallaceharrisonun1@gmail.com>  For more information about the
payment.

Regards
Dylan.
