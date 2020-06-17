Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606B31FD5EF
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFQUVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQUVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:21:41 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A718C06174E;
        Wed, 17 Jun 2020 13:21:41 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z9so4466520ljh.13;
        Wed, 17 Jun 2020 13:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m4tGRc/uH7vb0uqE1X2Vjwp7DYq0cz8CKb43Qz+H8xY=;
        b=ZblbmpPZKhoPW58cNBmvg67XAGW95Kdv90fcp40p0tMra8qMDj76Jw9VMDzTvcFI7a
         39csqz5AVZDB7enqfaukO+7RD5e7a/hJZencs1JbLynfBOxLk3Jcj4lGumxXVd0FimXT
         a7JPEt/Pnx7Y2HdDYTlwqLx3spa5ncJHhLiVaYEs9ebJUg0Oasc0jgTKPvK5Zfn1qVSo
         gjp3SGDoIr9rqp5CFr7YS/dy+ZfUPF5+wNJGGVDzB7/QcmQmKYVMcm4IOvoHcqGyua0s
         QTDxlXd4oY7aEtxOjawlW2vNBm8Sm1uZgvrzOMzLcTl18DdMRkzRZ1UjfNwx+zZP8RY6
         dNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m4tGRc/uH7vb0uqE1X2Vjwp7DYq0cz8CKb43Qz+H8xY=;
        b=eyCwn5eYdO57dcTrJUGaP8K/xRUGj3XMcjbKtTg0Tt5yZifcpxNIP0Ze16Orzk3Gt7
         OJ1Yz4RYHbv5yNze3/maj/acWnsy6HdAfYWf3OMdyL4+mtK+V5qaT70zmv20EVHTW/9w
         AYC4VviMF48KeTMwfRQk4dbLzhZKwPEXjnQZybbIHo7cZbU6FSq6ko66rrt3C9vgUFh7
         17jt/W/nDcYcLWUTzHUDogZAUH5radDKQ1wv4le2tmIEvX9Co4inr2J68IXy3ufaC3Cf
         evngReciL/QJmvcQN5GLhpbjlkeVgFTPUnsvavZBebfFkxR12N2WE0ijhk6FSc9++PEu
         cSXA==
X-Gm-Message-State: AOAM5301oGadA8GX0WTutR1qN1U4rVIuwE3/wXmRflPkd63U82ErpR4m
        BbbAmgkubBwiqQEzNh6WFKLnes/w3gXNDfw/s3A=
X-Google-Smtp-Source: ABdhPJxbqvRI/AFMkt3z4opEPmssMw4AaUF4fLlv2rNbmgK8MYa+jUo4uKCFwyTz7RUGvXPCiHoL9z/USXhAyEYafsM=
X-Received: by 2002:a05:651c:1193:: with SMTP id w19mr504162ljo.121.1592425299747;
 Wed, 17 Jun 2020 13:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200617183132.1970836-1-andriin@fb.com>
In-Reply-To: <20200617183132.1970836-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Jun 2020 13:21:28 -0700
Message-ID: <CAADnVQKqw18mOTR0QdTgDbBR6cJK9c9KEDkNokF7AtUEp35eAA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: bump version to 0.1.0
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 11:32 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Bump libbpf version to 0.1.0, as new development cycle starts.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
