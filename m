Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6BF1700CB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 15:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgBZOKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 09:10:44 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:42180 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgBZOKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 09:10:44 -0500
Received: by mail-lj1-f174.google.com with SMTP id d10so3235802ljl.9
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 06:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rnx4Xd+dtxDnVToH7jWKchuq8rDW8XlBFu6UlDlXe+M=;
        b=qVUI1gCz3ih4+Mt5ETdO5egLx+s7ATsgjEiFw/ieOkUfmy8xyTbHTfFZCHEOHwPUFw
         BWs5Y0ZRdhT/FvscF23jRHLeM49qMjh99XCPcMpIiPNiipsZtLHsV0fd3F1oBc0Z7efG
         ybGm7Xz/JfR9RdGcOCmWoKshiIBGPK5YRUBaCQquclebBLYNSGOsia4VIX0ecL5rpkpd
         mC6b3fBSk2S90adz+NEkDKLoq9bwNLKNwUmDDBcTHEDTjEFTfIGwrohXVMSPoqSvdRYY
         6v3f5U9sYhGGd+hQf2xzbJ/RYTya3SASYJcWf2jksN169eAflowGUrFSkSB7UutDPunn
         I1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rnx4Xd+dtxDnVToH7jWKchuq8rDW8XlBFu6UlDlXe+M=;
        b=E84DT4YSdnwPYxQCfHV3u+9O8TU/rkwG+yCUQXn13a9nhIQYY3FV4fxxG1uQdlDS2s
         gMANfA5psscWmYAOL7qvaBxZpUyYbe7gKctFzZmhcyakF3QGlgFBpu17JXNsuIZt0FDa
         x0usgKxDA1YTDY1pUvM/0Dwa1M0GPURLrLl7uGUv/vXC15wI48NoBHBle2DMqCnjPQwO
         xk2YV9tCxpr9YfhlKLvhfVMgo1k3CxJPFXYnLIMHj9Aju+ls1CSwEv4EH5x35HPJfLa0
         jR3H0EluFJUrgyu6qK0lPWpAbagsUinOkcDm7ZC1DfXQyXXdiJszsIQHqOPxQB2HCWR8
         rHWw==
X-Gm-Message-State: APjAAAVZO9tCg/mRr5tgpMU2qfF97S/muLbKQhgcZpPrs9x8oP2zvkQl
        y16mL3hHmqXLDvf+O54W7CC1rp2E0CrbslxillMtFg==
X-Google-Smtp-Source: APXvYqyjU5dmLkA2R/1SUMHYRsOBAs9aqb5JlYEs5kg391RKaQNk2u3sUKAtMUtZodG48zYmNe8NZjhA9d1qRUde+fI=
X-Received: by 2002:a2e:909a:: with SMTP id l26mr2948184ljg.209.1582726240870;
 Wed, 26 Feb 2020 06:10:40 -0800 (PST)
MIME-Version: 1.0
References: <C7D5F99D-B8DB-462B-B665-AE268CDE90D2@vmware.com>
 <CAKfTPtA9275amW4wAnCZpW3bVRv0HssgMJ_YgPzZDRZ3A1rbVg@mail.gmail.com> <A6BD9BBB-B087-4A3C-BF3D-557626AC233A@vmware.com>
In-Reply-To: <A6BD9BBB-B087-4A3C-BF3D-557626AC233A@vmware.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 26 Feb 2020 15:10:28 +0100
Message-ID: <CAKfTPtByX6e0wQPYxgoYVUaiTfJPcTvrt-9W7CeA=V9aC_kH_Q@mail.gmail.com>
Subject: Re: Performance impact in networking data path tests in Linux 5.5 Kernel
To:     Rajender M <manir@vmware.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 at 12:45, Rajender M <manir@vmware.com> wrote:
>
> Thanks for your response, Vincent.
> Just curious to know, if there are any room for optimizing
> the additional CPU cost.

That's difficult to say, the additional cost is probably link to how
the CPU is involved in the data path. IIUC your results, there is +30%
CPUs for +20% of throughput for the 10GB NIC but only +10% CPU for
+25%  of throughput for the 40GB which might have more things done by
HW and needs less action from CPU

>
>
> =EF=BB=BFOn 26/02/20, 3:18 PM, "Vincent Guittot" <vincent.guittot@linaro.=
org> wrote:
>
>     Hi Rajender,
>
>     On Tue, 25 Feb 2020 at 06:46, Rajender M <manir@vmware.com> wrote:
>     >
>     > As part of VMware's performance regression testing for Linux Kernel=
 upstream
>     >  releases, when comparing Linux 5.5 kernel against Linux 5.4 kernel=
, we noticed
>     > 20% improvement in networking throughput performance at the cost of=
 a 30%
>     > increase in the CPU utilization.
>
>     Thanks for testing and sharing results with us. It's always
>     interesting to get feedbacks from various tests cases
>
>     >
>     > After performing the bisect between 5.4 and 5.5, we identified the =
root cause
>     > of this behaviour to be a scheduling change from Vincent Guittot's
>     > 2ab4092fc82d ("sched/fair: Spread out tasks evenly when not overloa=
ded").
>     >
>     > The impacted testcases are TCP_STREAM SEND & RECV =E2=80=93 on both=
 small
>     > (8K socket & 256B message) & large (64K socket & 16K message) packe=
t sizes.
>     >
>     > We backed out Vincent's commit & reran our networking tests and fou=
nd that
>     > the performance were similar to 5.4 kernel - improvements in networ=
king tests
>     > were no more.
>     >
>     > In our current network performance testing, we use Intel 10G NIC to=
 evaluate
>     > all Linux Kernel releases. In order to confirm that the impact is a=
lso seen in
>     > higher bandwidth NIC, we repeated the same test cases with Intel 40=
G and
>     > we were able to reproduce the same behaviour - 25% improvements in
>     > throughput with 10% more CPU consumption.
>     >
>     > The overall results indicate that the new scheduler change has intr=
oduced
>     > much better network throughput performance at the cost of increment=
al
>     > CPU usage. This can be seen as expected behavior because now the
>     > TCP streams are evenly spread across all the CPUs and eventually dr=
ives
>     > more network packets, with additional CPU consumption.
>     >
>     >
>     > We have also confirmed this theory by parsing the ESX stats for 5.4=
 and 5.5
>     > kernels in a 4vCPU VM running 8 TCP streams - as shown below;
>     >
>     > 5.4 kernel:
>     >   "2132149": {"id": 2132149, "used": 94.37, "ready": 0.01, "cstp": =
0.00, "name": "vmx-vcpu-0:rhel7x64-0",
>     >   "2132151": {"id": 2132151, "used": 0.13, "ready": 0.00, "cstp": 0=
.00, "name": "vmx-vcpu-1:rhel7x64-0",
>     >   "2132152": {"id": 2132152, "used": 9.07, "ready": 0.03, "cstp": 0=
.00, "name": "vmx-vcpu-2:rhel7x64-0",
>     >   "2132153": {"id": 2132153, "used": 34.77, "ready": 0.01, "cstp": =
0.00, "name": "vmx-vcpu-3:rhel7x64-0",
>     >
>     > 5.5 kernel:
>     >   "2132041": {"id": 2132041, "used": 55.70, "ready": 0.01, "cstp": =
0.00, "name": "vmx-vcpu-0:rhel7x64-0",
>     >   "2132043": {"id": 2132043, "used": 47.53, "ready": 0.01, "cstp": =
0.00, "name": "vmx-vcpu-1:rhel7x64-0",
>     >   "2132044": {"id": 2132044, "used": 77.81, "ready": 0.00, "cstp": =
0.00, "name": "vmx-vcpu-2:rhel7x64-0",
>     >   "2132045": {"id": 2132045, "used": 57.11, "ready": 0.02, "cstp": =
0.00, "name": "vmx-vcpu-3:rhel7x64-0",
>     >
>     > Note, "used %" in above stats for 5.5 kernel is evenly distributed =
across all vCPUs.
>     >
>     > On the whole, this change should be seen as a significant improveme=
nt for
>     > most customers.
>     >
>     > Rajender M
>     > Performance Engineering
>     > VMware, Inc.
>     >
>
>
