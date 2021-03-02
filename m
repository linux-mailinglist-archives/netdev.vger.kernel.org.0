Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0521A32B36C
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbhCCDxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379964AbhCBKWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:22:34 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EEFC061793;
        Tue,  2 Mar 2021 02:21:10 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l22so1756902wme.1;
        Tue, 02 Mar 2021 02:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p/LO4ojFt4+oNs7gTlTDAx+oem2Oma63Bf52gj+VZow=;
        b=TgDaZySDzPJ+5qEE7Iq84JeLmSHVsUES5b9lWP8ScDlFf76vpIx5LjxBgTeZ1S5C2R
         n07maCPpT0HkRX4VODd84SadZ5I4uIK/na17FAL/dSSB6hoB3fc8MTtXkY8ahgAKlCuA
         DcDr2+4AuQ4NlKmQTrqHzGs2iu2k2GuRV+op6WMPjtDxxQm/qd7tZ2+gw6gWtWiwzXgU
         qYZHYg3w9X0tEQUSpbwOpH+9omsuzqWnCnZsIUhU1DLPeaO1E5zFVtSo86fAE8vWsUQa
         bZ/3FN8cpoQjTLJoTYGaWEDAL1NnsS4hI4s4Y+x4z67OaE4FlYMSX45o14ZqPKpV2zBF
         7iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p/LO4ojFt4+oNs7gTlTDAx+oem2Oma63Bf52gj+VZow=;
        b=s3ZOp0DkN2JpHqrz0a/lEvQJJlEWJeJuWYt58P5M9iz6SfAnBJB0vJK78qndbooQ4/
         nHmloOHtfsD2HETyfUEDwcnQAA41PSBr/Dzky06kfnAs2zz9srmU/sxWlAxW6WHWtu5A
         UukZwh35wnTSaqYe5PZcR2TIQrfRS4jgpd3oS7DxKSWCzmCv3MwJP8s78dGLkmExyxCc
         Z/fcPZtcmkz8KnZ6IuMiPIvlvKirJM9tzOgYOX9Sy6/7PvQ94fB38YLrSSB4m637bjnt
         9K5wo8JCFq89bagvwiJvjytRLyzclvpdI56y/i+93Fda/wZZa1zGpgJGZnKvR2rGyUWa
         RjMA==
X-Gm-Message-State: AOAM53276UVv6YZ/eLnLSev6nVyG8TPjjib09FFyZ6jflJhe3K02WAYU
        niZs9inh5z37opkPG32dW30mxqXeEUjQfnL9MhLa0WKoctc=
X-Google-Smtp-Source: ABdhPJyJx/SGxJY4Fp6S1xSLe3ZwJ64pj/TXmTVGmBkw7E2WgFAq93veeK/xcz3B8qPMOGLkz4cgrvv2KBqVvY4Ydzs=
X-Received: by 2002:a1c:7312:: with SMTP id d18mr3239018wmb.155.1614680468365;
 Tue, 02 Mar 2021 02:21:08 -0800 (PST)
MIME-Version: 1.0
References: <20210223162304.7450-1-ciara.loftus@intel.com>
In-Reply-To: <20210223162304.7450-1-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 2 Mar 2021 11:20:56 +0100
Message-ID: <CAJ+HfNhB3CG+exC4P-Xwm8+h=DHuzkShb4ujmuN+-GPPLKe2Zg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/4] selftests/bpf: xsk improvements and new
 stats tests
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 at 17:53, Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> This series attempts to improve the xsk selftest framework by:
> 1. making the default output less verbose
> 2. adding an optional verbose flag to both the test_xsk.sh script and xdp=
xceiver app.
> 3. renaming the debug option in the app to to 'dump-pkts' and add a flag =
to the test_xsk.sh
> script which enables the flag in the app.
> 4. changing how tests are launched - now they are launched from the xdpxc=
eiver app
> instead of the script.
>
> Once the improvements are made, a new set of tests are added which test t=
he xsk
> statistics.
>
> The output of the test script now looks like:
>
> ./test_xsk.sh
> PREREQUISITES: [ PASS ]
> 1..10
> ok 1 PASS: SKB NOPOLL
> ok 2 PASS: SKB POLL
> ok 3 PASS: SKB NOPOLL Socket Teardown
> ok 4 PASS: SKB NOPOLL Bi-directional Sockets
> ok 5 PASS: SKB NOPOLL Stats
> ok 6 PASS: DRV NOPOLL
> ok 7 PASS: DRV POLL
> ok 8 PASS: DRV NOPOLL Socket Teardown
> ok 9 PASS: DRV NOPOLL Bi-directional Sockets
> ok 10 PASS: DRV NOPOLL Stats
> # Totals: pass:10 fail:0 xfail:0 xpass:0 skip:0 error:0
> XSK KSELFTESTS: [ PASS ]
>
> v2->v3:
> * Rename dump-pkts to dump_pkts in test_xsk.sh
> * Add examples of flag usage to test_xsk.sh
>
> v1->v2:
> * Changed '-d' flag in the shell script to '-D' to be consistent with the=
 xdpxceiver app.
> * Renamed debug mode to 'dump-pkts' which better reflects the behaviour.
> * Use libpf APIs instead of calls to ss for configuring xdp on the links
> * Remove mutex init & destroy for each stats test
> * Added a description for each of the new statistics tests
> * Distinguish between exiting due to initialisation failure vs test failu=
re
>
> This series applies on commit d310ec03a34e92a77302edb804f7d68ee4f01ba0
>

Ciara, this slipped on my side! Apologies! This is much better, thanks
for working on it!

For the series:
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


>
> Ciara Loftus (3):
>   selftests/bpf: expose and rename debug argument
>   selftests/bpf: restructure xsk selftests
>   selftests/bpf: introduce xsk statistics tests
>
> Magnus Karlsson (1):
>   selftest/bpf: make xsk tests less verbose
>
>  tools/testing/selftests/bpf/test_xsk.sh    | 135 ++------
>  tools/testing/selftests/bpf/xdpxceiver.c   | 380 +++++++++++++++------
>  tools/testing/selftests/bpf/xdpxceiver.h   |  57 +++-
>  tools/testing/selftests/bpf/xsk_prereqs.sh |  30 +-
>  4 files changed, 342 insertions(+), 260 deletions(-)
>
> --
> 2.17.1
>
