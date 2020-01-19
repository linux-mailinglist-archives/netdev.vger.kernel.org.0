Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27ABE141D94
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgASLbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:16 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33180 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgASLbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:15 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so31000536lji.0
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 03:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gNFLQvdW6M9ju5aUk9iXRGizj0M4IrqmgkgIfSX86JA=;
        b=O9Jqt0lUiyOamXqjT27UahuDMXA16j/OHKU6BWEINlAqY1PhmqsDbSDvmLGUDxyVWa
         +C1b/9ORzAMYZRrlBd0t3vwVgeb9N/73XQZUKEWAacI5310YXKG9vC9mWozbUuS95nYo
         cTomviLHnNEKR49+hZbSBctS9NvtmTUEojH8qD0HcBZ+PM30EgwcDDRvR/qT6s11HKi9
         m5Rapx1VZ+YCsCEIccjimi5m/udX/v1Qv372bqpMgnLaXlAVtuMz8Jnh1Xp1JW4tyM2m
         HDyBtEugo+7chqyRmHaS0lTIddr6qb1a74cMILrQJR6+kZrtRWY7jHw/PkZX4g5lyFmX
         a9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gNFLQvdW6M9ju5aUk9iXRGizj0M4IrqmgkgIfSX86JA=;
        b=NhUIbch4ePmJu9JwzdTu5gpHsLoSGZvZpYcsgmVaJLwVeYPefSC97kIMGlDzUs68vV
         +fU6wCmwJz3KsI+XsKV2LEeXpi+JRBN8peA7YwVttmB9GfaPpvkBn7EHoYA1Ev0xyWVI
         D/EIq0gAiAgvRy8UPLZmqc40vU34QhfYDFJzZ7b1aln4XdbO3hbtuycJhShNl9U8v2OM
         GvrWwMRQVoHxwH+7YzuaTVJHFCTOVewxrsoj9JcmyJ5FRyov/AT9LRwdhoZH25fa1djN
         EG98AbE1DVNn6FsUCnldOtBX1e2jPoyFhaGegUXfAyM526VVtpIliFW4SmsPuCW35om8
         claw==
X-Gm-Message-State: APjAAAWnQGzWZGUpukoSvNbaNX5uOBKDYwpbPQKaceDUhyXWMupjHinJ
        XpPhhw3RFTPD49kInHR9x9UxcWma/v8oU6kZWa0=
X-Google-Smtp-Source: APXvYqxMUJDBv3+C06jC8ZSmcdR6viS0GmK5DbmaeoH3oo1v6DiI5PwttpEepivHxbjFYz0Wq/pMdAhEHSqBajXNysk=
X-Received: by 2002:a2e:8551:: with SMTP id u17mr10530703ljj.165.1579433473784;
 Sun, 19 Jan 2020 03:31:13 -0800 (PST)
MIME-Version: 1.0
References: <20200111163743.4339-1-ap420073@gmail.com> <20200117033802.GA19765@kadam>
In-Reply-To: <20200117033802.GA19765@kadam>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 19 Jan 2020 20:31:02 +0900
Message-ID: <CAMArcTXowXuvg9+mr+aLKfTZXN2iZRXz=39c97UTgQQ8kX8d2g@mail.gmail.com>
Subject: Re: [PATCH net 4/5] netdevsim: use IS_ERR instead of IS_ERR_OR_NULL
 for debugfs
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, kbuild-all@lists.01.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jan 2020 at 12:36, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>

Hi Dan,

> Hi Taehee,
>
> url:    https://github.com/0day-ci/linux/commits/Taehee-Yoo/netdevsim-fix-a-several-bugs-in-netdevsim-module/20200112-004546
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git a5c3a7c0ce1a1cfab15404018933775d7222a517
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> smatch warnings:
> drivers/net/netdevsim/bpf.c:246 nsim_bpf_create_prog() error: dereferencing freed memory 'state'
>
> # https://github.com/0day-ci/linux/commit/923e31529b0b3f039f837f54c4a1bbd77793256b
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 923e31529b0b3f039f837f54c4a1bbd77793256b
> vim +/state +246 drivers/net/netdevsim/bpf.c
>
> d514f41e793d2c Jiri Pirko     2019-04-25  227  static int nsim_bpf_create_prog(struct nsim_dev *nsim_dev,
> b26b6946a62f37 Jiri Pirko     2019-04-12  228                           struct bpf_prog *prog)
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  229  {
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  230   struct nsim_bpf_bound_prog *state;
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  231   char name[16];
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  232
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  233   state = kzalloc(sizeof(*state), GFP_KERNEL);
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  234   if (!state)
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  235           return -ENOMEM;
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  236
> d514f41e793d2c Jiri Pirko     2019-04-25  237   state->nsim_dev = nsim_dev;
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  238   state->prog = prog;
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  239   state->state = "verify";
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  240
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  241   /* Program id is not populated yet when we create the state. */
> d514f41e793d2c Jiri Pirko     2019-04-25  242   sprintf(name, "%u", nsim_dev->prog_id_gen++);
> d514f41e793d2c Jiri Pirko     2019-04-25  243   state->ddir = debugfs_create_dir(name, nsim_dev->ddir_bpf_bound_progs);
> 923e31529b0b3f Taehee Yoo     2020-01-11  244   if (IS_ERR(state->ddir)) {
> 31d3ad832948c7 Jakub Kicinski 2017-12-01  245           kfree(state);
>                                                               ^^^^^
> state is freed.
>
> 923e31529b0b3f Taehee Yoo     2020-01-11 @246           return PTR_ERR(state->ddir);
>                                                                        ^^^^^^^^^^^
> Then dereferenced afterward.
>

Thank you for catching this bug.
I will fix this.

Thank you!
Taehee Yoo
