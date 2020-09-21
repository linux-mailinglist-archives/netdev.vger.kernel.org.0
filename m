Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79222730B6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgIURNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgIURNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:13:37 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC3CC061755;
        Mon, 21 Sep 2020 10:13:37 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id r4so3439809ooq.7;
        Mon, 21 Sep 2020 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=waRqiEfNwADZ1q0cmQitfG4RqgPbX6G81DVZ4varhT0=;
        b=vM7jnxC86Ny/7N3SW7lZdKuOZ0XTttvm7sv9dQGlR8pSLu62Vns1DdDkyskygMe9pA
         pQR76F0ryFNX80RH4jDexp7P7iO6ho+kFd8D3SDhpgdpSY8qhfA1YkNKSBAi5Fj8dbG4
         on+zFk8cKIC5CGjjsO/vrf4eIwQWNwvsKyKNekUnf+pEJhXjKQG3lhJeEQIUrAH/uQEJ
         +nfqgQKRnkeYzSM5FbT82h/RS+QpcSrD4NAnfLsgYrbeZ6ZI/kusNjfz7itHHVHL6sL6
         qQ31xRstr2DIeSGy3KYjwo8Fii1RC91vsitDmTJdF+F0ZhDgo9q9/XURInkk+VVJOozL
         qiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=waRqiEfNwADZ1q0cmQitfG4RqgPbX6G81DVZ4varhT0=;
        b=pK33SsMPM/Z6srYOBOAXMcnBchZnyhtl6WCL5vYRzAmtF4aYS8vtWE8ZenpSqr+Kh5
         Au96Iwx+n/E2Mw8nWgG7B7XhSOpctvn1LEspRQkFygoOok8lpCShCF6zqi4PewMIEk8a
         oP3iFblKo+DxYKV3i+Te01jJeeaBkqM9TrdHLodYG8HENl6J5/x1Ur4+RApdSryjBRLd
         kpo9uB8AXQXXS/3+J9OBOdyTfxPAAnBBIdHPdyr9Cc5XaQoa0cflmrsKh/wZsrjdX1bt
         /2SAqHBwJLv0zPEHorR5CG6AKjGmhYZg69NDLFicmpVQ6jyo3LjPeklak2+g1JRZXaYw
         7DmA==
X-Gm-Message-State: AOAM5306Tb7PLCDFia7qx6/AjaZbcWN21aeY4ip0u6c4org6v9fK66rR
        1rwupxqYL/RbyCJVylj8G/++pv3HsM+L1jmPP8U=
X-Google-Smtp-Source: ABdhPJxDFrUXooxQY3Awa9RYKnX7uqza0e4QwpmnOBBuqu7J5l3yYSbquJwybOPrnpU6sEFukuM5+wYsmhhy3dgESSs=
X-Received: by 2002:a4a:5896:: with SMTP id f144mr250480oob.49.1600708416655;
 Mon, 21 Sep 2020 10:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200921163021.v1.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
In-Reply-To: <20200921163021.v1.1.Id3160295d33d44a59fa3f2a444d74f40d132ea5c@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 21 Sep 2020 10:13:24 -0700
Message-ID: <CABBYNZJGfDoV+E-f6T=ZQ2RT0doXDdOB7tgVrt=4fpvKcpmH4w@mail.gmail.com>
Subject: Re: [PATCH v1] Bluetooth: Enforce key size of 16 bytes on FIPS level
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

On Mon, Sep 21, 2020 at 1:31 AM Archie Pusaka <apusaka@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> According to the spec Ver 5.2, Vol 3, Part C, Sec 5.2.2.8:
> Device in security mode 4 level 4 shall enforce:
> 128-bit equivalent strength for link and encryption keys required
> using FIPS approved algorithms (E0 not allowed, SAFER+ not allowed,
> and P-192 not allowed; encryption key not shortened)
>
> This patch rejects connection with key size below 16 for FIPS level
> services.
>
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
>
> ---
>
>  net/bluetooth/l2cap_core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index ade83e224567..306616ec26e6 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -1515,8 +1515,13 @@ static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
>          * that have no key size requirements. Ensure that the link is
>          * actually encrypted before enforcing a key size.
>          */
> +       int min_key_size = hcon->hdev->min_enc_key_size;
> +
> +       if (hcon->sec_level == BT_SECURITY_FIPS)
> +               min_key_size = 16;
> +
>         return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
> -               hcon->enc_key_size >= hcon->hdev->min_enc_key_size);
> +               hcon->enc_key_size >= min_key_size);

While this looks fine to me, it looks like this should be placed
elsewhere since it takes an hci_conn and it is not L2CAP specific.

>  }
>
>  static void l2cap_do_start(struct l2cap_chan *chan)
> --
> 2.28.0.681.g6f77f65b4e-goog
>


-- 
Luiz Augusto von Dentz
