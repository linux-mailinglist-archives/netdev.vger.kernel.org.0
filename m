Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8989549295C
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiARPGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiARPGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 10:06:18 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9443DC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 07:06:18 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id c36so37197885uae.13
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 07:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1xakut+EUmMt4G+isqH1pd4iN1tbLC0FulkcYEgKjs0=;
        b=XZtOPPjXYRTIH9tNiuMKe2K6xyd3+BttxP7ejuokVqPqY7J9SkIk6vhAPTZ6W6UHX4
         k8hoklNRnwjanxsxBDjYw313niZ86+rBVj7COXMf+4C8lPKIcUFmI8z11U43DrHcMM8q
         gt6pOtT5XZEUj/5G2ZlLm85z0WuvkvW/xyuTlm0bHcdUA5SGURw+xZWbRlEt+kO2mMge
         Qm2au0umxtJEN3myGYB1C6+S5arcHIq00zv5M+7+cnRpxc+4q9B9qyYfBBaOvpkTNkbY
         zvpybULUVUYGqRAiHgvovRunBfmto9LTli9/or7QsH/ck0cnEvCJmBn0cclryjwwdcFp
         CrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=1xakut+EUmMt4G+isqH1pd4iN1tbLC0FulkcYEgKjs0=;
        b=K9YSah4OjcWvu1px2qVNWP3xNHBfOPsJsbZemltcpyyR0AwYipu9hUGw+o9jQNkP/j
         Ggm3OvSG04//yEgVg5TRWtqoQUhkIoHhvaZ0KWpCYDd5pTf0IkEYzruVyCjnUsfH3sNA
         HFSx3dn7Eyhq3vI6z8CHeP0JMcexv1PjKxLKHZ+yzMo4m2WrVidldO6cM5EvvWPl9SYQ
         ESSv/iCvf7zKVa71P9etbmcy5KUeXkppH6wmfBqewgHUy8CZ0wRLthsVVcBE7dvUsdY4
         rJwpHcCIGSTMUxwlPZW58wP1VyWyPvt8U+AIfqU23LkfDpqwdsxPnUtsILz3apf8CkDw
         qj/Q==
X-Gm-Message-State: AOAM53142qu0vpuYlKCALgJ8VXL64pqp5x/p9Zh5KBdrwbzV64zF4oFA
        0s4eihsJbLagm9ZQ16JE1uI0Z/GnfD1ukkQrfyw=
X-Google-Smtp-Source: ABdhPJx9DNzusXaFLj5EfyhbTj0yl1R4Z59cFVSm2O2YP2MjgDqsMxOvJkGmnrUv5qlomQUNJ5+/wcWcC4wE+x9T8V4=
X-Received: by 2002:a05:6102:c8e:: with SMTP id f14mr9787803vst.57.1642518377760;
 Tue, 18 Jan 2022 07:06:17 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:612c:158e:b0:27c:4d2b:7ac6 with HTTP; Tue, 18 Jan 2022
 07:06:17 -0800 (PST)
Reply-To: michellegoodman035@gmail.com
From:   Michelle Goodman <michellegoodman001@gmail.com>
Date:   Tue, 18 Jan 2022 15:06:17 +0000
Message-ID: <CA+jr58qH02Sj0+mj5_=E6yBtRWTgjnQBXCkk-9OxD6=F8K5c-Q@mail.gmail.com>
Subject: Michelle'den
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWVyaGFiYSB1bWFyxLFtIG1lc2FqxLFtxLEgYWxtxLHFn3PEsW7EsXpkxLFyLg0KaMSxemzEsSBj
ZXZhcGxhcmEgaWh0aXlhY8SxbSB2YXINCkZhemxhDQpUZcWfZWtrw7xybGVyLg0KTWljaGVsbGUN
Cg==
