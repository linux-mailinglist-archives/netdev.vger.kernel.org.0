Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CAD4E5187
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiCWLpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243982AbiCWLpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:45:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC057939D
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 04:43:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id u26so1468066eda.12
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 04:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=HjeihxJTxzkbTZ2MqJZoma1iPJVLD30cD4qsp7lAs6w=;
        b=QE1E6hew+KRpgWl3x2KBMVYXo7N1mjM1lOpHv2e7sLMYHRnyv9jmeho5KtJpYLzXm3
         GT/525cLpl7GjNN9x+1DWtGH75DUVc2tVC0tcfk0J5WuC8bWsk3rHePj5w7BfHTeCrfr
         tOfiDEIGmo7VZxxWAvGkJEbnn0HxIlFlsjs+xnhMd43HEvsHD+elpIfaZ9b3yPvpcMBx
         PSZ7SK02px0qXS6f8sCOorUJxQU+8sVyyfeHekkExVUztpgwje9+Lvk0RpWYnEB1Oz/e
         h71wRdfQ7EyDl+uH8pYmiklB1Q5uV+dFLqPwY30iqf/cNw8S/CfRXAh2mR/vq50iM83F
         v9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=HjeihxJTxzkbTZ2MqJZoma1iPJVLD30cD4qsp7lAs6w=;
        b=gFh+SdUY+HdqfvLZG2Q5U5va0z6D55abK+F0Og1cPX3ytW4mGAIGQ5roJBy2rZpxOs
         qaJBt80GOIboZW1J50Uh2Fm1VRN+UWHSpWVg33Eum/jrzLMmLypWD8AVd8Fcjir1TAJn
         J0Z1BGOX6rQS23ti3yFL0eBDeRIQlbHhbF7zdoRdLPnHOU+KCMOR2EVVnTUzsCigZtRA
         Xrp3gTDOGIiwovNzD1U644FtCExxd3tV9NnEGF3SA+e7bOM+745gGE46Ue3Qx0caIRfy
         W14DEEkvPLBPNorix+B3xyXBjkiCFnt+nAergvWHg/amgg2++ZT2UpxciwEAVL+BMNgw
         +taA==
X-Gm-Message-State: AOAM532JJDkRznUImneFz0mJTjgnDFvk34sSTC+awWAd2lK0HflbZxAS
        l+1rmghlkekU9ZOvQtrwJ9LdCwRF8UeSzRb2KAg=
X-Google-Smtp-Source: ABdhPJxCeg7ZcFS2j/8HQq31K1r8XYoWQTH+6KSeIJ19ORZqhcjfbUp18uC48EXZDlFzHYYBatFUKH/3YCokw48MoWQ=
X-Received: by 2002:aa7:c6d3:0:b0:418:eebd:8760 with SMTP id
 b19-20020aa7c6d3000000b00418eebd8760mr35426012eds.50.1648035824125; Wed, 23
 Mar 2022 04:43:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:340f:0:0:0:0:0 with HTTP; Wed, 23 Mar 2022 04:43:43
 -0700 (PDT)
Reply-To: michellegoodman035@gmail.com
From:   Shayma <shaymamarwan09@gmail.com>
Date:   Wed, 23 Mar 2022 11:43:43 +0000
Message-ID: <CAMz+VjRkVSGbvaHyYAOqTU4Z7cc-UdtUsr8G5L33PkF2iAJfdw@mail.gmail.com>
Subject: Danke
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:535 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [shaymamarwan09[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [michellegoodman035[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [shaymamarwan09[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo Schatz, bitte hoffe du hast meine Nachricht bekommen
Ich brauche dringend eine Antwort
Danke
Michelle
