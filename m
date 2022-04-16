Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AB750459A
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 00:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiDPWHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 18:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiDPWHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 18:07:06 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B7D2DA87
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 15:04:32 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id e4so11474754oif.2
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 15:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=EfFJC0+vK2shW+8tCwP2zgZq6ezdHgKBhMzg1lz7/yE=;
        b=pcis/L2HOy+4b6/trKaRV9vmJ2fGxwSCnX+Hoxwcfpnw31lmtn0eaVkj9Su0doN5fd
         OeS5PLZhHjiKfKIoN9BxNNjm4qGCybdmWb65aHoUd7DDIy3pxNwtPqek+9YRMzNwSzq0
         oopT5GwTkDbUdTSjh37ebQFViAHjMqC+dMPytTPUHCTEOHcVAw/+BXtosm9VowRs8H+y
         N3xopsn56KZRItgPl5POHNKwEeqBlShc75/n39VnzQvzx07IWwCfCNelyumu5XFboxO+
         KZiCGQUJZWTUkRxiK6R7mswWbSBH06VGi+SROvfwJ1AqPojToqC4AqGWcH1HjMYAAAqs
         atMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=EfFJC0+vK2shW+8tCwP2zgZq6ezdHgKBhMzg1lz7/yE=;
        b=c3IBFY2QbspMDOnH2IaO4PyradfcyHKPlvbWSmF98kxsHW9EdW/YoDZd4ZkNdFGRGH
         2abnTFe9klNbwx5o5ILb4NvIZzWEtIQADMhd0mdGjEpXqkvsTk+GkAJk/wRmvH0NqG16
         apTOLSJDCYH5va7vR3mZhJtpbrmx0FvC2HfgFYNpKqkCyAEezOW1pSCmf9VojFksYZcq
         2bC4Z1vMUPOJ9mscyaRVnHZs9QrNF28Onh8lidMNfAmqptPAB3gJ5okZoUvTWMTHZE5o
         Fa5zClXD9g8g6vXsOL/D0f7h/F05BKs7dDCFCW1rS93e2aKQp0b3abQ/+F5shT+e5g2f
         DH1A==
X-Gm-Message-State: AOAM530BW6EmD+Youqs4zg3VPlaOmBb+ILXdlPxXFZbxOaV97lUf71kL
        rNRNA6PytTqfHDUa0vQNcialFhIUui86baNd26tlW1EKbVM=
X-Google-Smtp-Source: ABdhPJxyPvcdBP4y3eua/+hyPePKbVOamSpcXT0poc6g7JNUKm4BeOxGb0rr3M0MDgZC0nRTPj6pLGsvd2RpS0+jtiE=
X-Received: by 2002:a05:6808:11c3:b0:2f9:62e0:ebe with SMTP id
 p3-20020a05680811c300b002f962e00ebemr2132829oiv.22.1650146671882; Sat, 16 Apr
 2022 15:04:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5792:0:0:0:0:0 with HTTP; Sat, 16 Apr 2022 15:04:31
 -0700 (PDT)
From:   John Williams <williamsloanfirm2022@gmail.com>
Date:   Sat, 16 Apr 2022 15:04:31 -0700
Message-ID: <CAJ0Jv=HP3qUc=c7YsSn5GrJp1v7KcAik8uuOYquOd=4espa5Kw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  3.0 BAYES_95 BODY: Bayes spam probability is 95 to 99%
        *      [score: 0.9504]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [williamsloanfirm2022[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [williamsloanfirm2022[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:22b listed in]
        [list.dnswl.org]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo,

Wir bieten Privatdarlehen, Gewerbe- und Privatdarlehen mit einem
j=C3=A4hrlichen Mindestzinssatz von 3 % f=C3=BCr den Zeitraum von 1 Jahr bi=
s 15
Jahren Laufzeit =C3=BCberall auf der Welt an. Wir vergeben Kredite in H=C3=
=B6he
von 5.000 bis 100.000.000 US-Dollar in Euro oder Pfund Sterling.
Unsere Kredite sind f=C3=BCr maximale Sicherheit gut versichert.
Interessenten senden uns jetzt eine E-Mail an
williamsloanfirm2022@gmail.com


DARLEHEN ANTRAGSFORMULAR

Ihr Vor- und Nachname:
Deine E-Mail :
Deine Telefonnummer :
Deine Adresse:
Deine Stadt :
Staat / Provinz :
Land :
Sex:
Geburtsdatum:
Sie haben sich schon einmal beworben? :
Ben=C3=B6tigter Kreditbetrag:
Darlehensdauer:
Der Grund f=C3=BCr den Kredit :
Senden Sie mir eine gescannte Kopie Ihres Ausweises:

Aus.
Herr John Williams
M/D.
