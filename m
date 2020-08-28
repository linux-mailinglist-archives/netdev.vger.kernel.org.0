Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D115C2559F4
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgH1MV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 08:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbgH1MV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 08:21:57 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F83C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 05:21:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q93so488029pjq.0
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 05:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=A4/Z06eFxBxl8b3rX3ckNrY/1kZu8MrvWtn/z+YvYC4=;
        b=HRtSpiku1M6b92QU5LrWLh1G/XGxkg18vr0LVr2KeZfSk7qYMCzT6SaV1mqlqKKEs5
         d7TSlFU49GGDbILa+e58QTSppyRXnq9k1hq8b2R3zIFDvqa95rJMBjEysjzJpVSa9IFG
         t/ULOqG+S5iMUNnTxaYA/G5ZyCw4aSH5koZAJaQN0zCw5qKG7LMu400lPJo/rQ5AzvVe
         odd/W+YIw/wfbd5V//kcvhdTYwSZX7wqGC3TfFNnT5bH1HNVDUwXlVZwVYtVcGaMG3At
         G5FjMQ26gAHYqjRJanx4zCMS+QD/rYo3Rkw8Pt6pewcvI+XEY/1A1p+MImSG/Rzud6S6
         69sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=A4/Z06eFxBxl8b3rX3ckNrY/1kZu8MrvWtn/z+YvYC4=;
        b=aTJxs6zK/LH+HCs5EuQQonSGJjMjcQ5hNojQ6sjS1L9YBAM6DVrQw1+BTBqcL+mrsD
         KFav07W63U6f0SO2vlGyrZkKqjzPnjodQW4ND4TuZFXUgvFIHErrL0mMVtzy5SAefO/Q
         oMwB6IVqCM1SjVq+VyVnXFMTFI/cLMcp+dxxDFH2lrTU4t9MN9kHA2Ed2AOmI4cQ39id
         GgUqHiuUDk8JCUwn8F2J8o/hRAJ0WV2Vrm7ozt8rU2Cx3OzwJCH627f8VDxu1SVyXab2
         AxXMvuaX7LSDnWZs+JEFXcAvOxwFwEhegypDucyAv6LYPNRIbvFLltzJo1LAZCPe0PNR
         recw==
X-Gm-Message-State: AOAM531s5FCdHyL/K03GRxvwKxU+WXRFYkc8g29cCh1MiENt3Jb4hmVi
        kiffJP5jShECiJn/aIoj/2s3ojmsJwM0BUBhIrA=
X-Google-Smtp-Source: ABdhPJxDLloEvKQgmHxNmhlKfcLZeY/gkP1xPKqULLMMJ6o8BegR/vSh8NvAwhKZfut/54ArepaZ+IiJsA+kS+WEQVw=
X-Received: by 2002:a17:902:850b:: with SMTP id bj11mr1110794plb.81.1598617316741;
 Fri, 28 Aug 2020 05:21:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mrahmedmuzashah@gmail.com
Received: by 2002:a17:90b:344f:0:0:0:0 with HTTP; Fri, 28 Aug 2020 05:21:55
 -0700 (PDT)
From:   "Mr.Ahmed Muzashah" <ahmedmuzashah@gmail.com>
Date:   Fri, 28 Aug 2020 13:21:55 +0100
X-Google-Sender-Auth: pYTYdxRdyxPCsR_XiXKtstU9t80
Message-ID: <CAPHENautDVmQzdJMJftoiMoNpDEs2gUBJL77SCpikd2gwnGe8g@mail.gmail.com>
Subject: =?UTF-8?B?U2Now7ZuZW4gVGFn?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sch=C3=B6nen Tag,

Bitte entschuldigen Sie, dass Sie einen =C3=9Cberraschungsbrief geschrieben
haben. Ich bin Herr Ahmed Muzashah, Account Manager bei einer
Investmentbank hier in Burkina Faso. Ich habe ein sehr wichtiges
Gesch=C3=A4ft, das ich mit Ihnen besprechen m=C3=B6chte. In meinem Konto is=
t ein
Kontoentwurf er=C3=B6ffnet Ich habe die M=C3=B6glichkeit, den verbleibenden
Fonds (15,8 Millionen US-Dollar) von f=C3=BCnfzehn Millionen
achthunderttausend US-Dollar eines meiner Bankkunden zu =C3=BCbertragen,
der beim Zusammenbruch der Welt gestorben ist Handelszentrum in den
Vereinigten Staaten am 11. September 2001.

Ich m=C3=B6chte diese Mittel investieren und Sie unserer Bank f=C3=BCr dies=
en
Deal vorstellen. Alles, was ich ben=C3=B6tige, ist Ihre ehrliche
Zusammenarbeit und ich garantiere Ihnen, dass dies unter einer
legitimen Vereinbarung durchgef=C3=BChrt wird, die uns vor
Gesetzesverst=C3=B6=C3=9Fen sch=C3=BCtzt Ich bin damit einverstanden, dass =
40% dieses
Geldes f=C3=BCr Sie als meinen ausl=C3=A4ndischen Partner, 50% f=C3=BCr mic=
h und 10%
f=C3=BCr die Schaffung der Grundlage f=C3=BCr die weniger Privilegien in Ih=
rem
Land bestimmt sind. Wenn Sie wirklich an meinem Vorschlag interessiert
sind, werden weitere Einzelheiten der =C3=9Cbertragung ber=C3=BCcksichtigt =
Sie
werden an Sie weitergeleitet, sobald ich Ihre Bereitschaftsmail f=C3=BCr
eine erfolgreiche =C3=9Cberweisung erhalte.

Dein,
Mr. Ahmed Muzashah,
