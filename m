Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B94A44E417
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 10:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhKLJoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 04:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhKLJoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 04:44:46 -0500
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE683C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 01:41:55 -0800 (PST)
Received: by mail-ua1-x944.google.com with SMTP id v3so17520238uam.10
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 01:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ryMDXG8u8nq91tliEM1jiAtuCmRdwdK2Akbl4Dq/sjs=;
        b=CZUbpQRHBD2Upl0eH+ruMUuCffdSuDyvPzuwpG6p83Ia2xpKguhJJJEQieb009HeEo
         hl3G4p8yspRkkyvLwGDOwlT3Jp1/3GLAKIKG/5Eqc9brQkGh/7q4B3kFBxLQKnKmf2NB
         otjWIi8X0I6mUylQia18OD7PxWp4dJ+jND7sIk90loQneovKDSKOcWinDvyNgTTCZtY7
         mFr93wnOtMRZLA+cCn0qEysPujU9XghLTrLpfs71W7HHuhjiZ8LUNvBLYBh2IBxwdfCz
         xTS+ldIg9eX9s/nZG8ELb13rfCu1FAn/CyktEfNdUrzbcLeCvs+0NhxyFdPibxrcsrVL
         b33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=ryMDXG8u8nq91tliEM1jiAtuCmRdwdK2Akbl4Dq/sjs=;
        b=2DtGRTryHEKY3IUKmnFCidnFOG8G6wC5YzbYYHFSv2BV0ECygp8VxwhXuW1SPUo07F
         Lp0lje/pWfXGl+EKiOZpgBCCq3wyIZA8nw7CPOv8HQzjELr8tFOz9Qfl9C+xkMtLxXjE
         BffdALq3PCN98NclROc2zkXRl+5Xaap7lsdKiMdcsgC4/DH3J9VCnCET3hNJrFPz9qAY
         Z1uCnZQmRvajzBCq/CwZe/Is3DMZGlCO0INIDz193wCWyMbJaEYYibh0nsvkfims4BoU
         aFlyd24/6O2Br+1+EwnGdAYOM4yzite20KoiRtfl7oyzU8p1XmKB0y/bz1LQBeZFHhi6
         MJbw==
X-Gm-Message-State: AOAM533S7U3vzd0z+p6X1hEz7n8uVXs8XSvVXtYY7gBsn1GkH1tTjT7+
        0EsBiszzsg5MQZz6UMabRd0KTPH+0etT8G0/Yeo=
X-Google-Smtp-Source: ABdhPJy177a5BSTCwpcwbTixc5jP/nBWaDn490WBdPY+2TLWMgqjFgZLwisWbgd1V9uXBuCPP0Oe4/QaoSAUsRDUJCo=
X-Received: by 2002:a67:ba0c:: with SMTP id l12mr7797455vsn.21.1636710114939;
 Fri, 12 Nov 2021 01:41:54 -0800 (PST)
MIME-Version: 1.0
Reply-To: mrmahammedmamoud@gmail.com
Sender: foxaya7@gmail.com
Received: by 2002:a59:d8ca:0:b0:23d:e08f:24f5 with HTTP; Fri, 12 Nov 2021
 01:41:54 -0800 (PST)
From:   =?UTF-8?Q?Mr_Mahammed=C2=A0Mamoud?= <mr.mahammedmamoud0@gmail.com>
Date:   Fri, 12 Nov 2021 01:41:54 -0800
X-Google-Sender-Auth: ZQqf6sYNhmnqiNDUYJ6HDbWYEwo
Message-ID: <CAFsUiM7cHXguCNsv3t=sDn7v42X9V=TFMk4CX65ik-rU6EVopw@mail.gmail.com>
Subject: Von: Herr Mohammed,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Guten Tag,

Ich bin Herr Mahammed Mamoud, Account Manager bei einer Investmentbank
hier in Burkina Faso. In meiner Firma wurde ein Wechselkonto von einem
langj=C3=A4hrigen Kunden unserer Bank er=C3=B6ffnet. Ich habe die M=C3=B6gl=
ichkeit,
den Restfonds (15,8 Millionen US-Dollar) f=C3=BCnfzehn Millionen
achthunderttausend US-Dollar zu =C3=BCberweisen.

Ich m=C3=B6chte dieses Geld investieren und Sie unserer Bank f=C3=BCr diese=
s
Gesch=C3=A4ft vorstellen, und dies wird im Rahmen einer legitimen
Vereinbarung durchgef=C3=BChrt, die uns vor jeglichen Gesetzesverst=C3=B6=
=C3=9Fen
sch=C3=BCtzt. Wir teilen den Fonds zu 40% f=C3=BCr Sie, 50% f=C3=BCr mich u=
nd 10% f=C3=BCr
die Gr=C3=BCndung einer Stiftung f=C3=BCr die armen Kinder in Ihrem Land. W=
enn
Sie wirklich an meinem Vorschlag interessiert sind, werden Ihnen
weitere Details der Geld=C3=BCberweisung mitgeteilt.

Dein,
Herr Mahammed Mamoud.
