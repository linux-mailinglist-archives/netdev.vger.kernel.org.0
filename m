Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F59A51F646
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbiEIH67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbiEIHpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:45:21 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646FD81EFE
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:41:28 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id kq17so25105501ejb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Bt3LLqltUpunn/KYr97qJkgeMokg6U3IJi8Vkf0d7I4=;
        b=ID3CZ4N+7bkVjhrtmIUrwVAtT9xsQG3xQLbj2Vq9NDKm2dXluDwUNRC8WiUFGy2Vu2
         rfbHE1Klt2XQGrqy4d1YtkLA8gTkhKTgvrBdnN7nZlAqYHbDppxYjRvTZwUF3bSThClZ
         FrLTUbjsjaWcdXW3KNhGJcy1iSgF/Jh0M4vdTlGL+y2Owz7wA/LGHPZPa27mWXe/sori
         b7aBQR+20xTPHiGeFv2NUnnjSFyYdOay3jP2qL+ywFLLVvQBzuwGzT16ApOijsA9xtMm
         18Y/n3IGkg4dJkOhR/DqM28SUgHeD5vdYYqDZkC+4CNHd3uyJXCpIiV79q0NZZA3YdOI
         ziFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Bt3LLqltUpunn/KYr97qJkgeMokg6U3IJi8Vkf0d7I4=;
        b=FI5yA63b+SFfgL5w20zEjJb2OgYfARxHkm7tHbCQ6nYQI2fTaem++UwKLaDN0mPikf
         2WhU6ifkBap4Vhv9bjv1wK7Av74lGXdkCL91sM3sdlVW2YA7BG/MlB1LTFY2tY53QrFm
         ejBPQ1mvE8gP6y4JM0WI9H9fX//kqMjIzZltbn6hxnQwGI2zOUfYh1FKsWfTD7AJ0TXA
         YWWUPEQAegf9zZLuWiCtlXArf12LpXx28Gb/X7gB99KVuYdfob8MqMOUbXXMMIiAwXl7
         rgoNKLIv3dQGXyw0MeP5LW+Vz6WuarhwLZzXX4Z6QpfuRboaKd5jGLovlo73Qy9ZU9pb
         cyGQ==
X-Gm-Message-State: AOAM5321rRcA+iMuZX0jBVPNUKNSuhnircT7cQDOQfRdEEjKjPSvqGkd
        +18D+XxA80RFRNoDS/o7tAw0kdnAQXWkPw6aFz0=
X-Google-Smtp-Source: ABdhPJwxXJIGebn+TNIcWauIJBBhlIHqpngoMdfIvGnv8jAfbX0ldEWeVUDBJLsg/4B6m1iUwCrqP6VLoDpBPzEMpps=
X-Received: by 2002:a17:907:96a2:b0:6f4:8c18:96ca with SMTP id
 hd34-20020a17090796a200b006f48c1896camr13772724ejc.265.1652082086919; Mon, 09
 May 2022 00:41:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:9e1f:0:0:0:0 with HTTP; Mon, 9 May 2022 00:41:26
 -0700 (PDT)
Reply-To: alhassanandan@gmail.com
From:   hassan <ikazobohemmanuel@gmail.com>
Date:   Mon, 9 May 2022 08:41:26 +0100
Message-ID: <CABLs6o+RAqDpSgkoA4rBZkGNM4nNgk=Z_1Aa2m3hiE7KCm7JpQ@mail.gmail.com>
Subject: Prompt Response
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:635 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5848]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ikazobohemmanuel[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My name is Alhassan,I am writing to know if you are still using this
e-mail address. I am interested in discussing mutual business
cooperation with you.I will enclose the proposal for your reference as
soon as I receive your response.

Best Regards,
Mr.Alhassan
Email:alhassanandan@gmail.com
