Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295571028B1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfKSPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:54:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43816 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbfKSPyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:54:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id n1so24429504wra.10
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 07:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnAjyRVmxaixlQhN/7tEePVfKoL91QX9po/uRrZkdsY=;
        b=ntPbyIyDgfB/nr14wGgpoMjjlZxDOeVN7Oz+0ptTNLPySKfoVuIAggjA9abt/ExHCN
         2oFg2kJe2PcxHpAWsO8/GY1dJmGNa7lr0mvOl+9La0h7Ipn4KlcpxLydch30ynLmT5Ku
         FYt/gpg1fRgaOCAVT5/Wx6gpkodyxPpptLwtk4OFs/KDdrhpnfL7zUJ/MGr0YNgiP6aY
         q5bp+/L7x+gHPVYNYphoCIHhlAvo4i9VURE3j3XCuMgUEVMWiKke1fwt2R7DEPrjpBjs
         yaMJ8jgM+sIQWsiugbe1lkyAk/4WLzeqQQtGiwXnqiV+xOEmxD9LLlycU3MpNG91Sdf/
         exhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnAjyRVmxaixlQhN/7tEePVfKoL91QX9po/uRrZkdsY=;
        b=gpyd/zWoBYq01JiCntqI6vZQycHMYHT8aJ4Pl8eRrAoDuGGXmweUnJ+TTmvtjf/Sam
         H4sGj3mq2IKeYZ1Vx+F+FcJMQ0j6uy4WvCADq/4aQ1VRA6/F9SXjvOw51zZjS3FEMGDC
         GKh4cTbb5df4iE32KutBzuoMDwCVFuPqWBQzmUmtp120Vtl98MnvHl3urYoEjsvlmnsU
         yUXM8Wg1MGhDSPnj9HFJLCBessDCosgwbnV0JMf6dp1F9q4qRijTX/BljD+Sug2kBSpH
         8UVj4ZaX1+C8IQYhl+m2ER/iDf3PEtJnw4AgD+IK7qgWP/WLChBV+q4wWXV0junue/lM
         rVHg==
X-Gm-Message-State: APjAAAVMwOBSzdFSIuO+mitYaVY6qYd0drBxTqcNDZ6H9dqvinJ0hcOD
        yuBaCoJoIONxWfrsX3CON1f6O/SXfYF5V+gGjSyq2z2u
X-Google-Smtp-Source: APXvYqzINxL9uK7TCgJD/apKiYQ+10t6GHixG/nqkbfa92HetHqpRxxFbAtlA1PRQZ1+ATgeiZvn4bpqFEWDtdRoyXU=
X-Received: by 2002:a05:6000:18c:: with SMTP id p12mr10162225wrx.154.1574178869033;
 Tue, 19 Nov 2019 07:54:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574155869.git.lucien.xin@gmail.com> <CAHvchGmygFXEiw6k7FTzN16YBJu6WtCm_tE7zQAbUaHE5N+KQw@mail.gmail.com>
In-Reply-To: <CAHvchGmygFXEiw6k7FTzN16YBJu6WtCm_tE7zQAbUaHE5N+KQw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 19 Nov 2019 23:55:23 +0800
Message-ID: <CADvbK_ciTYDuF+CEEPoTTJnqq1rng_3XPT4VaivfQ3SC1V=xRg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: sched: support vxlan and erspan options
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 10:18 PM Roman Mashak <mrv@mojatatu.com> wrote:
>
> On Tue, Nov 19, 2019 at 4:32 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > This patchset is to add vxlan and erspan options support in
> > cls_flower and act_tunnel_key. The form is pretty much like
> > geneve_opts in:
> >
> >   https://patchwork.ozlabs.org/patch/935272/
> >   https://patchwork.ozlabs.org/patch/954564/
> >
> > but only one option is allowed for vxlan and erspan.
>
> [...]
>
> Are you considering to add tdc tests for the new features in separate patch?
You mean in selftests?
I will post iproute2 side patch to support these first, then
considering to add selftests.
(this patch series is the kernel side only)
