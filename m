Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0CC58BBB7
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 17:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiHGP4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiHGP4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 11:56:45 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE3A95B7
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 08:56:44 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id j66-20020a9d17c8000000b00636b0377a8cso4052875otj.1
        for <netdev@vger.kernel.org>; Sun, 07 Aug 2022 08:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=tnkMy90miiYykpI+4R1JbqPUfm8FqXUj36yuJdO5lZQ=;
        b=04TcRDDnQ/n11tjO3q2a9hJ4jGbfIbJaW7mx0SB6gZ5L4yoY8n3fLm3er880S4x4iX
         vzYte+KixhJeKl+VthtAq3fFD9LJarWfY356ntsGb0STqseQGrOP8MkME58FPFPcj90Y
         +YDXcGXh6AOQ5o819qrFPx/RP3vmykt6X7yuBOwyAod3AxgrwanNJnphHPRRLfNtyv1B
         7aLSl1pfs7CDf+d2xNRPQEzeg1qEsccxszVPUxCxyCOPlVPaKSpJh6cokkwKcaUEhg7R
         6WV868ttwy1j/VZoWibA0kF/REF19gC7jVCOCpRwUG4OrjHIpd5odWIcx6xBFbJ0xuYt
         yvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tnkMy90miiYykpI+4R1JbqPUfm8FqXUj36yuJdO5lZQ=;
        b=2CEaOntv24e4Td4+eqylu+sMyeYYI3gNaNE3wastsU78psUFBd+0upm/Xplf4Oytcj
         /RS8tn5Xvn2HcNIpjUCHVg9MHW7C1xGXF/GDexnePhRyYfwDmzetUwEASY0U5Cm31QDT
         0dVqPv3IPc3QSSPWjUvJY+N1aMIiRS3QDI3cMii0gNz8FtM3NKqCc3jSOMjDxpDOUByx
         KzKIeBUmM9v2you9TdoEE/cA97GmaZjjeNInaHpTkHralxRZgeMVkJKKfQryLUZjbzDu
         L2HF/kfgx8N+LGg+NMPX7lLv8lorQ/ntYlbhqFJ9dQqUfxLnosU1jl2CZZ5mAWkNtMjU
         fuYA==
X-Gm-Message-State: ACgBeo2OryCjZcZPNn8fNqhR2jx0Gf0/szPsRuq9nJ2U2xbR9Zx67q9/
        p58jbl2vg3imbnwk2IZrL2U6Orgu2yTOAYsNlzJI
X-Google-Smtp-Source: AA6agR4Jo+rOQva+fvprNdCfYk170dTkQW52EuCCfVrlN5lste6gHm1XEEVirBB3TnHF9GTNsVkrILmixIDOMbPMhIc=
X-Received: by 2002:a9d:4d13:0:b0:636:bdd9:b57b with SMTP id
 n19-20020a9d4d13000000b00636bdd9b57bmr3280310otf.26.1659887803849; Sun, 07
 Aug 2022 08:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220806101253.13865-1-toiwoton@gmail.com>
In-Reply-To: <20220806101253.13865-1-toiwoton@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 7 Aug 2022 11:56:33 -0400
Message-ID: <CAHC9VhQz_gcJHuKEpkJTgOw1PLHNoEY+vniEpW+qs=76w0eLPQ@mail.gmail.com>
Subject: Re: [PATCH] netlabel: fix typo in comment
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 6, 2022 at 6:13 AM Topi Miettinen <toiwoton@gmail.com> wrote:
>
> 'IPv4 and IPv4' should be 'IPv4 and IPv6'.
>
> Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
> ---
>  net/netlabel/netlabel_unlabeled.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for catching this.

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul-moore.com
