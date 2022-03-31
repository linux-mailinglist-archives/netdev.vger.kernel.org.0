Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA524ED6A3
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiCaJTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbiCaJTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:19:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49688B4A
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 02:17:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j8so12650707pll.11
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 02:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ih8LLR4BU+XOLlBsaeGuInD35g84knZ55fEb+sWwQLE=;
        b=m9JY1T2fVJqS1fYJnX1Lbbcho5BEeSvJ1p2iErBWUKphqwHPfoBqWO2JuqjqBkcoOr
         PhdBsvQEtQEksesBExzSODztEFHY/06NnfOTXsWOfhxz1AsijLl24rnJolO3zP5IEjcG
         1b6OVr/lWoGBdZGFaaaINISsCVnsolB5EZKdx4uQu2c9d7ISDsrjHq2VXcNh6jKwLeEj
         jngwNN7AW3Y5Fa/i83q9RtjecmjAuN3Ja1WgzWShQ9+B4QH5r+JcnGLP2U5FLSV2KP24
         auOI9ZL7exC5GSjNDcE49mf4SvlXh7ntbfVGGExwFPdmfCSu9h172QOxxDymZ4F8M3MN
         i8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ih8LLR4BU+XOLlBsaeGuInD35g84knZ55fEb+sWwQLE=;
        b=gJ+jZPAO3W8kgX2fPUHDnBBs1LqmUQ4FvsbkqDZXpf3tNt4EDHHgJNGAVreKri2yyK
         H3xdgVFmBAivoNxfqxDNAJ1qOxO6NK+5ECYMAB15TcUEbND0X+gw3jZ3mPmD6LLw7win
         nUeqqhCQHTSyRcj6BOkQJB/dQEzWCCxhn6WfNR7oCDRjWMz2QFYERaKrKaXBe4PT4zSf
         iCg6LFeBR3Ojr/HjOOaAjAa8AFniYU/ykFzJ8u6Ym1M8kAgB4lMPuKqK32WaW7bIM5K0
         lUzYnanVzmu/lbNDHCW+28RigZMnKMoP5UAZp1MVpHN2k8lxaYMTRyU+YO7o9/4AEA+V
         A2uA==
X-Gm-Message-State: AOAM533wDoOCWf+IITFhvQPiDTEP6qPMKG622s5ZY8lCBTB/vjVmBCSX
        7DPeyZ5AwlC/HVvHLz/5fEPKKt3nLzKTiEWblRU=
X-Google-Smtp-Source: ABdhPJzKLJUPokJbs4h+c3Oq6l9ZAiSIKUwRUv2wqDANefTVmXU1Cob41W8qK7NWs4qdjGV4kGgd8xQGVq+/XawulLc=
X-Received: by 2002:a17:902:d709:b0:155:d473:2be0 with SMTP id
 w9-20020a170902d70900b00155d4732be0mr4290917ply.151.1648718244490; Thu, 31
 Mar 2022 02:17:24 -0700 (PDT)
MIME-Version: 1.0
From:   SPYFF <primalgamer@gmail.com>
Date:   Thu, 31 Mar 2022 11:17:13 +0200
Message-ID: <CAAej5NbAYjLSTBhS5Xcv+zztdhECoZWYr1Kxnyut=NSVQJ+VOg@mail.gmail.com>
Subject: Re: [bridge]: STP: no port in blocking state despite a loop when in a
 network namespace
To:     bugs.a.b@free.fr
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        nikolay@nvidia.com, roopa@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Can confirm this is still the case on 5.15 too.

Ferenc
