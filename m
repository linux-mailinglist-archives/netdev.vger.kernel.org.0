Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1383B511998
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbiD0NFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbiD0NFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:05:19 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD84652E66
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 06:02:08 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y32so3013411lfa.6
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 06:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=s30N5qylYdNrn3Ko8eA0xWLBjxFo/07Uv2RUH2sLNmY=;
        b=bXSxuC3EBH9WRfeB3xOK1rEuqCvoAMVfVqoNUm3kFjSGHdh3L93Dn1NVycyT8LGvkW
         UiQAaICDlnG5WqguVMoIyAQELoQ/afqvOoh/5w5dc3x5PwuuzcD8jyjeTZqw1e+yFUe/
         QfCS+uKMlU9BTzlUXpD5SxMB6OaYXh6xuQsPdYF9aaAcOkzLwVOpM9D0TDH1D1wgJWZV
         bQfX0Exj3YHTh5TP3EpjBKhe96jh323TZygH8pMw9peNWGQQsAbw4S439dLEPONBNtrk
         4bRd/UyhHXRx24QIejw3ekhmRfd8loWBrcPSlPEZ1JrDF42RL1iVBj8tcgu0bEV16U8Q
         PKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=s30N5qylYdNrn3Ko8eA0xWLBjxFo/07Uv2RUH2sLNmY=;
        b=wqxNsHKPWpXz9PY80jygZ4Ip2OE4D9kXdbco0l9T57jn0ERXIcGYnCmSRv+YB0hf9j
         s7CgrK3dEMGyDanOPxrejdCPTvqqD/Jnn8/cQzOL46ahI92SrdeVC967c1WAHY58soLA
         DFiAxlI9flaR/whsXzTmhNdSrGLZ0hKBfSk2hlwm+TsbS+7H+wXHyR7K72pXNnj2XF+v
         gjXgbFv/qVIf6qSazdFK9ksJe/ji7htjg8qn0jsuQbFV5sDaEhyOCBiUzQp/7HdUlYb0
         tlfvNlejQmsBGaLFqYSlc8YGwph7ILlEvbRMopSL581AckmGyJd0dooX87injXQlZDVm
         pf6Q==
X-Gm-Message-State: AOAM531t4cHt676krDOZJNKmiylJxCfRbh1iLKIByR45XOwR/oA8OBzl
        36T+VHfgtZzhs6v4pUAxdxbaaBN9iFnt1pMnrRc=
X-Google-Smtp-Source: ABdhPJxi5T2L5rwmeDFFUps17bYGBLnY5bT23MxhHKkSP7gmIMDeqAj1tMCDiU7Mz1VrKhzb7ExoY+4DqkvOcDes32M=
X-Received: by 2002:a05:6512:10c5:b0:471:924f:1eed with SMTP id
 k5-20020a05651210c500b00471924f1eedmr20482477lfg.641.1651064526821; Wed, 27
 Apr 2022 06:02:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:460e:0:0:0:0:0 with HTTP; Wed, 27 Apr 2022 06:02:05
 -0700 (PDT)
Reply-To: sgtmanthey22@gmail.com
From:   kayla manthey <majideeklou@gmail.com>
Date:   Wed, 27 Apr 2022 06:02:05 -0700
Message-ID: <CAH00ppxvtrE=6y9QkF2HQm6NMOm3EnOdbB+_MPt-2CZ=d_Ykjg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Pros=C3=ADm, chcem vedie=C5=A5, =C4=8Di ste dostali moje predch=C3=A1dzaj=
=C3=BAce spr=C3=A1vy.
