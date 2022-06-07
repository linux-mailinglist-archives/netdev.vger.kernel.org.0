Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C79E53F9D1
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbiFGJbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239622AbiFGJbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:31:12 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97026E64F3
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:31:02 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id r12-20020a056830448c00b0060aec7b7a54so12524450otv.5
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 02:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ohM259uqobJqtM7gttWurWj7P+4iDfPJquHax95olDY=;
        b=D45nP2xucmF7mdZXM6MCVE9VCxDN10F6UZb+EqrI+cxcV7FKkxVza1IRzovdQZmgux
         8b70wqH27wLvZ+nd72g+FthvnrTbujoeMbD0iKzgGDmG9fyY/TElRY1gza0y2wRsnQiA
         7ppMv6tVVpUuMda2YpQ9jsukLtG/eK9DYrAZLdH7TzWlJrAXBCpU6dVkgkywvCcvzFeq
         TmAvPmzfzM4rNVm870KJH5p32Bin4xJyyYYWTLCc061ZMHEj4TGD8k4MibEJoiEFl4mU
         m8S3J6iLVyIezcVyFZbH2Luv2YsfKC147sW3lSOXRaVcFIcCQ74UKr5ZelpwN5RMBUts
         Ea3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ohM259uqobJqtM7gttWurWj7P+4iDfPJquHax95olDY=;
        b=BnGeeSSRW4UR91SAQfWciHUr6j0Mqt7mwFAYbOFoxEMPB0kFgy3VB+0+LOdcMYermy
         eoALCGoWj8iDnK+A2otA97035JPXBfR4/HV5dBC/QgDBMHDSvGOpLQv6scBwOjJLb9TP
         AlAjLD0pKAl+GYLA0U4x6fkqIppP5MLPJABia4uM9x3SrORE4RbRzwuWE1fE3imk2IMh
         7IKfadW/bsMUVRT2VR+0dyfEgmXIDfsq/99fZkiZuFUhqEJSj+AXVIsWNN2eIxcZcp5V
         sDb6S0jmIGCTftcCbY9ewywbgFfSYC7NrgdqpJ/73MPJNzhUrSYMoNBnUYsLXhTEpTja
         KPag==
X-Gm-Message-State: AOAM532D2lBgdVOFRC8AtnyFmjcSHxiw89eJTbBA6wNPPizNgYxDUxH+
        ol1kA8XFPnFSqafEXoP+tO7EV42ZGcKyc/30si8=
X-Google-Smtp-Source: ABdhPJz3JFF8WALQ4shzhlviloQJ5bfRJgdtS8RmoLdgf4KAHxFIzfy4g91o6naaEJvh7R8t/kxCT+OVtK9R/I8EUJo=
X-Received: by 2002:a05:6830:919:b0:60a:fe63:e321 with SMTP id
 v25-20020a056830091900b0060afe63e321mr11499334ott.227.1654594261948; Tue, 07
 Jun 2022 02:31:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:99a5:b0:a2:a1fa:9308 with HTTP; Tue, 7 Jun 2022
 02:31:01 -0700 (PDT)
Reply-To: robertbaileys_spende@aol.com
From:   Robert Baileys <mercymiji.j@gmail.com>
Date:   Tue, 7 Jun 2022 11:31:01 +0200
Message-ID: <CAAD1zOZGOcSi9Z7VW=B-EdmyT-uRH7fKV+zh=fgOJtjsbZByfQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:32f listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mercymiji.j[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hallo, lieber Beg=C3=BCnstigter,

Sie haben diese E-Mail von der Robert Bailey Foundation erhalten. Ich
bin ein pensionierter Regierungsangestellter aus Harlem und ein
Powerball-Lotterie-Jackpot-Gewinner von 343,8 Millionen Dollar. Ich
bin der gr=C3=B6=C3=9Fte Jackpot-Gewinner in der Geschichte der New York Lo=
ttery
in Amerika. Ich habe diesen Wettbewerb am 27. Oktober 2018 gewonnen
und m=C3=B6chte Ihnen mitteilen, dass Google in Kooperation mit Microsoft
Ihre "E-Mail-Adresse" f=C3=BCr meine Anfrage hat und diese 3.000.000,00
Millionen Euro kosten wird. Ich spende diese 3 Millionen Euro an Sie,
um auch Wohlt=C3=A4tigkeitsorganisationen und armen Menschen in Ihrer
Gemeinde zu helfen, damit wir die Welt zu einem besseren Ort f=C3=BCr alle
machen k=C3=B6nnen. Bitte besuchen Sie die folgende Website f=C3=BCr weiter=
e
Informationen, damit Sie diesen 3 Mio. EUR Ausgaben nicht skeptisch
gegen=C3=BCberstehen.
https://nypost.com/2018/11/14/meet-the-winner-of-the-biggest-lottery-jackpo=
t-in-new-york-history/Sie
Weitere Best=C3=A4tigungen kann ich auch auf meinem Youtube suchen:
https://www.youtube.com/watch?v=3DH5vT18Ysavc
Bitte antworten Sie mir per E-Mail (robertbaileys_spende@aol.com).
Sie m=C3=BCssen diese E-Mail sofort beantworten, damit die =C3=BCberweisend=
e
Bank mit dem Erhalt dieser Spende in H=C3=B6he von 3.000.000,00 Millionen
Euro beginnen kann.
Bitte kontaktieren Sie die untenstehende E-Mail-Adresse f=C3=BCr weitere
Informationen, damit Sie diese Spende von der =C3=BCberweisenden Bank
erhalten k=C3=B6nnen. E-Mail: robertbaileys_spende@aol.com

Gr=C3=BC=C3=9Fe,
Robert Bailey
* * * * * * * * * * * * * * * *

Powerball-Jackpot-Gewinner
E-Mail: robertbaileys_spende@aol.com
