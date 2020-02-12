Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2EE15B2BB
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgBLV36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:29:58 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34443 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbgBLV36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 16:29:58 -0500
Received: by mail-ot1-f68.google.com with SMTP id j16so3482806otl.1;
        Wed, 12 Feb 2020 13:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6EUdtzaj5HeATaXjc8VyFybXqFaOOVdixXXnNM4Bwu8=;
        b=Gm7kWnYIxvK5ldgUz4g0nVBMQc639uswc6TWHlep6sMqtQ+qujlnjp283SbnnrOPbU
         b7avqm/swkSzEN9Ep5ayPFEhjB1lKr0rbO+LZ0bGR1mC47DVV3RJ5mtUiJct8Dy/lwHr
         3JV/DMBqqGEnml0UNFYuKej4E1ULCpr/3MFyEk3OGTwVn6LNgAhJV2yCIcJGcuISfvw1
         fLV80ZpcvfknDPnc+7UPtii/Iu54o/RXKZra9rrrR57tnQlg77PXMFzjqGbWejck6OXe
         u9EIa1vIAEzSevFbx3pN/zGWFslWR5FY9NjIQPKkaGkV+8CiA2T9I36/yz5PQiuNDw6e
         +gOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6EUdtzaj5HeATaXjc8VyFybXqFaOOVdixXXnNM4Bwu8=;
        b=pTgDhW6FFiakFY0gMc3lfbZK9af6qiKp3OHj7WqtO/e2Xz7D5eeNoh97OQLpxQCUOj
         92TVKZm+sPoqbOMI78isW9JR2yz9uEXs/1EKkBTURkru4gXZAsZfn/4Ucg6Ge0yei3A1
         ublo8NilbTmFgQVPxlrIeHhzyLpdX6cGI74dsCQl6d3r8AAVPRmm/HSUSCSUmKd6WC49
         GzBJQv1efVBoHlFGGNzNx4JTtxYETpftCq+1GdeiigDfVyj2vvuho9JLQa9CPZp+RhQ4
         JD8uJG8y+BDrWpKDKSAfuuUy/eCoM23LwBpOD0EHdecArPAnHjAj4JU9TDJwyQ/O5GqI
         7Wgw==
X-Gm-Message-State: APjAAAVg5AnWGe/hy8gZCuZNOoKT4mRkY3FpkLZMTdOgQQrqWdQX/L0G
        JdpvikmyFj+/B8bDEtVdYLdDRnh/9O2L7JU3QgE=
X-Google-Smtp-Source: APXvYqy5luJF34R6oX+y3IwKbEVG0rnSH6Vpc0tpBKh0KsYzhDGd+I9stl5ZEIoqRDlVt8ljiqqVs8QSXHmCsYp2cVU=
X-Received: by 2002:a9d:6d10:: with SMTP id o16mr11255994otp.28.1581542997421;
 Wed, 12 Feb 2020 13:29:57 -0800 (PST)
MIME-Version: 1.0
References: <20200212212316.Bluez.v3.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
 <89D0B633-381D-4700-AB33-5F803BCB6E94@holtmann.org> <86D0ACD5-BEF7-45B3-B621-BA2E457AB57B@gmail.com>
In-Reply-To: <86D0ACD5-BEF7-45B3-B621-BA2E457AB57B@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 12 Feb 2020 13:29:45 -0800
Message-ID: <CABBYNZLm_q_WV3nmGVpePXpLsjnkk_zpEm1cYK0ps7H3PM=_kQ@mail.gmail.com>
Subject: Re: [Bluez PATCH v3] bluetooth: secure bluetooth stack from bluedump attack
To:     Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Howard Chung <howardchung@google.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

On Wed, Feb 12, 2020 at 7:39 AM Johan Hedberg <johan.hedberg@gmail.com> wrote:
>
> Hi Marcel,
>
> On 12. Feb 2020, at 17.19, Marcel Holtmann <marcel@holtmann.org> wrote:
> >> +            key = hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
> >> +                               hcon->role);
> >> +
> >> +            /* If there already exists link key in local host, leave the
> >> +             * decision to user space since the remote device could be
> >> +             * legitimate or malicious.
> >> +             */
> >> +            if (smp->method == JUST_WORKS && key) {
> >> +                    err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
> >> +                                                    hcon->type,
> >> +                                                    hcon->dst_type, passkey,
> >> +                                                    1);
> >> +                    if (err)
> >> +                            return SMP_UNSPECIFIED;
> >> +                    set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
> >> +            }
> >>      }
> >
> > while this looks good, I like to optimize this to only look up the LTK when needed.

I wonder why we don't just call user confirm everytime? That way the
new policy preference applies to both a new pair or when already
paired, and we don't have to really do the key lookup here since the
userspace can do the check if really needed.

> >
> >       /* comment here */
> >       if (smp->method != JUST_WORKS)
> >               goto mackey_and_ltk;
> >
> >
> >       /* and command here */
> >       if (hci_find_ltk()) {
> >               mgmt_user_confirm_request()
> >               ..
> >       }
> >
> > And my preference that we also get an Ack from Johan or Luiz that double checked that this is fine.
>
> Acked-by: Johan Hedberg <johan.hedberg@intel.com>
>
> Johan



-- 
Luiz Augusto von Dentz
