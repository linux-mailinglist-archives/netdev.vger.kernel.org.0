Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0ACC4B0BB7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 12:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbiBJLDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 06:03:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240099AbiBJLDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 06:03:43 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D99E1010
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 03:03:44 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id w7so6756414ioj.5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 03:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=NN9aoIk0pszE9OrDonC9R3z/bEHyPTewqP2Lhw2V3cg=;
        b=HkWf7gzE0CGTRQqeUKja9ufzPc2tOFfJLPybcSw/EQ59Vy/iObpYX6hL6T9G+lsboh
         q29zfsQatI0EaFfS/zDLFTyO1Yi6Vv632UczCVFLxFYqtaAXmPfdVh1Gl9K0OB8VBK3x
         D1hn5Y/LMnfUtTucY/mxETun7BJDwjF2vJ6Ol6qCf9aSpbT9H7irJgz/bO1VYM/uEpke
         Uz4xSg+JvDUnxbdpcGMPJEHJvMEN5fpV6cGXOUnbGbOpNJ5C6DiVi+6ek4Z84YtAI6i+
         d3/qlDOQIbv9Er9DJuds70hRgTV6Z21WJhQwCBSly02rr0zP+J40b2DnDFgRxKph+IPw
         4wFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=NN9aoIk0pszE9OrDonC9R3z/bEHyPTewqP2Lhw2V3cg=;
        b=OHRYR4eOakwB1tOkf4fv6F1ETmZ3fxfj2dl4fgYI5NhYy8EFHPzfcTSog6AqxiERQD
         bj6dxLrD0FroTz9TKHIaOdwrYB2B5S1sbogw2njsapAXUWTaR1bkOl/6uCVkxyoYekgd
         fgeGGumYG9uV29BHEzN7fNYm7TUraLT4sb+sgEkOxuhuAHisOEu7PIIJsZNjW6sOgRYf
         z1EUsNkq+N3osObOuIpvyUf91klpOj0aLFmCXGGCf/aRbqFZRoq5hgmyRNFPbVRT853Q
         gvIXKbmMExHGkZ6TKDsvfsX4DV20MSP5jnQyDj7yBN0NH9a3fvToeL/iNvTU05GazdA8
         ubhA==
X-Gm-Message-State: AOAM532kbqu5K80/HsfrB9eJABE6/x1T1/MhgO/BDna204mO5CE49jTA
        q5J/labyxfRkW2Vn0txA3F+hSjJ1sFFz/wAEmTk=
X-Google-Smtp-Source: ABdhPJxb/c4HUEBQZdmKLUzeZl2be+ZR+n8CBYbtz+0S4cjVv8ONTYFcss7TICBSC8wv6m1bazBO0weNkCkGxNXGSu0=
X-Received: by 2002:a5e:dd09:: with SMTP id t9mr3463661iop.207.1644491024030;
 Thu, 10 Feb 2022 03:03:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a92:ca0c:0:0:0:0:0 with HTTP; Thu, 10 Feb 2022 03:03:43
 -0800 (PST)
From:   kate Mcknight <katehug40@gmail.com>
Date:   Thu, 10 Feb 2022 11:03:43 +0000
Message-ID: <CAOcQt=UwWNxccz3CDfaydi7-6v3SXW+FxXgQKfLv3Rd66+5bVg@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sveiki, mielieji, ar gal=C4=97tum=C4=97te susisiekti su manimi d=C4=97l sku=
bios ir
jums svarbios informacijos.
