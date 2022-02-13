Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA9E4B3D25
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiBMTfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:35:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBMTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:35:06 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED72056C20
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 11:35:00 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id o17so19583098ljp.1
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 11:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=oCya7JKiXIIOQFZLN97e/VgQOarpYqjnN3tsLEbz9dbs5foYuY0+OJRHk6I//QIiB4
         JcKCZSNCyR9p3fpV7WI51D+CrxAOW4dd7Rw7nHSFM4lDGb9uw8iVoXGh8Xj2pMsh+w/9
         khmyo90IjzhqTb6HjgEfXyksVfSQr2WlGSuJNRBeEuOEVXLutMfFJ9eIfYHCR2DRS+RK
         zB1nDTFjno2nDDxxmagMqAGqSmQTGorcufJ6MJYmIzueob9k61AclJPDBXqSaGAMtu6G
         pMuZVSYn1hHZLatCfgy4NdtkD8jW2hPV6bXhlvkots6Ns0H5UAeNIpiL5Oo3+1aMfP88
         up4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=2ceCEbzbY2DwOSnOK0Ac0Htx1Plu/hKJRKn/4bnMcoOj9F5LjyPxxz4d2vymPdwJ3V
         UxPuLWNjO+5BmySVJrVwrp2iGfySgGcM/LED6Woh1ICseGp/nsHJQNVtU4nq5xYK4TmG
         tEPJwK+BRWQhtihE0wDOPrZg7Si5JCC+zfuEL4pc3p3hQ42332b79jflTcnpk/oOXFFa
         C58IbRyTM7xw0W8NiFw3mA6kDfe0IhSndTaJqhJ5m83Db6HCNQJ3bG5TICYy/5WdPfKg
         VKN6GqNOaiUA/IQvz16cpDxkVQz3lx/KlECHghVk6QVWsMUy5+tvl98Jdnxpn9k/GpFF
         4K7Q==
X-Gm-Message-State: AOAM533OuqzrYuaTGzFjIMvB119p6INzhUgMARM42Faqhbxk6NQTA8+v
        USI8/8ZxN/8BjO4Bt5eWE9qRwAI8X9RvFzPNxG0=
X-Google-Smtp-Source: ABdhPJxcHZk1jVTZ1DtrsYrIUDdwNRD0nYKFuoqksEXMG+qUlRu5ZVrA/Nvqkmr6zDdv3GSXLZlPirJdJgRwWsaAe/I=
X-Received: by 2002:a05:651c:545:: with SMTP id q5mr7004649ljp.393.1644780899171;
 Sun, 13 Feb 2022 11:34:59 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:3102:0:0:0:0:0 with HTTP; Sun, 13 Feb 2022 11:34:58
 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <tracydr873@gmail.com>
Date:   Sun, 13 Feb 2022 11:34:58 -0800
Message-ID: <CAARq6VZuXujzPzjBt8xs2ZH_Lhn-uDDEPSbEgp2KE1382iEKCA@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
