Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7847956AC46
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 21:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiGGT4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 15:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbiGGT4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 15:56:41 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32655C9CD
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 12:56:40 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id d12so9598982lfq.12
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 12:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4K4mMKpXpf4R41YLhVfBwKVJzk8ioNewf9siCI5kyc8=;
        b=aftfmWyL4ywuzOR88EXMAYYcbozWuihM5268+VGzJUDWhaK2A3qJ1Tr2N4MPDpPmpL
         FC9nxFr+hyb1aEqJua+GLx/Yi+oaP0rTMYc6pFDGUNS254hup74FqbBbNcKHq+zSO7JW
         bLJIQ2EWFispdv+nCUpKX5OdJh1h8S1UdTFw3CgFPmqUHcEwYCKFtSVh7piYmEVkxO7G
         kUZP38sGklgdjSRBEy1ZhAg3bhJPig53FEVmLfmXCa0kG38NUqyMEzMaRJV2Zwt7T6Yh
         JZgQrNv9BXkGljz+mmGI5jjTjlNSvU0vSe64/D4l/KBfHoaxv+c9jZbcp3DnTY7Qqrkb
         tjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=4K4mMKpXpf4R41YLhVfBwKVJzk8ioNewf9siCI5kyc8=;
        b=2325V3r0KyWLKvbGQfo4W5ZW9l8zxpwo/XsYZFTLgf/LCBtVfAij3N0/JZ+HTPQmXC
         Nczibqlp4TTEhmZLfMZrdPtK567PbCTbOtvpgndTBnaiYzQE+MPzhapLLTNAOa486247
         tENLeP3Qg+uHbzIw6Z1R4w8OXC/f9lWkEJKl/gP+gNmIPM3izHg5WPj1F/AQmvv/0GAC
         Et4hyV61iJV17WrePIXjLr/R8YxkG9Aqn6HE08bdXRitTD845/Oz4wCZnPtgP2NJbcEF
         snjstHORAVXb34Iyr9yzzaikaYqYBYjzxWTZNrlmoM9FhB8PtbLN/LHIvyP2iA2VZKLv
         6m6A==
X-Gm-Message-State: AJIora85JwPUNcvPwpbEIUo9Aw6+V0HZmu24GAZqyImvQ+J4iTxoX6IG
        zxjYEVDDtR8ggZObdgfCtwAMq6ndCBNZwDhyjPw=
X-Google-Smtp-Source: AGRyM1sGxiPPcTyoqhUYTeyppqrAe30HyFFXGx5E2DtWG+YHCh6MCrN0Yyg5BPBdDqwDKRsDl3Elzq/sPpqwRM5ychQ=
X-Received: by 2002:a05:6512:3f81:b0:487:2234:5a9a with SMTP id
 x1-20020a0565123f8100b0048722345a9amr5737034lfa.574.1657223798669; Thu, 07
 Jul 2022 12:56:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:6d36:0:b0:1d7:8d3a:98e6 with HTTP; Thu, 7 Jul 2022
 12:56:37 -0700 (PDT)
Reply-To: pstefanopessina80@gmail.com
From:   STEFANO PESSINA <gisembasylvia@gmail.com>
Date:   Thu, 7 Jul 2022 22:56:37 +0300
Message-ID: <CAAcsVCpTsDff-pO=r+4s1nReO5CVuZ12UN+45KBXHOrgmsXtmw@mail.gmail.com>
Subject: =?UTF-8?Q?Herzliche_Gl=C3=BCckw=C3=BCnsche=21?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Herzliche Gl=C3=BCckw=C3=BCnsche!
Die Summe von 1.500.000,00 =E2=82=AC wurde Ihnen von STEFANO PESSINA gespen=
det.
Bitte kontaktieren Sie uns f=C3=BCr weitere Informationen =C3=BCber
pstefanopessina80@gmail.com
