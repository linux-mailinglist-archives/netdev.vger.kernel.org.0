Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CA825EBB8
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 01:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgIEXVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 19:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEXVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 19:21:03 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291F8C061244;
        Sat,  5 Sep 2020 16:21:01 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id o20so6605618pfp.11;
        Sat, 05 Sep 2020 16:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=tnCfnRSEoMfla+BvXarAml1JKTbQoVOApWWOx7a3MNE=;
        b=YFCpq3Nz0VAENIWN5V+kiy3eP4lh2zc/RayHE8lz26zO/OUNgbtF8dACmKv2ukSlPK
         8YzsEZbiffYqJyd8TGpLU8Q8gKwsI9HNbXoa+Ph+uZzGo1Yrc/dDPYT+6Ntl0bV9GTlu
         MmqX1Gz73sZyECyC91NGnUp/io8sVNGeDC/o56zb/7DGzhf7W//m3GnbGYorjIAV9Va7
         CU/YxY3Hn2AdiBCumloVA2Kdmx4n/Z9g6gTjjF3QYwx0k96Ul6BbO9gFs8kxdnIQjZyc
         WFoNoV8Orj7+lUDQlZy6zYA0P+Bf/FdRvAhftYvSiqF0pylP2eV2RoxJUDdsnvXxBdDL
         Kpug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=tnCfnRSEoMfla+BvXarAml1JKTbQoVOApWWOx7a3MNE=;
        b=B3ZHV369LkSzWP3AACGa4POBqBzH7J3oIKeLb9Pyu2c6faZSXpBy2wXTwsR2lEpgF6
         3mnRhFLxujb9nOzxqffNOCQ5i84lRvigIR8TH23/Tboizljhj9rsFjj+/0GHiBcSZLxJ
         vOxshDG9hKYU6fxWgRY5B68jqdZ7ySOrseKU9Fq89N8YVFxPNva+uXYtaR/BtiF6qZmg
         Lym6xtzLAjKHncgPzqMcERNi3EJn1nYd0VMiGuH+kcd0In9uXJ8S1WiGTr09HTIb/POI
         dKEgH6YbEgcdmc9XUb7XfTESjx2NJRdrYA0NO6YZ4aUfmFrkBgqhXk3FftV9C8abzOY9
         n4AQ==
X-Gm-Message-State: AOAM530H0gSmbSBPaSPmpDY6D+LmBWc5ao7PnGVwDab3+D51OasVPvt8
        8CdAYZ7osI4hPCmAWgpm990IzisEVKfGWWt3JDuFpESb
X-Google-Smtp-Source: ABdhPJwn7W9k6LW/0SJfWMPYZvTTYUAVQ3q31cemERFSdofJQmAwwSN77UNhbUVywK7uQBPXik0g3sx3RMEEN8KBc8Y=
X-Received: by 2002:a63:b24b:: with SMTP id t11mr11996580pgo.233.1599348060536;
 Sat, 05 Sep 2020 16:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
In-Reply-To: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 5 Sep 2020 16:20:49 -0700
Message-ID: <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
Subject: Re: Question about dev_validate_header used in af_packet.c
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 5, 2020 at 3:24 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> Hi Willem,
>
> I have a question about the function dev_validate_header used in
> af_packet.c. Can you help me? Thanks!
>
> I see when the length of the data is smaller than hard_header_len, and
> when the user is "capable" enough, the function will accept it and pad
> it with 0s, without validating the header with header_ops->validate.
>
> But I think if the driver is able to accept variable-length LL
> headers, shouldn't we just pass the data to header_ops->validate and
> let it check the header's validity, and then just pass the validated
> data to the driver for transmission?
>
> Why when the user is "capable" enough, can it bypass the
> header_ops->validate check? And why do we need to pad the data with
> 0s? Won't this make the driver confused about the real length of the
> data?

Oh. I just realized that the padding of zeros won't actually make the
data longer. The padded zeros are not part of the data so the length
of the data is kept unchanged. The padding is probably because some
weird drivers are expecting this. (What drivers are them? Can we fix
them?)

I can also understand now the ability of a "capable" user to bypass
the header_ops->validate check. It is probably for testing purposes.
(Does this mean the root user will always bypass this check?)

Thanks!
