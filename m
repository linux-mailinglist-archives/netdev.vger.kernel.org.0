Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F06B2CBA
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 19:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCISPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 13:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCISPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 13:15:19 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A9558C26
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 10:15:18 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id i34so10533277eda.7
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 10:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678385717;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3vtIQJgbAqYVFrKRDt53NZIcLU46fTuOZj8Pktv++Ns=;
        b=B3I4H89FhVf5hzJwCcb74eksb7IsBofMCvKSV3Pelh+Nkd9VKPYzc5KfFDIVE/acNc
         +Ln/1VJzLO5TKel/Wsd9wPkUYdB0Mpsl514WJ9mcfEtGjhzpWrMjJ0yo5bsoUOhEcmHq
         C6lNmcNKn6ETxnTSm9JfcEQDc6zkyUwmxaw4eSEQFt5akFA0ZDQojMnEzi5bxDRm4cfE
         QpwTg6dT06KUdDqLvkCuUc2n1bsW3uI3KslQuzMLqHJLcgw/iha8CGckZNDdbC2NPBQf
         86JOJvcIk3Wt07/8AAc75zrFfAADeJQ2Ch6nOcB3ArzyRWsPpAUodBhwXcjh1+pVVQSh
         Xc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678385717;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3vtIQJgbAqYVFrKRDt53NZIcLU46fTuOZj8Pktv++Ns=;
        b=Lb++eHWGNPGjObmutJ+M03CnptoAyTIIWOPpoJfPw9nmGJITvUkNiZBOzslrPBKiF9
         TT8GyEutNtt5m9ZshgwonFmquq2gYHtfUKliLZ+XWyi/TlKsy48aOf5sG32dZokY8Gwl
         H08WHTK9KGaSvLTcqbu9oO5yTlDFtfupaWgtnaeq5ixUla7PnZAeUcGHB6f4Y1K5PlPY
         3hVOFGWrfBpc5ffSClVNwPOlrFsLvYKzr0GPO4toqt079bULcNHD+l/t82qHxW5Xdoou
         W+8x+Yuv9ehjQ+lUtUkCDoRKTMsVAkQtd7u/vxLrWY7NSYLb96hRblfwV080MxTEHnE7
         1v/A==
X-Gm-Message-State: AO0yUKVPXDGTLbqcruCCvs0BqBRc336hIGFeiFjZZXtBeFY98ljiqkJz
        X+n0V4Oy1jVk0qtE7ifxGXRJ8xNtEb489uv9XX0=
X-Google-Smtp-Source: AK7set8IA/EglVcgIlnr7Pf3Mielet737jSmEuZ/VvaP4fvwngzTNZaTiG0vu2IjjePDxdUfpHeVYEccwJdWAi8zt60=
X-Received: by 2002:a17:906:747:b0:87b:dce7:c245 with SMTP id
 z7-20020a170906074700b0087bdce7c245mr10675546ejb.3.1678385716802; Thu, 09 Mar
 2023 10:15:16 -0800 (PST)
MIME-Version: 1.0
From:   Lara Geni <larasecuredata@gmail.com>
Date:   Thu, 9 Mar 2023 23:45:05 +0530
Message-ID: <CAKDenP0FWDz78_79bFJymj1OjASrc0a6he5MRGPwELGYV1rGhQ@mail.gmail.com>
Subject: RE: NTI - American Association of Critical-Care Nurses Attendees
 Email List-2023
To:     Lara Geni <larasecuredata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Would you be interested in acquiring the American Association of
Critical-Care Nurses  Attendees Email List-2023?

List Includes: Company Name, First Name, Last Name, Full Name, Contact
Job Title, Verified Email Address, Website URL, Mailing address, Phone
 number, Industry and many more=E2=80=A6

Number of Contacts: 12,639 Verified Contacts.
Cost : $ 1,638

If you=E2=80=99re interested please let me know I will assist you with furt=
her details.

Kind Regards,
Lara Geni
Marketing Coordinators
