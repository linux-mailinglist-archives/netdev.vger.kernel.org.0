Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C63278C4E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgIYPOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbgIYPOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:14:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BC9C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:14:20 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 197so2836080pge.8
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3ESMbYgkZehDtre/X3JHJVKowL5dmR4t1Rv1A2qb8aU=;
        b=Txka74Mwffo8SWnzbp8+CrqQg/HnTd1QPh4LPqb+FTRCBmEQIjHkekC8yPm3auLXHK
         2MmsY+ewyePL/XSjGUIMlDzcLxh3Cz2bP4JOwtpzzRiRb5FCtZA+lh/ki7X/W3n5X2MR
         kZIkzwFbpcNBrVhs8SurNHxNNraeL4Sq0XouaP98PaJsP/IM7UAX3/lLtXAZrUJOxQaa
         UWUTw6BsJ73+k99ERom903s1kS5e111LLlPbYbit038P1WuWZeaYBb8eZKQRTvSsrp6z
         ThdCzDKC3wHE95nI1edRUOMmiQOSVJdmlZhgI1Yyq0ODLkyeMLDyPeTTsfSEA7d3mpqx
         HH9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=3ESMbYgkZehDtre/X3JHJVKowL5dmR4t1Rv1A2qb8aU=;
        b=TH8JUvPJuO9OhM+oXs232pwd6yqsO8TVAgESob+PpBTEynBsKdrBm+ahb4ZjLBMHT2
         Ntn/lAJxL6+R9kgXwzYm+jaemlo98EM/0nYNFK12oH98xNF8qFFKeF8rK56i1gRZIkbb
         vUOBppc2rdzGEJhzqQoDC1tSzZLcYO9ciu2nvROIW/QDKe7v3HeMIS3D7nrM8dPlofVb
         xjf0f0cljeBLvsXvLRnFvtqSvcjnrAiFx4LCaE/VUbczaU4Oa5K8mEoEHMZK/eSPHX7V
         jQNe8HyHt7Hzkd6Iko7XcHe9rTbxE7lfLUVx1Oa6IXOW6w0aZ9x96w1W+aX+sCO4zdoK
         LnUQ==
X-Gm-Message-State: AOAM530flA53U1ms56MIRdjhN7yLY0CI22QZ1O1EuX1Rgs77/4fnbDOd
        LXFjvfwuoOs89zc35GQQzJ3l3DiMnK7rRYdYcpg=
X-Google-Smtp-Source: ABdhPJxPG93OOq375PzVsj/A5oI+zBDiIzc46zmOpYGNqaII3AqPXAxnymhiCJ/YVwl6NiXNm2Ah821Eivm5LH71BnQ=
X-Received: by 2002:a17:902:9006:b029:d2:341:6520 with SMTP id
 a6-20020a1709029006b02900d203416520mr4939231plp.37.1601046860558; Fri, 25 Sep
 2020 08:14:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:95b1:0:0:0:0 with HTTP; Fri, 25 Sep 2020 08:14:20
 -0700 (PDT)
Reply-To: julianmarshalls@yahoo.com
From:   Barr Julian Marshall <baranthony50@gmail.com>
Date:   Fri, 25 Sep 2020 08:14:20 -0700
Message-ID: <CABfKVN_oEnM2K5f3mGAOvhyZbW=6xEFqdZx0ZNXrHp1UnJxamQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rozhodl jsem se v=C3=A1s kontaktovat z d=C5=AFvodu nal=C3=A9havosti spojen=
=C3=A9 s touto
ot=C3=A1zkou, jsem Julian Marshall, advok=C3=A1t. Osobn=C4=9B jsem zmocn=C4=
=9Bncem Dr.
Edwin, kter=C3=BD byl =C5=A1iroce zn=C3=A1m=C3=BDm nez=C3=A1visl=C3=BDm dod=
avatelem zde v Lome Togo,
kter=C3=BD zem=C5=99el se svou =C5=BEenou a jedinou dcerou p=C5=99i autoneh=
od=C4=9B.
Kontaktoval jsem v=C3=A1s, abych v=C3=A1m pomohl s repatriac=C3=AD majetku =
fondu Dva
miliony p=C4=9Bt set tis=C3=ADc dolar=C5=AF na v=C3=A1=C5=A1 =C3=BA=C4=8Det=
. Pro v=C3=ADce informac=C3=AD ohledn=C4=9B
t=C3=A9to z=C3=A1le=C5=BEitosti m=C4=9B pros=C3=ADm kontaktujte.
