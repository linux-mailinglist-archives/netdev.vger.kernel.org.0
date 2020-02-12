Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A11B15B420
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgBLWxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:53:10 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:46734 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbgBLWxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:53:10 -0500
Received: by mail-lf1-f47.google.com with SMTP id z26so2758587lfg.13;
        Wed, 12 Feb 2020 14:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=pZv/zjUur31XzivU2IEbW57BOgWqzqi1qJAzXpI6Ps8=;
        b=tBG2qL8B0AOsXofRSuBRcWV2pmnNVL4ymmNzVR4IM6l6B0C2ywF37Y9nQU+x+zQOAM
         nQdDyn7xQC4NjteSeubLR9IaBHaNB/S71sEmnUfLDwDNMvHA3Lmnh1x9vB5fgKwUpKip
         0641tsH7ElApOee5wFLgBZbl8caja7y+CD/5aJBD32F6+A3HKqmLKr7+ZaREXiVVoIU0
         rTIfaWdkj/2GWA8PMwtBpWCIUpUcDDk/M+S3u51JLO33irpT0HfLh8M3Nr/CeOwBZj3i
         NRE6nhLab8u49AhKfTgXpg/AkpIO2WHVqulidpv0HWmRPsI/uzsHnNypa3x6AB3SARuL
         G4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=pZv/zjUur31XzivU2IEbW57BOgWqzqi1qJAzXpI6Ps8=;
        b=r8016zxgS+tb09+hRpH4hZiVH4TtR7FCbELxd1VrbwbkoMI86irnagHBBIN4TQk84Y
         bXennrNxurq6FPQ0t55wdD+aFG064PW0k4UIfhYc7pCvBe5KDqircRKFaRR3nbjQqEkU
         d8Wek1dvaQRwz54nf25ApPG7+KC5EnEqYFQGHyEEXYX60Rw9fvbTG3u4UQmWrQ6EbVZc
         e6TH/wJYbgHybCKGHr1irk5g19bMPBe2Ks1FEUcrPhyw2nPqadysey5BgAF66g7oCfxa
         1kub1BlYo4RaQRklcamqzmKinmD96R6wlh/I3u2h5HCYFpdwlRzOBtqTR0fO+LOvJbkc
         q9Lg==
X-Gm-Message-State: APjAAAX+7eetuTAXdLRSOqX0ezH7fzkaIiXbNLRwECPi6BXqES+O4NLH
        oY/d0vHRmh+yHFeXzLLir+8hl5FCj0EepTInIJ7vCw==
X-Google-Smtp-Source: APXvYqydjgsRQAatuOVRyyCB6m8WbSj2UVMhm/z9smurc4IvcMR4QcVvTikN4CnvZdgzoUvZS8B10kZQVKqkf+BCQcU=
X-Received: by 2002:ac2:5626:: with SMTP id b6mr7780220lff.134.1581547986116;
 Wed, 12 Feb 2020 14:53:06 -0800 (PST)
MIME-Version: 1.0
References: <CAADnVQL7SiR-4HZnia+NiDFPW_JjhwaxrvgfPZBKQ91oVjcTwg@mail.gmail.com>
In-Reply-To: <CAADnVQL7SiR-4HZnia+NiDFPW_JjhwaxrvgfPZBKQ91oVjcTwg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Feb 2020 14:52:54 -0800
Message-ID: <CAADnVQ+H9tVZ+9nvtRb=MmAyw+h7Qd6coJHqSsm384WEJYY7_Q@mail.gmail.com>
Subject: Re: LSF/MM/BPF 2020 reminder
To:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 7, 2020 at 10:43 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Hi All,
>
> A reminder that deadline to request attendance and
> submit topic proposal for this year event in Palm Springs, CA
> is Feb 15th.
>
> Please fill in the attendee request form:
> https://forms.gle/voWi1j9kDs13Lyqf9
>
> The proposals should be sent to both
> bpf@vger.kernel.org
> lsf-pc@lists.linux-foundation.org
>
> Please tag your email subject with [LSF/MM/BPF TOPIC] as described in:
> https://lore.kernel.org/linux-fsdevel/20191122172502.vffyfxlqejthjib6@macbook-pro-91.dhcp.thefacebook.com/
>
> Thanks!

Final reminder. See above.
