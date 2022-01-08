Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079674882E3
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 10:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiAHJlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 04:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiAHJlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 04:41:01 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EA6C061574
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 01:41:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso13332359pjm.4
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 01:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=iB1JV2nETDb6EW4NcK9FglRmvVh8/ANspYrct3ChFnQ=;
        b=NoZHbYVUV3b9iGaQT3+BFUf+8UhKNKHeUUN+PPlxKxoSrbAJirLHTeaJKqf4PEDcex
         73GsvipflE+UJp3H9o7a5XP4h+mLa2jKX7qFxaDWQOgEi81794ngRX9YTphabDzKx+Q/
         Wdc/ia12QqQzGD0Kpy7vFxeR4asmpNB5bhoXBvCqPtsoGQy02paxNBfKjydDqmsd1ZU3
         lQVtwK4DELUUPNcZ7znlFb/49o725Yqb/xNvcLRuO85ctFeUQekf8Aw0y2bOfU2efTPU
         ElFilQcLj/quNa5hxHL0/kP1cI/a73883jSRUiLkaJ7yec4ArlZ+eyEqyw9f9E6xIFbs
         XMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=iB1JV2nETDb6EW4NcK9FglRmvVh8/ANspYrct3ChFnQ=;
        b=XiSWU1PuIqJvm9eM7gaYNHeig9bqIuI8/wCMQOy2nYmkfkGGJADjl3qW458gEL9QgV
         Wpo5uQUzyBCK8MEijeNpcLLY6VapiLLrBJkB9xh6CgBZ3QODcjJSns3YYSVBbla4ZsLt
         5EC8V2jADJ0sP4iYniSkOM9llkqqY59RdVTzHhrlByasMyo0vRDsu9PhdJzriWYVeXg+
         S19vTfxiqPZtgIRaat//HJCidlAoQqFKxQxc64RGRhzRkPUeBpsHeQnvYODsKP0kF4ro
         ZYNPqKBkdRkHY9tXQZ6Dn6JuMfU7meuQpBT4hMjBNEG3FGqClUmcTfsODYAhQfp/DPAJ
         3ypQ==
X-Gm-Message-State: AOAM533M5Sc2MIG5pTzpGp0Yu4VcgNC0Zjr7CBaKQ61eCt+c06mqs9SH
        NdlgjkSYCFSpVdrNZxUxNOYpJbtIw2j+hrVb4g==
X-Google-Smtp-Source: ABdhPJyJgmpnliQ+PaCE9kB56bHlwUn/sM5EoosX9UcmZVMHsIa8DOTd/TG+rIi6xKsuHJAclIZsC0fxafQ82kAGQPE=
X-Received: by 2002:a17:902:ce85:b0:148:dbf5:193b with SMTP id
 f5-20020a170902ce8500b00148dbf5193bmr66867060plg.114.1641634860703; Sat, 08
 Jan 2022 01:41:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:b74f:0:0:0:0 with HTTP; Sat, 8 Jan 2022 01:41:00
 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   orlando moris <officepost088@gmail.com>
Date:   Sat, 8 Jan 2022 09:41:00 +0000
Message-ID: <CAG_JqceSNpqvMx3tcjuZBgP+y+K1KtxEzEwizZ=O5sFYFQZGsA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo, Houd er rekening mee dat deze e-mail die in uw mailbox is
binnengekomen geen fout is, maar specifiek aan u is gericht voor uw
overweging. Ik heb een voorstel van ($ 7.500.000,00) achtergelaten
door mijn overleden cli=C3=ABnt ingenieur Carlos die dezelfde naam draagt
als u, die hier in Lome Togo werkte en woonde. Mijn overleden cli=C3=ABnt
en familie waren betrokken bij een auto-ongeluk dat hun leven kostte .
Ik neem contact met u op als nabestaanden van de overledene, zodat u
het geld bij claims kunt ontvangen. Na uw snelle reactie zal ik u
informeren over de modi van de
uitvoering van dit verbond., neem contact met mij op via deze e-mails
(orlandomoris56@gmail.com)
