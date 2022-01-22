Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5B496BD6
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 12:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiAVLJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 06:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiAVLJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 06:09:52 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F852C06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 03:09:52 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id c6so35212152ybk.3
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 03:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=siIUGN7ikpV++GeMqVxj3L2ZvjDwDfE3KrxEg3AC/Fk=;
        b=cduyIFyDcLsypT6znBhctJjX8qjE+Q8ebk7johAPXLNmu7SB8eRlrGmW3Hk4nhm9nn
         +PYLvbPHUJDCPpV/hDPK3S2R2DOZKTMOHb4KHMVB+lPrwrFs+WiyZ20q6+GmgLH9c+m4
         KAlzazWt8t6EXYt7z9zrULMY7qCPwW6Q5xrIn9RW76qw61Y0bzYfo345udJRfAvHD4em
         3zusBz01B+HtrzEYEFEImgFX8taMSxzJ0wi4/HXhjQOMujPzVabRuUYu17o7qH5a1/+a
         n9wEay9CVfqKxMMmV0TUrUQRzsU3bglD/L4NMb0Q11unWSThUzthFvsynHjNahS23t7J
         TUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=siIUGN7ikpV++GeMqVxj3L2ZvjDwDfE3KrxEg3AC/Fk=;
        b=RRQpyAPtLeAbfOSI6vv66GKeJsPiiN3KyYHUPsVRhYm4T4OEe2GB2FxkNW5Qzo4zmw
         r/tklJ9cIZTrMSNulx5vi+ttoTuQLvCcRE60SGJxXPK2mD2IDXIqWsnUCr7FyCemlK0G
         6u6kkj1x6OZMgTSkiGIMFKBKFm7o6PYGwa+lVb0l8utXFfQ/ZpfKbbolHVqgEgy/qUZF
         24kUYEruppBjF3/6h1RZtKxQ8tRp0mHXJehm8YPgDgZjzyqM5hAc3R4Citfk5Q87EvDh
         HQqTrVmUzk4C87GHdC7zo2XXBw1lT+/dApygnCRQ/sqS04il/yZ8+i4oRqKIO94SM+0l
         b00Q==
X-Gm-Message-State: AOAM531VWfLDZgShS/PuDD6u8JYBwRPWQKTymQwqSTAUBa4boIbcBhg4
        nOdmw8dJFlG5+XXkH+yC9/DaMWJ9Hj6Y8BZWnuU=
X-Google-Smtp-Source: ABdhPJwIVZXZjXHkbi00s52s8caOpz+ZOsmudMZBzhtc4Aus6An1jkWE7mhZ5ScYfbFUCWg+V7qUrlC6P7FDm0xV0BE=
X-Received: by 2002:a05:6902:1c5:: with SMTP id u5mr11505915ybh.555.1642849791331;
 Sat, 22 Jan 2022 03:09:51 -0800 (PST)
MIME-Version: 1.0
Sender: gabrieledgallome@gmail.com
Received: by 2002:a05:7000:8651:0:0:0:0 with HTTP; Sat, 22 Jan 2022 03:09:50
 -0800 (PST)
From:   Aycan Cumert <aycancumertlawfirm.infor@gmail.com>
Date:   Sat, 22 Jan 2022 11:09:50 +0000
X-Google-Sender-Auth: eH0SoGWT7ipZniM7UvfppAJGMWQ
Message-ID: <CAATdJEBqZewxLMFpKrZYx8DRZm+48oYA3cDejH=v_an0=oYawg@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am barrister=C2=A0Aycan Cumert=C2=A0from Turkey but i live in=C2=A0Lome-T=
ogo,=C2=A0=C2=A0=C2=A0a
solicitor at law.=C2=A0 I am making this proposal to you in respect of a
dead client, who was my client until his death in a motor accident
leaving the sum of=C2=A0 $ 9.3 Million in a bank here. I seek your consent
to present you as the next of kin to my late client since you are a
foreigner and you have the same surname with him so the bank will
transfer the money to you for our mutual benefit. This request came to
be as a result of my inability to locate the original relatives of my
late client.

Kindly indicate your interest if you can work with me on this project.
