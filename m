Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67021179C14
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388484AbgCDW6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:58:07 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41511 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387931AbgCDW6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:58:07 -0500
Received: by mail-lf1-f67.google.com with SMTP id y17so2910597lfe.8
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 14:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1WuBGhpwOOTY60Brcp+ApzkR+gO0sOpMx89fTUxTwo=;
        b=DU5MsYoayOBpffAIs4XljIQdjIONhrTykC+D5i+CK8j8HlOkidRpWtwfZ4w19qEfed
         idf6KeBYc1SCbzeigYoReBK8V3tplblEEYDpCpfoEE76RopeIQObAGgQBybYtg5Pv2Am
         o1JqJIDTUq/jtEKdq1fScsNsyRN34GAt1f7mlvEJ33hYpTsgsDabRyo6sIbPG+n/Czsn
         1mFRC7kATxEKbfKEVEqLl0eOXp0Wq7/siZU+74+7tizHTH878TEkpxaGlgvdwbshAbwg
         OAKC0x0UKOHwfz87USPCmWWP3at0K4+oJd9lJlbikJEUq0Al9G8kkWylkK7LeMBb948m
         +TdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1WuBGhpwOOTY60Brcp+ApzkR+gO0sOpMx89fTUxTwo=;
        b=ugbGx3hOK5i5LoE7M0VeMX0OQLJxgII/KranfJEVQZ41IZQ52PHUAmubdbgcGyow7/
         ki4RPAzhj40pogrpjYI9uPO6o/5FG0p3jmYFllFjXT4k1GqvvX49KYtexaeJzo8Co+ZK
         NA681+r9DCI5Ul5EgcDHV7G4/exwLejiI/TPwgpG3m9eyglK39Hn8CTLoHs2lb0/aYZl
         J/y+5606HtYHPUleJtGJxOlmjv2Pvz1htUyqqNPTFeX92YGYJ7oOhDj19wuxXdbr40C0
         m5hY0cLTYMfUnNHjuo9Hb0Nqu0uy6/d53R7ASJQ35Stab5EwfA9CNM+JDPi+JK65hUHI
         Aiaw==
X-Gm-Message-State: ANhLgQ30A+OyveKPJm5xJ4paPSVhclqsd/QvvjxtCns9K/do+3zAKWQm
        YT46WEjDkBu7gI6aHEKW5ASmYp3s1sA1cVRlvTQ=
X-Google-Smtp-Source: ADFU+vsGieHJ/geDTs1qMNlA3X3TtBmgX7AaYAajaYE/YzTUnEa5uDFcFKq20xp6j5Tre4dW9xJecigurjftFjDx9KI=
X-Received: by 2002:a19:c20b:: with SMTP id l11mr3295861lfc.135.1583362685626;
 Wed, 04 Mar 2020 14:58:05 -0800 (PST)
MIME-Version: 1.0
References: <20200304075102.23430-1-ap420073@gmail.com> <fe5c0e55af0e80ae11e93ef6be0fb3bf@codeaurora.org>
In-Reply-To: <fe5c0e55af0e80ae11e93ef6be0fb3bf@codeaurora.org>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 5 Mar 2020 07:57:54 +0900
Message-ID: <CAMArcTXw+juJj+u58qF9ALV3HqWLGPnb-VPxietr2DduyQ4hkw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: rmnet: print error message when command fails
To:     subashab@codeaurora.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stranche@codeaurora.org,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020 at 05:47, <subashab@codeaurora.org> wrote:
>

Hi Subash,
Thank you for your review

> > +     if (rmnet_is_real_dev_registered(slave_dev)) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "dev is already attached another rmnet dev");
> >
> Hi Taehee
>
> Can you make this change as well-
> "slave cannot be another rmnet dev"

Okay, I will change this message too.

Thank you!
Taehee Yoo
