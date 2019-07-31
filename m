Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAED27B872
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 06:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfGaEQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 00:16:28 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35333 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfGaEQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 00:16:28 -0400
Received: by mail-lj1-f195.google.com with SMTP id x25so64271506ljh.2;
        Tue, 30 Jul 2019 21:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6OtUnKT18Ci+lW6CmCVbqoSRAd+jTdoTx9bwjfNStg0=;
        b=sSESjRp3/NtS2obfX3VWzd2a6LNc9UDYGMMc0gZWt2kVjognYQ7acaBb7Oq8MfaTyd
         G/7GgTrJd31nvPU6+BsuJBPwhzkKWWiK2qJfpudTRmfRcbT971PsBnzHHWjzXqkQpT3b
         45+Yw8YmqC8T1pylIhZWDG+OjB7ETefQx48Sl+omJAQHO5MQedrh1wh6/0VNTq1tOMS+
         nMRZTvj200UEcLUq8rGqYuA+t4VSe9GsBTKCJuSSXGEn7HAnTZ6frSzMIYjEm3SppcQ3
         wm+KWXDtUusroi1BUMk+wMbzRCuL0pAGGtIBBjQB1A0rxDN/mpqTTVryGo1TtdnKeB7Y
         1d1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6OtUnKT18Ci+lW6CmCVbqoSRAd+jTdoTx9bwjfNStg0=;
        b=gxdNalPzSoKppZeXIomQ5vafUEaKMFkhaqDSB7iKE6yBQ3gx1lbf1/ohYuPsRxGUZw
         XqS2LRzn2DWMV+m5DPk6tDQmFw/XP93oV/ts8b/UZl4r3mMzG16Y31lFECoWT3zNdc5I
         cbRFr0apIRIzCbauxP73zqP2IfgywA8gECd9B7ZOVOLffyoGUg0DfeglDiG4D3UHRDkF
         Ol0mGm4/S5n/QwcZhwKI1Kh5A/WcefnVQmWxues4TPF02yHm4F2O/mxQXJq81ukqV2Vj
         YRn3e5wVwPe2qYmJ1DB21L5hSp3pQikBFtjvGGlL4b911QrLntXhWr8nuikS1xfHRtpk
         inoA==
X-Gm-Message-State: APjAAAVVGTS+84faTDBmUm+V96EdHMUI0Dr4gdLsGBFkJEu0y3VKYXlA
        OrB5sozRSGDA44E2NyqaUupUMFiNhoi2crB599P0mQ==
X-Google-Smtp-Source: APXvYqybghqdMu7GOys3yy53mEz/3zRrEkH+cjwUB/8hgv9smh3kkOG9Uv+zpl0H51/y0oxJXTUrxFrgS8asUAaKDPY=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr34966442ljc.210.1564546586604;
 Tue, 30 Jul 2019 21:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190730210300.13113-1-jakub.kicinski@netronome.com> <20190730220053.GA69301@ctakshak-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190730220053.GA69301@ctakshak-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Jul 2019 21:16:15 -0700
Message-ID: <CAADnVQJapeA8dqA1hZ=r-Qk8h9i+ZfApvSiSshCeqOBAAEBzRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] tools: bpftool: add support for reporting the
 effective cgroup progs
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 3:01 PM Takshak Chahande <ctakshak@fb.com> wrote:
>
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote on Tue [2019-Jul-30 14:03:00 -0700]:
> > Takshak said in the original submission:
> >
> > With different bpf attach_flags available to attach bpf programs specially
> > with BPF_F_ALLOW_OVERRIDE and BPF_F_ALLOW_MULTI, the list of effective
> > bpf-programs available to any sub-cgroups really needs to be available for
> > easy debugging.
> >
> > Using BPF_F_QUERY_EFFECTIVE flag, one can get the list of not only attached
> > bpf-programs to a cgroup but also the inherited ones from parent cgroup.
> >
> > So a new option is introduced to use BPF_F_QUERY_EFFECTIVE query flag here
> > to list all the effective bpf-programs available for execution at a specified
> > cgroup.
> >
> > Reused modified test program test_cgroup_attach from tools/testing/selftests/bpf:
> >   # ./test_cgroup_attach
> >
> > With old bpftool:
> >
> >  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/
> >   ID       AttachType      AttachFlags     Name
> >   271      egress          multi           pkt_cntr_1
> >   272      egress          multi           pkt_cntr_2
> >
> > Attached new program pkt_cntr_4 in cg2 gives following:
> >
> >  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
> >   ID       AttachType      AttachFlags     Name
> >   273      egress          override        pkt_cntr_4
> >
> > And with new "effective" option it shows all effective programs for cg2:
> >
> >  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2 effective
> >   ID       AttachType      AttachFlags     Name
> >   273      egress          override        pkt_cntr_4
> >   271      egress          override        pkt_cntr_1
> >   272      egress          override        pkt_cntr_2
> >
> > Compared to original submission use a local flag instead of global
> > option.
> >
> > We need to clear query_flags on every command, in case batch mode
> > wants to use varying settings.
> >
> > v2: (Takshak)
> >  - forbid duplicated flags;
> >  - fix cgroup path freeing.
> >
> > Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
...
>
> Reviewed-by: Takshak Chahande <ctakshak@fb.com>

Applied. Thanks
