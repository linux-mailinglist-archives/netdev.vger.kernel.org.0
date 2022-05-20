Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E66A52EF4D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbiETPeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiETPep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:34:45 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C21216328B
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 08:34:44 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id j2so14897546ybu.0
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 08:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Nxu+SaQL096L+XxOOv1lOQDieoYQVyRWdw2b94YYwhY=;
        b=pfUkEFqb5uL6+OdEcAmXHbNG9fxjaE2B1lN1aQgJpH9HRBYMncmNSOfS0QEsU0pR8u
         Vm+J0xSGA+U6juRGFhGNX4i8EVT6rRv1uDIO2BNSQ14Vq6PaZAWr1nzhxR6sr5eO3Fj4
         dwXFyUcxLUcMQnA+R9N/ptrWpxx0EPjeHUlH2J9zf1X9UnpulQOU1dVmhEzsbdsfD6rs
         N8Oo277jjUMoZvSrgH+gxox0m3hgnnajm/l6GfIPyWTE2uqEr8gbmpmGwSmrtsBcJ1+L
         RRB8n/t4JVdPQcal+p8ArbC2/kdWBGsaH5BqFQI3YJdmDq8sI0HNevYToExclpBYUlR0
         D/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=Nxu+SaQL096L+XxOOv1lOQDieoYQVyRWdw2b94YYwhY=;
        b=2RFSAS4WxYhOiaKFihusO57mIXfDWPY/b/kNKnhl+kjfg6BFcu6TCjN2EyQx59bIg6
         uk6hP/K345nK/oyj7cv077GRb8MVnz2lbJYpLB/dhssletY8sKc8N4rG4oKraj2CYExr
         +6GIHIDbYNDv32/6DcLdg2obt7pzcz87tx+pnledw3MIY7kVa3TrJBJwP0o1NNMCBt36
         U0zUxNooD7qDS/nHEH9+nClJOq+JrTcyageMiFL07QKd14AOW5uVzWXs8Qqhg+L58TH8
         tTLesPuyEXU5Ujkz9RGAr89JTRTRRua1L0IKNze6Du0vvHNceX2sdQdKnMIs8AnUlVJn
         ZRqg==
X-Gm-Message-State: AOAM5338ixwFZyJNfiW+4LkkdWwZO7XzrODe61uvhcre5lBjcVdQFFnU
        uqz3qcmpT8sPBMc7GxxCvzZsbU6rEIovIJRuJXs=
X-Google-Smtp-Source: ABdhPJwMcvHbie/nLJqmC4z1rdfUeDe2DvldLEst1Hn6JnoAajtgAMUfZOXlluKvpxijwmMaB8bOMuAZKpdnPOznqdM=
X-Received: by 2002:a25:9c43:0:b0:64b:f78:3735 with SMTP id
 x3-20020a259c43000000b0064b0f783735mr9559995ybo.591.1653060883583; Fri, 20
 May 2022 08:34:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a26:9f09:0:0:0:0:0 with HTTP; Fri, 20 May 2022 08:34:42
 -0700 (PDT)
Reply-To: davidflint551@aol.com
From:   David Flint <suppothorizongroup@gmail.com>
Date:   Fri, 20 May 2022 08:34:42 -0700
Message-ID: <CAJBLadHVXuQNQsoY-JJ8SbKs+zmb1Weiy=qST4t3WvMFhE3vsw@mail.gmail.com>
Subject: Attention Please
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [suppothorizongroup[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidflint551[at]aol.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Attention please

I=E2=80=99m solicitor David Flint, I am from Scotland Edinburgh Please I wa=
nt
to guarantee that you are the one receiving this message.
unnervingly before I release the information to you, I want you to
verify that your email address is still valid and accessed by you.

 As soon as I receive your response I will proceed and release the
vital information to you. I am taking this precautionary gauge to
avoid getting this significant information into the wrong hands
because of how susceptible it is.

you can contact me.
Whats-app +1(346) 507-4536
Phone: : +447594378044
https://balfourmanson.org

Thanks
Solicitor David Flint.
