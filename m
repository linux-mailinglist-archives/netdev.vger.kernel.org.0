Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606F2477DC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 04:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfFQCFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 22:05:03 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42137 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfFQCFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 22:05:02 -0400
Received: by mail-ot1-f67.google.com with SMTP id l15so7794349otn.9
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 19:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XqUFyep+hiSAcObvobEMcXPdQqZ5npRixdR8z0YIoD4=;
        b=E3xAriDrV4rBxZV2yXcRMibA3J1Uuj8aN4DpSuz+SkRf7YQx22Cxzvi3KZA+WqTlwZ
         ZFL/R4kz0uhJqJZtamS7YdJFFBF6W/yTNxQ9Q4GOD8Iy2CDhR5fuG1jnm/IkptzT8/sQ
         CJOysgIAcCbBt7u9RtD6uUNn/+YfyyYSENc7EaUI/r8yLxzKaFbvO82imZaW+dJOFe1B
         v9lB7hShDWQlBvRY9BqcDh26L5dIuTovMJDnAQPHV1ykHk/lJkDMNdyltHmIYyrxaZOx
         2yNJ+fJzMdp4LMU4CLe2Nehp4SJXTFTq3NbyMaTSAwZ0eBmOO25ZkFKSJfH71VZmCQYO
         Xixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XqUFyep+hiSAcObvobEMcXPdQqZ5npRixdR8z0YIoD4=;
        b=NUVyyi2Hz+mWVxnkUSNJvAIHhnyE3hKdX8icMM6UhsPBDTDePUC2PCo6UiW+swBZO7
         w0W6vpJErLUFtOuayFM/KAy8JKr9WQByfhLMCcJgj93F1foOaM27HF6JF2a6Hq3tTsAU
         8fyMDvVPF44CVlEFxSijDul3c6hAKPy3BGjXtxh/GZeJpxxR/JcDOAZRsTWjiAKNuopx
         F0Rn8FUIH+pgtH3VXmGsRKYygisXqPAiFHInSDwyCf7yykp/ZpafGNNb+H0LA74MynOD
         V91MBIF5uCF15ihqysCi5bd9k5vkxpMKQH2l0D+a/H+jONJY2EEAHdjFHsPwi51MzKKq
         t8wQ==
X-Gm-Message-State: APjAAAW5kTXXwuIKDkMjYn6Lgmj5O+UCP/e3K0vt2Kj4fMdi/s0CI7CD
        FjYMzkVJ3mimL7nehGiOOAEoCCFk8fZBe10VElr+Sw==
X-Google-Smtp-Source: APXvYqyQMIATq0/q+OSoS2qRVAXxuE0IPyaf8s121Rv9D7fsjR8ryyodDgqpbKhPbqmAFYonw6lAOP0rJWGy/cEn1Dg=
X-Received: by 2002:a9d:6481:: with SMTP id g1mr11507777otl.138.1560737102037;
 Sun, 16 Jun 2019 19:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com> <30354b87-e692-f1f0-fed7-22c587f9029f@6wind.com>
In-Reply-To: <30354b87-e692-f1f0-fed7-22c587f9029f@6wind.com>
From:   Lucas Bates <lucasb@mojatatu.com>
Date:   Sun, 16 Jun 2019 22:04:50 -0400
Message-ID: <CAMDBHYJdeh_AO-FEunTuTNVFAEtixuniq1b6vRqa_oS_Ru5wjg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Restore original behaviour
 for namespaces in tdc
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, kernel@mojatatu.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 5:37 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 05/06/2019 =C3=A0 23:08, Lucas Bates a =C3=A9crit :
> > Apologies for the delay in getting this out. I've been busy
> > with other things and this change was a little trickier than
> > I expected.
> >
> > This patch restores the original behaviour for tdc prior to the
> > introduction of the plugin system, where the network namespace
> > functionality was split from the main script.
> >
> > It introduces the concept of required plugins for testcases,
> > and will automatically load any plugin that isn't already
> > enabled when said plugin is required by even one testcase.
> >
> > Additionally, the -n option for the nsPlugin is deprecated
> > so the default action is to make use of the namespaces.
> > Instead, we introduce -N to not use them, but still create
> > the veth pair.
> >
> > Comments welcome!
> Thanks for the follow up. I successfully tested your patch, it fixes the =
netns case.
Good, thank you for checking it out.  I have to add a few more changes
to the patch for the BPF-related tests, but once that's done I'll
submit the finished version.

> Note that there is still a bunch of test that fails or are skipped after =
your
> patch, for example:
> ok 431 e41d - Add 1M flower filters with 10 parallel tc instances # skipp=
ed -
> Not executed because DEV2 is not defined

> The message is not really explicit, you have to dig into the code to unde=
rstand
> that '-d <dev>' is needed.
> Is it not possible to use a dummy interface by default?

The tests that make use of DEV2 are intended to be run with a physical
NIC.  This feature was originally submitted by Chris Mi from Mellanox
back in 2017 (commit 31c2611b) to reproduce a kernel panic, with d052
being the first test case submitted.

Originally they were silently skipped, but once I added TdcResults.py
this changed so they would be tracked and reported as skipped.

> From my point of view, if all tests are not successful by default, it sca=
res
> users and prevent them to use those tests suite to validate their patches=
.

For me, explicitly telling the user that a test was skipped, and /why/
it was skipped, is far better than excluding the test from the
results: I don't want to waste someone's time with troubleshooting the
script if they're expecting to see results for those tests when
running tdc and nothing appears, or worse yet, stop using it because
they think it doesn't work properly.

I do believe the skip message should be improved so it better
indicates why those tests are being skipped.  And the '-d' feature
should be documented.  How do these changes sound?

Thanks,

Lucas
