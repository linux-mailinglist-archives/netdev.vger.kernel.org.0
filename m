Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92DD2B0C9F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKLS2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgKLS2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:28:07 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7D5C0613D1;
        Thu, 12 Nov 2020 10:28:07 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 62so4881102pgg.12;
        Thu, 12 Nov 2020 10:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=vwjlBjbDACtF4Ua3IbKJkxhnFWucyDlPX5A5nXv2EN8=;
        b=cB4HyCmrsIuqY2VFPTDD/VSa2CfXvmm/b5n6asHrugHLJOJsis/mh+JMDujKIqcmwP
         LdZBsWZTTQjdlI2ZLx9wpfIPJcboIHq8qo1I4ATGfXdrymmm7HjB63Hf3GDCfHOKLo40
         VDstk/JehBUQZFgcOTb7pWFd3/drACsU/1Y5K/k+93y9MMaPf45oWm+Rcm//3gJhPiYd
         n5klQNsxWrBizSGZe3tk7nAVWTPLPcazV3DFlZBbzyP6tbsdd8dyKDiAlNGyyTrqwPTD
         tfDL3XEHe+Irymle1n1rYLq62IHwkbRt6rFiKVWDoLgjjQlIsLcgMfarK97+jJXxxkqp
         w6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=vwjlBjbDACtF4Ua3IbKJkxhnFWucyDlPX5A5nXv2EN8=;
        b=Cldvs8Q+ZMAFh8GIGKbxsrkdVfJ8HRA4UWbVV+bqJ7YvfzZuAqcj1YSuJOG6fvCQzZ
         JE2EEBmsj6tUd11jfPxIigKU85VjUCtOPhHGUj6c0Yxmh3i4CKM8xfkRsFVy6POmAUpR
         uzZITCuv+rk3vaWUJiCYt0n+mYYoL1vXMSYkRx4wPx37I6wEsLFzOfKFXcHUoTTV2OXY
         tfvIcWsdOu3lqOJe2N25Y+auN3heKFLdsIgkSkrE8sFXOnZhvotfBZF0ti+XLFKJSi/G
         gFP0ZF+i0d2n6PoIMG7D/diYIBmVDwvinpUnN1Z1zurx6eVaQD8dnyQMrPPhqhfSe01r
         /I8w==
X-Gm-Message-State: AOAM530NDXKLMRcdkyhFCloZD9K+lIbmU44brl0FyYM6+OwV/2Fxyg8a
        wfXj3jGUL1K3C0LgfAzYq+9Ktb81vKQpVVDuvLA977OM+HU=
X-Google-Smtp-Source: ABdhPJzTnXh+vnZ3ywWbkNtvZXRQxelAtjzShYns1U62P3ua906RZD1BUayEA84ZqaEPZe1JiyHep0GDGH1pW4Z56KE=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr711902pfw.63.1605205686789; Thu, 12 Nov
 2020 10:28:06 -0800 (PST)
MIME-Version: 1.0
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 12 Nov 2020 10:27:56 -0800
Message-ID: <CAJht_EMXvAEtKfivV2K-mC=0=G1n2_yQAZduSt7rxRV+bFUUMQ@mail.gmail.com>
Subject: linux-x25 mail list not working
To:     postmaster@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Martin Schiller <ms@dev.tdt.de>, Arnd Bergmann <arnd@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linux maintainers,

The linux-x25 mail list doesn't seem to be working. We sent a lot of
emails to linux-x25 but Martin Schiller as a subscriber hasn't
received a single email from the mail list.

Looking at the mail list archive at:
    https://www.spinics.net/lists/linux-x25/
I see the last email in the archive was in 2009. It's likely that this
mail list has stopped working since 2009.

Can you please help fix this mail list. Thanks!

Xie He
