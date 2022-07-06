Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB94569534
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 00:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiGFWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 18:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiGFWVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 18:21:20 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F22F2A96C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 15:21:18 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id s128so6723684oie.10
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 15:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=tX3wiMJEVMJyc1WS8xul4yOJ13z03UObiU/AucT1s0Y=;
        b=UMtFJCJv1xeCymdV8UbuLm7W5axBdzDnXsnbkJdwwiuupFK7TLP7adm9HRBZfhIcAv
         8h4zvx/JF7OI175653Z7yxxK3stnOz5mpRM3gqlSYDX1jHI09NKRAknDF4QAv7a2+z4l
         lvcpujbwP9ZkhmU2rsN0MyU9NZcJGpPnSXwEUo2haP3cW/h/DBJz1Ju7ctC6AuJbxHAf
         jWqjvKaCS/OP/VqHoj7hbnCibnp7FnRcqpWNyAM5SIu+VILjwE4CyGbr46QU6nUddQBG
         LyCV4BcbkWtO3TtiQ9ibWpweBmsznGlQu/RHZWGvRrHGGmAdmhvUb9oiNhVxKVegR8XE
         GIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=tX3wiMJEVMJyc1WS8xul4yOJ13z03UObiU/AucT1s0Y=;
        b=04MzQgEHarNh/Tohv/2NbtLGW14FBgKA0RkDycco7n2Q8VaQELbRDP/cbBm2vRBdq2
         pVL1UGN8wL7sAT827rVrORtaXj9Ovn+C6VJcQq2p46NZMEywSVXTIxjjNZLvONdx9uJV
         ZaWlrTWNaNEWEG98f2IbXk6NOpqZJrLVrqjpabjWG9k9AtX+mstN6ZyivM6ioMf9En+2
         iD8CvtSdqGd7ULpIAeGksBmGXUTqubEf8G2b7g4KK8RAUJGz/cEYQWFtGeL9qa6Ctnbi
         LYZcFK3JnpcO1Crj/7j6CeLKqhXyLlKtQqYbyPCqBEwi0TD7E0ZVAaUtpYsxylk2muCB
         NGCA==
X-Gm-Message-State: AJIora9VvwRA6f3+9AhVwb8CG+WBe0GgjwlI+DFzcExi/k6G3xILzPoh
        u0KS/Dg82SDBPwH6En9PABRYT6EM71gwzM+zdkc=
X-Google-Smtp-Source: AGRyM1tRWen8ezaY96jConOlbqtJIQIBjUXdA9LzGqI2gD2d2IoMOmoPw2MZv/fJwR0gAHtUaql51yJrzpddEA1wXws=
X-Received: by 2002:aca:d0a:0:b0:2fa:49c3:fea4 with SMTP id
 10-20020aca0d0a000000b002fa49c3fea4mr549098oin.49.1657146077773; Wed, 06 Jul
 2022 15:21:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:7e81:b0:a1:c5e:b2e5 with HTTP; Wed, 6 Jul 2022
 15:21:17 -0700 (PDT)
Reply-To: mrsmargaret1960c@gmail.com
From:   "Mrs. Margaret Christopher" <miraclesus39@gmail.com>
Date:   Thu, 7 Jul 2022 00:21:17 +0200
Message-ID: <CAGYy9RcZ2vujEd_an-wok2XnWyJm4ONJmRB_ub8Z8TnsD-SXsg@mail.gmail.com>
Subject: Hello Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:22a listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8709]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [miraclesus39[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [miraclesus39[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over  2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 years old from USA California i
have a charitable and unfulfilling  project that am about to handover
to you, if you are interested to know more about this project please
reply me.

 Hope to hear from you

Mrs. Margaret Christopher
