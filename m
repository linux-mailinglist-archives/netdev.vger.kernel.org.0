Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DFA338ECA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 14:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhCLN3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 08:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhCLN2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 08:28:48 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBC0C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 05:28:48 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id mj10so53343391ejb.5
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 05:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=FQ2aasB56Vn5jNmr9lzKwT2xMETRXsWikdfbjU+uD4PTtwJ6tG/lJoAC01ptdfTuz4
         EdUPh4GiQIFwT4NAuQ1il96Tf0oKo6U6uuVAekYtjwJweEjbFeNjnXeYUcGlJHis7wyS
         4StWZwwlFZ2r91dveoc2SbBi0GVn4fgyl8A+Drqoq5omBShv0iCjaWhaCcinVnlSaWeS
         iNsKGMVOduzpgb27kj2qVcU37XHbNnMCyHDLQrujRwPvowUs4zTCjVgHWtAUSfDIiH8F
         bym5T+P/mmpKOvwAxjrait4lLvMMzVyVUMEEJ+mhUvyhFxY4NeGs1FUaHsnl5fJGr9uF
         90tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=V15jykBa+N5j9LW+oDUMatnueNmRnkOpS2oqDgDP8M8KihtXf+xefykweZ2KTU28wG
         JPw3Xpry1dhNmcug06LfklkaTwR43F0yowPCyKbMmFcAn4/QKiSGd+JvAWpZPyb5a24n
         08enHa9dKa/EhEve7BeK5LmopkVKu+EbzKGDWqbwUj7qRCezeBbXxd1L8IyOm0bhHwOt
         khrV5Lo5SPx9GiPiCI5tMoRP1QkX1lLPPgs8S6ikTQ+pA7fIo3y37iuN6PF+11+HH4OK
         nPeCYbMpX5r5e18P4lxOJfA1pwfaKdASXMUEmBUpgx6QywyWp1D95IhuKXEuTZV+VZVU
         EkuQ==
X-Gm-Message-State: AOAM530rpOmucvLeBayq9KNBcYeaviY/b4A51R1JSI4OD8uDmvyqUNPL
        viP/2QIzpf/prcoezAmsAFCR1BjSXx06dRYv66A=
X-Google-Smtp-Source: ABdhPJyT/CG0ujhQdUSLylv1d/z8uIqoWYPbkuBcpn+zAIK/hdguBhpbBfEoj60MXBbsp8Iwqn7DHKLwuBkMWaYO3UQ=
X-Received: by 2002:a17:906:b14b:: with SMTP id bt11mr8839094ejb.162.1615555726975;
 Fri, 12 Mar 2021 05:28:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:af79:0:0:0:0 with HTTP; Fri, 12 Mar 2021 05:28:46
 -0800 (PST)
Reply-To: robertskevin3911@gmail.com
From:   Kevin Roberts <lasergeocana@gmail.com>
Date:   Fri, 12 Mar 2021 13:28:46 +0000
Message-ID: <CAE-ohfsBvoanRzBPH2rJDxfuh2QRbSVnXKtNO711LqQpJeOQJg@mail.gmail.com>
Subject: I sent you a mail earlier but not sure if you received it, kindly
 check your email and get back to me for I have very urgent information to
 pass to you.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


