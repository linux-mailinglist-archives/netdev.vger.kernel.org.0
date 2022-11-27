Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCCF6399C4
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 09:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiK0Iw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 03:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiK0Iw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 03:52:28 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38E1274C
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 00:52:27 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so6506993pjo.3
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 00:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5utqU/w2Zfi0vu7i7vvjwzf4neJVm9hjUKrgyZdZqbY=;
        b=Bt1zaqgzTr519xXCYvV3M1mK13q5yZxESBRsh+/4h05Oq4rFFIkxHy7jhtDLAGZ6M5
         opEsFrkDrHwXXgGWutPBha59+t/91gXCIlMgNn+3+vLVR9v4kWIZ3wWqF89jwEzTIiS0
         ptukp2/6vj4xy4WQrw+r9qXxD/W0ZMvOt+K4SU/cBGcUAgm03kMJRuPgi/vhKScmrGgW
         x7bcIs4T7JLQWVijhBLVGM+ZZnxY5wOgI/5DBfOq1Co5eEfeqHrLc9N9Bcw2uRI+RNQs
         lF9M6Up9mWK0XY+qFJFrQfscsrg7VfKvtw9zny78ImLUxMYk2QGu14hIBDd33bMCmaN+
         jQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5utqU/w2Zfi0vu7i7vvjwzf4neJVm9hjUKrgyZdZqbY=;
        b=vKSNoLAx43Mh6T3os4KaI2QLFXFEH461w7QzcUgbEcbtC8Wi/YwNR8C3Ul26tpEpIx
         go3eqpjUmdY0h4JkOjPlzjIChjtNBPOQmKQgdpCs9prrd52KX0KjSEe7Tpxtu4PIVm3p
         To7Cm08NN1bd3XD4CFjN5YgVB8N9UOxIJZbi4DieTTiShibdMupgm1sPip9IA+JD52dn
         NP+skmOk1zW48kQ7Q9MaCswq6KS/iUArT6Y6zhgSegOg4wJ0/+gQQCfj6kZVganC6cgJ
         r0TbJ8HmjdZtnP9U0L6RXIHBpzDsNgqHG9c41D544fxg8XLg5Kj9YuMB9rgqe3QR3k9w
         qH+w==
X-Gm-Message-State: ANoB5pmaZt1Ebb3KGbo47BK7frSXzbx7HVtcsVKTXLzI3D86b/NmxR8c
        +vGsCysLG3fsocq1rnLuwy3DVASyoCqDI+TmGlE=
X-Google-Smtp-Source: AA0mqf6YdNoHVCpuQHeYfYuFJm8R4BBJQ7KXG+vVwSsB1UxpHKULFpS4dIIA2Mvg/Kep8BHuQ6FdSx6MLhd1u9tlEyM=
X-Received: by 2002:a17:90a:a082:b0:218:a7c3:e760 with SMTP id
 r2-20020a17090aa08200b00218a7c3e760mr34786214pjp.127.1669539147209; Sun, 27
 Nov 2022 00:52:27 -0800 (PST)
MIME-Version: 1.0
Sender: amehomeallagbe@gmail.com
Received: by 2002:ac4:9908:0:b0:586:6ef4:53e1 with HTTP; Sun, 27 Nov 2022
 00:52:26 -0800 (PST)
From:   Richard Williams <wrichard6019@gmail.com>
Date:   Sun, 27 Nov 2022 08:52:26 +0000
X-Google-Sender-Auth: 07AfRLCRfJz8bwpsSxtd68IXGlI
Message-ID: <CAC2EXNXgTGHgQ8b4PA_vDSt7aNbUMiYY5QPo1YdVuLMiQ=AbgA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Please I got your contact online, I seek for a business partnership
with you. if you are interested write back for more details.

Richard
