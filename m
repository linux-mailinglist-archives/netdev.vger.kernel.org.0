Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D12F531A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbhAMTKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbhAMTKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 14:10:04 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC7C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:09:24 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id z9so1887503qtn.4
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 11:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ShW6W2GfCPol/vtjmzz7VZ0R75AiI9JhfsfmedgtiWE=;
        b=RUfk7azP6WLVQCDqU4kaR3NPFC4wiTNwfR3eqLcH2ir4vUtwMlnecn/axvDpHQS/hY
         fX5aVkseZBI8zk3Glf0wm8CNIGKN84wkpqoK7Mv4xEyyPEzLOdu0jvNrD++ls+REVYI0
         HhFIG/3YBIT717fiUTPS67VpwJqJWRm0WhrSchNICnyo/lAN7lCDcDOTOUSm+8jMCmJ/
         Dv101cKTE9faccrrPSKAzPkDXn6oXmLIrdZCENrTPfewWT0nIcaUiu1t8Bo0JyuP+UF6
         0/77wcm2eiZ0rooDh73nlMb+043ufvq1v3z+HgAXnAHsUXkNfP4mr6DINKjFyrjUJfoO
         JMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ShW6W2GfCPol/vtjmzz7VZ0R75AiI9JhfsfmedgtiWE=;
        b=lUt0OuHEOmO4lwqJyhwQwgAhG0DKFTa/IkoZL+0BYjf7GLjCkyYv+N8ubaham8ojTE
         wTChLztof+/hN2RDvt1kvjjgf088BDey8+OdzTVxPXpvgSBile8F1fZVZJpz12DN7IDs
         LsOak6819jV4bBI1cmduoOHSZm8cswOyliTajCcrSdq/RxHkbRLjK3XT/teMbHPX9d0M
         WHqFv/E6qHZoSbhs1pMpju6fR1gnJ4FvsoPvPufcQWHvc5QQSyMUWFIi7gbISMiQFF4q
         VD4sDeJkq50DvHIpIHdbpCYmB7tt0GJGU4+jQSu2BlWdFvo4vzQCML/9Z8+o1YfAO6/v
         TH3g==
X-Gm-Message-State: AOAM531QEZMrE3sg9nwHBKfJ/wgzLDOUDQbyp+cGTSZ70lhB6FkCH7Ro
        99/RNuLf6U4u4AhaiZCNIBeTQ6xkTpdnPNpdRyXkGUlB+wQ=
X-Google-Smtp-Source: ABdhPJyjJQr5ynIDR0BDsIxsLYilnz0Ev9UwFzzCAL8BFqz+NTn0b+FHMxob0smNfsGHaCnyr6V+peFhcrXJHqC4fTc=
X-Received: by 2002:ac8:41cf:: with SMTP id o15mr3732276qtm.98.1610564963465;
 Wed, 13 Jan 2021 11:09:23 -0800 (PST)
MIME-Version: 1.0
References: <20210112223847.1915615-1-sdf@google.com> <20210112223847.1915615-3-sdf@google.com>
 <20210113190158.ordxwkywagrrmqpt@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210113190158.ordxwkywagrrmqpt@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 13 Jan 2021 11:09:12 -0800
Message-ID: <CAKH8qBuxroVphddnqshoB1wzq3yqDA5EjYBCHrESCEW6LOxpXg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 2/4] tools, bpf: add tcp.h to tools/uapi
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 11:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Jan 12, 2021 at 02:38:45PM -0800, Stanislav Fomichev wrote:
> > Next test is using struct tcp_zerocopy_receive which was added in v4.18.
> Instead of "Next", it is the test in the previous patch.
>
> Instead of having patch 2 fixing patch 1,
> the changes in testing/selftests/bpf/* in patch 1 make more sense
> to merge it with this patch.  With this change, for patch 1 and 2:
Ah, I messed up the ordering. Sure, let's just merge them together, will resend.
Thank you!

> Acked-by: Martin KaFai Lau
