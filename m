Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D84398BC
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhJYOiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbhJYOiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:38:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB56CC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:35:50 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w15so271584edc.9
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=QXi5kHjHWd6fjjRgTXkyGAMS+MMuGm4cZgmMpd4J85s=;
        b=Xp8zYiTexfnxn6NChCWKF+4dJAPfTSZhxydGx3piyq2EBUHcHvDpZbaCPAsN5tQ48e
         NlBdsp2F76SWAHg8TnlWWzB3XRkNxkYPt+cAmbMsN6LmvEZMy01UWrGV9M7aZtVUba+g
         4lWOXRdRXQGajHsgFT2BhhSR5I3xtMZP/VBI46QnS1/aj2S+9qLvIMo9jHIxFpFdBC8E
         YdxwVg24nbm4PvMAkhM/YHjKigDb/J8mKENuL9VQCXPICFrV3+s8j8G+JFl3f5PWJLlQ
         //bFgzCGMuvXoy+IBYK85XpNNDSPUkEhPOFMs2WeuqIuTqOOnpbwGT4UByrYpd2l5GvM
         XmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=QXi5kHjHWd6fjjRgTXkyGAMS+MMuGm4cZgmMpd4J85s=;
        b=bUb/RzoI7jB65GR2tvQYIeyaoXg943xJDFjzDESZtNoA1XPAuOTRV6KneqAbjM/k3q
         3CACoAwlSBGFdKBe/Mlqfgs7KSBVEauK1ByeVtF/gxqa+dFZoqjhwf6wfNp9yy1rTw7E
         UuKIt44RmtgCQ4b27vbTSYJXSs30QWo38u+wKJPA0a/Zg4lb/KbBgy2L1xTuNzx8+jaM
         Eh8k9+SF81O70LZm1DM2Y+nz/7PEl6t0832Pk7XNa4jfVaQLFZX11aqbLrLhUR3nu2cW
         kXecG63NqBS06u4xlW1uoLp/Veg+MxSvEJ07XVSOUs8x43CCTncJDiYniXw8uT6vpNH0
         0srA==
X-Gm-Message-State: AOAM5315BBEtoxL71/zX09xQGNIueNZ8nKtr8cidedRXwI0S5zKbxf9k
        Azb+/0ma3dbPCASsMnIxzbJswmMQJ6dvmwZHYn0=
X-Google-Smtp-Source: ABdhPJxnpOET68pmwNETpO6l0YIUyyJ0ebYReWZgfrnpyqtGCM00fXk6NoV0+DKFePvn3dQHLTdsi+Vjq2xXGV7E8rc=
X-Received: by 2002:a17:906:2506:: with SMTP id i6mr22735123ejb.186.1635172521673;
 Mon, 25 Oct 2021 07:35:21 -0700 (PDT)
MIME-Version: 1.0
Sender: fdhfgfujffuhjfgdfdhffdcf@gmail.com
Received: by 2002:a17:907:3f0a:0:0:0:0 with HTTP; Mon, 25 Oct 2021 07:35:21
 -0700 (PDT)
From:   "helen.carlsen" <helen.carlsen26@gmail.com>
Date:   Mon, 25 Oct 2021 15:35:21 +0100
X-Google-Sender-Auth: XGjSo0W3UaDkbsSbqEExWFL-G9s
Message-ID: <CAMnHgDq67mQqyM4La5za0LF=9_1dy5BC3CjQf3Afnmy5Gw9ajQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 I sent this mail praying it will found you in a good condition of
health, since I myself are in a very critical health condition in
which I  sleep every night without knowing if I may be alive to see
the next day. I'm Mrs. Helen John carlsen, wife of late Mrs. Helen
John carlsen, a widow suffering from long time illness. I have some
funds I inherited from my late husband, the sum of($ 11.000.000,eleven
million dollars)my Doctor told me recently that I have serious
sickness which is cancer problem. What disturbs me most is my stroke
sickness.Having known my condition, I decided to donate this fund to a
good person that will utilize it the way i am going to instruct
herein. I need a very honest and God fearing person who can claim this
money and use it for Charity works, for orphanages, widows and also
build schools for less privileges that will be named after my late
husband if possible and to promote the word of God and the effort that
the house of God is maintained.

I do not want a situation where this money will be used in an ungodly
manner. That's why I'm taking this decision. I'm not afraid of death
so I know where I'm going. I accept this decision because I do not
have any child who will inherit this money after I die. Please I want
your sincerely and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your
reply.

Best Regards,

Mrs. Helen John carlsen,
