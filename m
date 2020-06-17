Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9531FB998
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgFPQFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731274AbgFPQE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:04:59 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55851C061573;
        Tue, 16 Jun 2020 09:04:59 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g2so4470928lfb.0;
        Tue, 16 Jun 2020 09:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MeFbfp0L1/Pg7xdn8oijFrghT8Va6YBvR3vBK4xUMP0=;
        b=d+EP268ZacOWGl5S1RHG/kDDQZdWFb5iY1YK7wCvyO0C4X43F6Ma23SH964N8NHWhk
         ROwU2lRgSVzJz4tl3VW4v7lVqmPOzDoAF3O5xwv+wQ/qa4UXuXjDx8fdeWRMKEHCcPDm
         cTCfmtpPgNHl5wFM/nC4E5cLjQDLcT8z5Pqb7VLmTdN9FEBmKm22NoG8uPp6P0EUKHsU
         Q41eydJr+CbDQ0CFkUYOguilQk0PCGtfTyYLyW/jLtcOIaRdIQOkA5uEwd7zTvtNza5M
         Op5qMWhsDXpmnxWUqBCbaNyYgsmk4rVewme9MDsTFna0wSbBVwLZ1tkOmy1/X6IPy2U8
         YWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MeFbfp0L1/Pg7xdn8oijFrghT8Va6YBvR3vBK4xUMP0=;
        b=hfWrmibjxcBqUgLMmjptvBUIl7tT1hBmO5iMeADUmrZCyauiT5XSOx8Mvneyale8Ty
         8nGd2cTUb125jdqOvEgTpYHv/jiPEUG4u8tbtgE2aPpAIuJraS8ztlBIJ2NlEy/8Vktx
         9vrVmI0/fupPu0U3fX5ICvgdOVzzDlpZI43GZgMhoyDIquMkcK28nzqIErzgPNvu5VGB
         zyUBpQPwOxFtrSC9J84yxZqgaq7nP3d2RgbICzAm2ARnuk+m1JktByzrf9s9GKo7w4qj
         RvyvXyLLZaGbPGz9KnFH/rw6BIgKR0Dkz5z8uyVMQs+8bS0nn21GJbh1r54lsiRqeUBW
         +W6g==
X-Gm-Message-State: AOAM53254L40qZI7P+P7VCAA2L5HS1lzF7+7R99cCf1uNKusjPfhyyo6
        E+fBAFgn8xZoBo8Yc2wS3VswQGupLS7q6Je0dPw=
X-Google-Smtp-Source: ABdhPJzgzr2FDL3LM2rwrKWJsUxgD0Y9dMRhQzFI2SYXgeQZysl7+9OamVjtupGZ4WAyxf7VCfLw3dyo/mx9FlkfpzM=
X-Received: by 2002:ac2:494f:: with SMTP id o15mr1559816lfi.140.1592323497885;
 Tue, 16 Jun 2020 09:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200615154114.13184-1-mayflowerera@gmail.com> <20200615.182343.221546986577273426.davem@davemloft.net>
In-Reply-To: <20200615.182343.221546986577273426.davem@davemloft.net>
From:   Era Mayflower <mayflowerera@gmail.com>
Date:   Wed, 17 Jun 2020 01:02:00 +0000
Message-ID: <CAMdQvKvJ7MXihELmPW2LC3PAgXMK2OG6bJjPNJkCgE6eZftDVw@mail.gmail.com>
Subject: Re: [PATCH] macsec: Support 32bit PN netlink attribute for XPN links
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 1:23 AM David Miller <davem@davemloft.net> wrote:
>
> From: Era Mayflower <mayflowerera@gmail.com>
> Date: Tue, 16 Jun 2020 00:41:14 +0900
>
> > +     if (tb_sa[MACSEC_SA_ATTR_PN]) {
>
> validate_add_rxsa() requires that MACSET_SA_ATTR_PN be non-NULL, so
> you don't need to add this check here.
>

validate_add_rxsa() did not originally contain that requirement.
It does exist in validate_add_txsa(), which means that providing a PN
is necessary only when creating TXSA.
When creating an RXSA without providing a PN it will be set to 1
(init_rx_sa+15).
This is the original behavior which of course can be changed.

- Era.
