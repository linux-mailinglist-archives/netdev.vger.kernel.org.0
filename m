Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591254840C0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiADLZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiADLZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:25:00 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B97C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 03:25:00 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y22so147265471edq.2
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 03:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=EeXKLOCMbn4HlJrfgc6UKL65RIrLHfzzUsv5dDkwdSZWQ6dkDtlEnEX+eKnXC6sc4g
         O+yucA8I5jfYLDBKwIjtZvJo++XbG60HN0YjB0xbtpy94RM17UubmpfHpe7ezyTGZ225
         32I+TjNE+QwHSU8LkSlVDrkoDFp7WvSMznmT/e+4r5nRmUkbF2qOfTbC4eCd4127HqGj
         S12MhaCWjbE3kpvo54Dx5EcTkwOAp/BmjWSMEEBawuMGE169oHsZ7aypYaYs2LqCOHJW
         X6UW5riYpVRwqq3AhkbMfz4MUeR5bPGQfmNo7crnG/CsB40k1f79I9GTZuRDdgY1381M
         PAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=nOdIa1KlxLjLGBWyBtwTWXFwWReE7ZYL2xKmj9M6gFQchF0PhEsjZvxHVphR1KtIdJ
         2dcGfZ503Xm9NeGtJnJ0G+dgfhCXyDYHpCUPY6C27LBJ3qMcxAUWCfG2meH5aGg1DXjA
         F83WiKEcCgnciOormCplTPMow1gdXJo8JPwVXGxw76eS3L2a7txCwaeqh7/pbWp4vfny
         Jpj6M+++rz7v5RGQNNtiJ6OiDi56/FQwASxafXWjntt4DVvLSmEAEx7s6sw24rze3b78
         wY94lYSczb5V9zaPAHewc2unjONhixq4Zs5vJWz4l0m1+IysC8EX06x/fQ6mckoWSxWc
         f8xQ==
X-Gm-Message-State: AOAM532RTWqVgXZC8zmqedmNGF15edVEpCqgO3NESkv+RHp5KPgirLfx
        7aARiEIg753YQhv26C5Ax+Axp5dpiiQcqOZHXRg=
X-Google-Smtp-Source: ABdhPJx5gjnjWL55TfeGEGBSAfqFLXx9lW0a3LIqTVK27h7HLj3C2bvTc31poJLTNaeonLZAkRgOnM1d3EQ8NnPON+4=
X-Received: by 2002:aa7:d795:: with SMTP id s21mr16094429edq.30.1641295498556;
 Tue, 04 Jan 2022 03:24:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: www.ups.usa01@gmail.com
Received: by 2002:a17:906:c10c:0:0:0:0 with HTTP; Tue, 4 Jan 2022 03:24:57
 -0800 (PST)
From:   Zahiri Keen <zahirikeen2@gmail.com>
Date:   Tue, 4 Jan 2022 11:24:57 +0000
X-Google-Sender-Auth: _n_iCnoMHtKsvd5Otl-96tjs_I0
Message-ID: <CABpS9gZVu5zZgKtyMXhA3FaB0BQxEo_ngUDPQAOY-Nwu-XKUFw@mail.gmail.com>
Subject: Very Urgent Please.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I know this email might come to you as a surprise because is coming
from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri
