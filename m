Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A8D49B1D6
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355275AbiAYKaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348782AbiAYKXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:23:37 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF18BC061760
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:23:24 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id c6so60182264ybk.3
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=EBHbP83/CZFp2F2gENfmEXu6m8S2pw12piuqN6IlINY=;
        b=PMGhQQXl7RXGayaCDZI8V+7UUVHKvHpKVZWGAp1lWeS55R9cpkVuMr4LWzmTRu3T/7
         xFtZGiM+cYqx76r0ItmFqP8+APLBT84FWqml4vSkLGxw2YafCI8SavbKU81gLUs0LTxC
         U56yBbpQdVm57f+lEGiCpR8BbLGE/q2/gISzFIVKYf7pN6CttySVgxwMGteaL6euucys
         tgt5CwLaS5a2rEFszELyIAeGPTf1g2CmVfltxns6OxQN8XYMLHRyVWrkoFA+22Z4vKaa
         iwTpwCTGTWOIs3X3lf3VtC8CJ4DLR/vH53H4Lcy40C+YmLXseLICmQAVOVKJfRflmi/Y
         A3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=EBHbP83/CZFp2F2gENfmEXu6m8S2pw12piuqN6IlINY=;
        b=dryB3XSB6B5DxLyYlUL6NDm6WXiihbUAof+Rf8UWKrwLGMhTbv0WcIoxVhZXORQAk6
         StklJQNHHA6IF72anlwAsHxyNFnvUfpCczY0NvXxpJ6o9OzDh/pEQt0aQ+7LlaAHo2V7
         q+bnHumyjym63dVqLczhH/gVCfKp0IHaESNUsjdaMLrsPSK9ThxeDsWqhOEf3OEinbN8
         5YhggWAAFTMpoYsvyumegjzoMK14xE/L9yI1WokUFW0xBD1/8Nr987miWUP8rnJFfkHV
         g45DIO+bSzcs3ojA3DkKBMcvfWy4Xcj8xLA8Hc5RRr6XPDLKYQ1DXAv+t6P7mEtP2ruz
         H5KQ==
X-Gm-Message-State: AOAM532E+oWiDWnxUjBGSmp7r/82X/I/FGeWcqBLLaPRwn/Nfed0hbVu
        8kF9HDU6d/9v9szWf3+YDJJFGx6vGNCmKfYUFx8=
X-Google-Smtp-Source: ABdhPJzepwKrKeIVkxGhO1fXTi7lwpHqmHdec+QcuuRPdRAgOsQIcis43fvMaweCBEzKK8om1R5RpXdYoKVMNyGTMQI=
X-Received: by 2002:a05:6902:1504:: with SMTP id q4mr16840449ybu.556.1643106204261;
 Tue, 25 Jan 2022 02:23:24 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:31d0:b0:121:e4d4:44fc with HTTP; Tue, 25 Jan 2022
 02:23:24 -0800 (PST)
Reply-To: tonysiruno9@gmail.com
From:   Tony Siruno <frankrajahtg@gmail.com>
Date:   Tue, 25 Jan 2022 10:23:24 +0000
Message-ID: <CALfvvy+HUsrQWq2E9pUYqw5ahRHeQwJpbwLUgHYn7VVUrYV89g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Warum schweigen Sie? Ich hoffe, es geht Ihnen gut, denn jetzt habe ich
Ihnen diese Mail zweimal gesendet, ohne von Ihnen zu h=C3=B6ren. Heute
komme ich von meiner Reise zur=C3=BCck und Sie schweigen =C3=BCber die Post=
, die
ich Ihnen seit letzter Woche gesendet habe. Bitte lassen Sie mich Ich
kenne den Grund, warum Sie geschwiegen haben. Ich habe mir
vorgestellt, warum Sie mir nicht sehr wichtig geantwortet haben.
Bitte, Liebes, ich brauche Ihr ehrliches Vertrauen und Ihre Hilfe. Mit
meiner guten Absicht kann ich Ihnen vertrauen, dass Sie die Summe von
12.500.000,00 Millionen US-Dollar in =C3=BCberweisen Ihr Konto in Ihrem
Land, wenn m=C3=B6glich, melden Sie sich bei mir, um weitere Informationen
zu erhalten. Ich warte auf Ihre Antwort und bitte lassen Sie es mich
wissen, als zu schweigen.

Herr Tony Siruno.
