Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA92476E74
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 11:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbhLPKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 05:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbhLPKAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 05:00:15 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB35BC06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 02:00:14 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id s11so288191ilt.13
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 02:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=SWc3yyZEaFLTXBk8NYLxEovZS1OKDxNzdDjBY9IhGyk=;
        b=A/yfYspFyxeg1z6Huxp6+7wYG43zx2VXvonJciRbsSrbfiS93j2XOEFIPuicahJKAc
         Q+IE3AHfwuEPiKnnmysvFfQhigNMyRR84QmZj0/nLEZGlJ9rDUl3wrpGWMMdAXaqKbX9
         7MKZf0sRXHVKIeVX8zvKsgNRg7Ja0HfudEfF2aY1DJMQKtBCmvqzZpgq/coLHuE2voci
         lozbsGbo4fuJqQBDFlSyJNYSpHYU9ENaS39BYa1R1DxRwgnkH/JtIRtIrpmtC+fu0x9x
         eBOt+YJJab0outfUkGEmhYeyrePWAWfGWKVcLb3TfJL+RwBevfRykyxOTeJ9Rbpp7YEg
         4+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=SWc3yyZEaFLTXBk8NYLxEovZS1OKDxNzdDjBY9IhGyk=;
        b=3Lj3q3TZipjYIv5p8Ni0UukRm+5bNZWmBoq3ynPIFe3xtZ4JmCp1byB5rEgHSivlMq
         aHlHAwD/AufqtXqnEbu72t+pxFH/nRyIrnKQs9XQ/CUpMJq9b1lw3Zx8rKteQMNShXl7
         FyRz6wCW3RNKOZbYC1vrT0f8XKvkbgyWIIt6mSqHzhOQBs6HZALP4iuDdF3OgMBR0fZC
         5uc4dU+QH6H87khJk4fYIJ5n2g39gvu0DshGq9gbPFe8KIrgeGStyRT9lxdkrE/dF/AW
         gpRg0q9wRgZifYuJ6FmxSSgolmyGr1nIKEHQP45fPkviwf1KfoOssHJZrvDEaFZGqeL8
         BEXA==
X-Gm-Message-State: AOAM533cmm0MaFkc1l+LSJ/PgX2EVc7W11dQcrGbS35Ng9BsesX49Quv
        xiospx2j5lMDCGMlmQt3vLwj9NLWScFpWZTL/4U=
X-Google-Smtp-Source: ABdhPJyaX8oJS4wPQCmOE8t+loFVQu1tYCZo/JeMgQteIwnt6R6QJBb48nJqS4CYqk5ZF9a6WeqwzIa/ZVcsZ/Cn9WI=
X-Received: by 2002:a05:6e02:144f:: with SMTP id p15mr8995204ilo.180.1639648814401;
 Thu, 16 Dec 2021 02:00:14 -0800 (PST)
MIME-Version: 1.0
Reply-To: garnerjulianne63@gmail.com
Sender: manuelcrouch4@gmail.com
Received: by 2002:a05:6602:3c7:0:0:0:0 with HTTP; Thu, 16 Dec 2021 02:00:13
 -0800 (PST)
From:   Garner Julianne <robertalex2017@gmail.com>
Date:   Thu, 16 Dec 2021 10:00:13 +0000
X-Google-Sender-Auth: an359cxeYe_ecRKsSn1_Zqd0aXA
Message-ID: <CAGLfTVfj9VoytK8U_ExjZ-te3K7qpmxwWtLBMJ+HDV5=OU_zgw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear, did you receive my previous email?
