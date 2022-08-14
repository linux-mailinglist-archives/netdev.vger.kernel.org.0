Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89654591FC9
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 14:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiHNMwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 08:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237876AbiHNMwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 08:52:18 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80D526E6
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 05:52:17 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id t11-20020a05683014cb00b0063734a2a786so3789723otq.11
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 05:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=qixLeLaPbHSMZ/RHPVqgxk6+Gqqvi0yCC8DOd5ukSQrUAE+5mltHwzw31CUtw0d53o
         awYCCkFRGCdwjIogY3vesETI/Zcu/tUTLvzukw3fXeItHmkJ2qk1mnLASVwwZU/Oxqsf
         uhNyRtMZlfa4nrmk0/+MzDhOScNwnbhLiEpsoYzTENE6pDUSRoyKFm90sJS88m4NRZbP
         Uwt4t8NkkzXqXiA3R8vGcmAq7fXOu5YsTKlsJBImqGwS2Ap46lPj2qn7BtRmfBuIoXSg
         zyjv6h8LYEovkbkGgHMWZ51f3GgOzxG27J6KDp+z5KpklM58R9dTVfAKg3Ke/M/X+0oc
         QK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=h0ZslgqQ94UM3iGDYCZGEx8ZwvbYHY5ZrQARiO/Kpbc=;
        b=U3PFvvWavF8LuLnLFHkSuLRJeOToFjN/9anNmaeumNP0t0OugrAHd0FYQHKjtWa41e
         G+/lW5DWnxw6exDpA38xw72t5EouIDVpk294w+c7eiiQaDJgqX671PaGdg20IzFJ02pE
         fCRsBh0Y93XQzOlC0UOK0v+9RO2WJi+Xg8SGwA+eoEmTMySFoCyU2F4JAM32qstXp5nT
         rJwIYZ+XLxwe919a9GbWMgCxayvIv2bwDw1HLg6CdxY/ddzIIRDUDSddExVVEBRS9at2
         0gitikB3O4t2ZlXOPkZhJ21JZgEhckQaOO4o06cGYDBDFjBhVkV2LlWYfQF9UFvaTvA8
         d2wA==
X-Gm-Message-State: ACgBeo11BTfFwYfBzWa7ZonubUBc3lmS3p0vXYNB6tKN5VV2NXzDYZjm
        YSKKUplrr8GoufncQ6DmSuS4d9i4vU2WLSx8wjM=
X-Google-Smtp-Source: AA6agR7T+OzWs6/TNlPnYiLpfddblC+KAJex/AIRjUAtAlKaqKg/KzJ1Ka703hP2eqUg8d4q+Z16w8de/glbGGZ1Y3Y=
X-Received: by 2002:a9d:12b6:0:b0:637:3766:b4eb with SMTP id
 g51-20020a9d12b6000000b006373766b4ebmr4483721otg.220.1660481536741; Sun, 14
 Aug 2022 05:52:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5ec:0:0:0:0:0 with HTTP; Sun, 14 Aug 2022 05:52:16 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <ts069435@gmail.com>
Date:   Sun, 14 Aug 2022 04:52:16 -0800
Message-ID: <CALDOJZBJeitc9kFSo=BxSMXe9E_AD=iqtpRjeyLv-H-__GiL5w@mail.gmail.com>
Subject: Hi,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:329 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [ts069435[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [ts069435[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [lilywilliam989[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dear,

My name is Dr Lily William from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lily
