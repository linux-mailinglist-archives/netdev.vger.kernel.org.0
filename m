Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28811C0457
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgD3SD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbgD3SD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:03:59 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B86C035494;
        Thu, 30 Apr 2020 11:03:57 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id j3so284591ljg.8;
        Thu, 30 Apr 2020 11:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Zd1sw2u+5dkzdiuiuJRW1BdzC6wQjbLc6ySPX3xXM/A=;
        b=Vlaac1ETKsO7Ne0M31046Z9Ur2nTrPHXo5b78znIWZfdqHpfnZGmGVhx2SbwVNCFh+
         Fql4hvnd0oX22HCosPKkCbitmxI5HIai9dT/y2lb7F7QN54/gL2Gt06z20wM/OvizFw1
         vfsKz2oDssc99nFu0gQZOas0DwktIvLLHHO7cdbNMu5zSdx7y6W1X5sWflpNGSCHjXqM
         1+yNX6cPe8sCLiYf6gDOZ25XhlXNef4W7sAf0QKKl2T0CMOwuav/hoXBGZakrwM9nkr3
         pBiRNUeW/m6QOtdlQ087tJuapjgNqkrWm/DdbsPf8fLHIkmDl7l0K/T/qM6lF/DDMsic
         6tbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Zd1sw2u+5dkzdiuiuJRW1BdzC6wQjbLc6ySPX3xXM/A=;
        b=t8dgaMv8O4ZvTXrZg9DW+cYM7UdZyoqzgLedrzcqvaTfVEp6VxByZtPampYMWGXGet
         yHmp/LNudPfVxybXCsDPUCxvbprhwxzXcBZiWJsFMvLjmAjQ/5e/enz5j78Jp0UK7auB
         QBrz73k7DFC7bpI5r3a4KXkqgkFTXTEdqzJGAI9XgjBtEpy1ABAkMSYgS3TfcUMdiVD1
         Z05VTzpRtbgiV8TmKZRg7r2q7A+2XcQGSpEE9Q8/Qap3KzOCJSUZu0aVZLC9F2YfSkBJ
         xkq2Ja64UHz5rK4CebnGcfJlJ+9oU0Wplj1A0odD+sI/87MS8ugyePCU2S5DlbZy762Q
         Ca9g==
X-Gm-Message-State: AGi0PuYKu7v+u2ka5UPF6vz5cdNtZbJnrzErObjEgKsOYUn0Hxk58aUP
        Kt3dZ4Z3GRcisWZLUGdG94DWRkBjaPElRz18Iuk=
X-Google-Smtp-Source: APiQypI0k8YDdEnnjegAOa8Hei4TP8eS6JAT9rdqTmj/jrjMOToQz9TxIk6JatmQNVCURvW5gIrkSeE16XX+5wIpT38=
X-Received: by 2002:a2e:a169:: with SMTP id u9mr61253ljl.144.1588269835897;
 Thu, 30 Apr 2020 11:03:55 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 30 Apr 2020 11:03:44 -0700
Message-ID: <CAADnVQJfD1dLVsfg4=c4f6ftRNF_4z0wELjFq8z=7voi-Ak=7w@mail.gmail.com>
Subject: pulling cap_perfmon
To:     Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ingo,

I'd like to pull
commit 980737282232 ("capabilities: Introduce CAP_PERFMON to kernel
and user space")
into bpf-next to base my CAP_BPF work on top of it.
could you please prepare a stable tag for me to pull ?
Last release cycle Thomas did a tag for bpf+rt prerequisite patches and
it all worked well during the merge window.
I think that one commit will suffice.

Thanks!
