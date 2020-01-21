Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D021440CF
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgAUPpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:45:03 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37013 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729052AbgAUPpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 10:45:03 -0500
Received: by mail-ed1-f65.google.com with SMTP id cy15so3440157edb.4
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 07:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lYhfEaxk2tZFdTu2sazgJjF9OdRimIzQi/dtbV+yVa8=;
        b=pQv5/T2IwmoMzQwZXoF2ehPZA0sjJ9GaPhBmfoG8RnP1Mno/L7mQazCYtimkMdLgAe
         U3d5i6K76pKczm4zJyJLCDv9GQE0EJTUgqFohv9mgO2to7lR15b8XgrI4Tu7NJxnSM83
         qCjVPx0rJPHxFd7kO9lalGxSiZSi4TyJAFQtu4I6l6tKlURApokDOEyxCTCvl3CKvaSc
         InzHCxfYkF7tru3T4mOySa9ixJJXuYS6yJZ7wOjoUT1hzeflOmAwoXI+wRFkIi7N6QHx
         +7UxwsdwXQhNoO8RW8Kfn5Kb8ahtceb9LpgsbzZ4zHQsCQntghO2yp3T1/0KH4OF5ZNa
         OdMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lYhfEaxk2tZFdTu2sazgJjF9OdRimIzQi/dtbV+yVa8=;
        b=cnj+Rhh3sIUMHkXKc5g9XTAoCNLIBI84lNbhwOo2uic83sRBq03kDopVBRfQBab6Rg
         cnjbugVTjzNlOOVQw2Ek+gnGI0GvTrqH8eWUOlTVaoXQ6/AbQayxiInMlO+K3Pr7Y6ph
         CR+SIjX6FzjR5MaDhx+2MO42cRnfA0CZLnT6dEBHXtZ8VnT3lNKB9vqTjtv5L7r/LL3r
         42zMdmw2CSLK+AQRv5SeTENyx0dIHFOSfuSKWMBl5n55AjEIoQ2tklZSNuyZFlO89xnH
         QljVX2JNGeca7E5dJ0poKpDiSqkFBGeQeLJyrE4ROHbU7S2aj5+c4K8KfymWEpcbb/P1
         /EBQ==
X-Gm-Message-State: APjAAAU7azEa25ehMFplaVhQB6acE/gwO1gzOuMhR6bBOqgRRAIQBtTB
        nZzInzZFSsYnd9AnkoDAoZzCyldN+gQTEp9ENuM=
X-Google-Smtp-Source: APXvYqzbYHF5zRW9jGP8bPxw6qvLL5pZMjegsWWCNwfF1hzxxiwtMzj7jGGjuyuabcAom/KasUeogTTwaHgO7sFoPGU=
X-Received: by 2002:a17:906:4e01:: with SMTP id z1mr5117105eju.46.1579621501483;
 Tue, 21 Jan 2020 07:45:01 -0800 (PST)
MIME-Version: 1.0
References: <20200121141250.26989-1-gautamramk@gmail.com> <20200121141250.26989-6-gautamramk@gmail.com>
 <20200121.153522.1248409324581446114.davem@davemloft.net>
In-Reply-To: <20200121.153522.1248409324581446114.davem@davemloft.net>
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
Date:   Tue, 21 Jan 2020 21:14:50 +0530
Message-ID: <CADAms0zvGp4ffqmvZV6RVOTfrosjt6Ht6EkyQ594yJYQFTJBXA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 05/10] pie: rearrange structure members and
 their initializations
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 8:05 PM David Miller <davem@davemloft.net> wrote:
>
> From: gautamramk@gmail.com
> Date: Tue, 21 Jan 2020 19:42:44 +0530
>
> > From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> >
> > Rearrange the members of the structures such that they appear in
> > order of their types. Also, change the order of their
> > initializations to match the order in which they appear in the
> > structures. This improves the code's readability and consistency.
> >
> > Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> > Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> > Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
>
> What matters for structure member ordering is dense packing and
> grouping commonly-used-together elements for performance.
>
We shall reorder the variables as per their appearance in the
structure and re-submit. Could you elaborate a bit on dense packing?
> "order of their types" are none of those things.
