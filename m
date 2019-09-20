Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5030B89A3
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 05:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437108AbfITDEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 23:04:34 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35352 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437101AbfITDEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 23:04:33 -0400
Received: by mail-yb1-f196.google.com with SMTP id b128so2128821ybh.2
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 20:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ByZcZl2BxpmSadnZ4dw+cndjivF+Hz2eMrrFdCO1epc=;
        b=f9CgsnF30ZumnC3e4WDTExZeJcqOt9oPfCrGTN+9cH0YfleltkPDCYNj/OwjAcvHgF
         y31xPJ5v7slsp9YOLh22dGiB//7RYOmMgrB6K684jy1JeYMWrEVkP1ZrluFVZSfAHvsL
         2T8fnQKW/UH4cv4ZUP8MbJczc2okU6fCJxABljyCXvE40s5A+rrHJ3jATryYVCXUgz68
         d1LrDP03YTqEhESnRsiWgWLO3r8IWKu5r8o7HkT4zAdQtRNG3sRDZGXfEksJX/5R7prM
         iaeJZPerRkPzdq2wL1QVxmgVexCyLk2Sige+yUPpIPyfY2D/v5rjNm5yk+aIZ5p/AFbo
         yg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ByZcZl2BxpmSadnZ4dw+cndjivF+Hz2eMrrFdCO1epc=;
        b=dtpTXLE/rm8dG6UNDvpJYtsoT7DlEk+Zl/dHS63IXVG2qcUjsPYokKEVBmD5uHqXLk
         r5mRj/6GEy86KA+ntC2Q5he3aUTyQqB2Y5fUu2a3Q1zmyUweE9iV6bE3eT+UWv/+fNKD
         G+pd8HQaL6DUZFR/FYN4Q0qh633KPd0teVT+SVquYFRtxED4hz+hHBIgs8lnLdIZf/8+
         fwxXe0R6175j+ow87y3dm3iTnKHEp3m9J9PzlGdR8q+HYEx2dqokSUScYqDeo1Ok4Fw5
         /yb+5oPnzIx85vmSbpxAriLm0Mzd11cDTkP9vaFOGrE+zDf0Bznqtt5WE36lvUtddGGA
         xaXw==
X-Gm-Message-State: APjAAAW2ojE78pRwOy1ZCkzN6xX0dIi7CNwXojD/UC62tPsEU2nBp2lU
        UG60jFJ4Os3C5tQQHS9Bgka1931qo1yX8xrJew==
X-Google-Smtp-Source: APXvYqwPyJL8+qrLIcxHAjTp+M6PQnY6xRK//69Ho703JhQUJCaYrZpxBtp/Jk85A2Cj6rc2U7OTy0h+BZ3cTzkitPc=
X-Received: by 2002:a25:e714:: with SMTP id e20mr8147248ybh.349.1568948672999;
 Thu, 19 Sep 2019 20:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190914151353.18054-1-danieltimlee@gmail.com>
 <20190914151353.18054-2-danieltimlee@gmail.com> <20190916085317.02e4d985@carbon>
 <87sgowl7xe.fsf@toke.dk>
In-Reply-To: <87sgowl7xe.fsf@toke.dk>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 20 Sep 2019 12:04:15 +0900
Message-ID: <CAEKGpzintX9g5aBsN=qRuV12d3fPMicx+2Y1bKbOzUbw-X_ksg@mail.gmail.com>
Subject: Re: [v3 2/3] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the feedback!

How about just capturing with "Result: OK" except for 'pgctrl'?
(more details are in the diff below)

    ~/git/linux/net$ ag -Q 'Result:'
    core/pktgen.c
    702:            seq_printf(seq, "Result: %s\n", pkt_dev->result);
    704:            seq_puts(seq, "Result: Idle\n");
    1739:           seq_printf(seq, "\nResult: %s\n", t->result);
    1741:           seq_puts(seq, "\nResult: NA\n");

The upper command shows that 'Result: ' string is only printed on
'pktgen_if' and 'pktgen_thread'. So I thought just changing to below diff
will solve the problem.

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 87ae61701904..38cf9f62502f 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -60,6 +60,7 @@ function pg_set() {
 function proc_cmd() {
     local result
     local proc_file=$1
+    local status=0
     # after shift, the remaining args are contained in $@
     shift
     local proc_ctrl=${PROC_DIR}/$proc_file
@@ -75,13 +76,14 @@ function proc_cmd() {
        echo "cmd: $@ > $proc_ctrl"
     fi
     # Quoting of "$@" is important for space expansion
-    echo "$@" > "$proc_ctrl"
-    local status=$?
+    echo "$@" > "$proc_ctrl" || status=$?

-    result=$(grep "Result: OK:" $proc_ctrl)
-    # Due to pgctrl, cannot use exit code $? from grep
-    if [[ "$result" == "" ]]; then
-       grep "Result:" $proc_ctrl >&2
+    if [[ "$proc_file" != "pgctrl" ]]; then
+        result=$(grep "Result: OK:" $proc_ctrl) || true
+        # Due to pgctrl, cannot use exit code $? from grep
+        if [[ "$result" == "" ]]; then
+        grep "Result:" $proc_ctrl >&2
+        fi
     fi

> We actually want to continue, and output what command that failed (and
> also grep again after "Result:" to provide the kernel reason).
Since, with 'true', the command won't fail and continue, and on error with
'pktgen_if' and 'pktgen_thread', It'll grep again after "Result:" to provide
the kernel reason. [1][2]

> I'd argue that fixing this is the right thing to do... Maybe add set -o
> nounset as well while we're at it? :)
Adding nounset option could break working with $IP6. Most of the scripts
tries to check if $IP6 variable exists whether it is defined or not.

> Even if you somehow "fix" function proc_cmd, then we in general want to
> catch different error situations by looking at status $?, and output
> meaning full errors via calling err() function.  IHMO as minimum with
> errexit you need a 'trap' function that can help/inform the user of
> what went wrong.

I agree. trap ERR will help with more sophisticated handling of errors, but
I'm not sure which to elaborate more (about what went wrong) compared
to current error format? (which is grep again after "Result:" to provide the
kernel reason.)

I really appreciate your time and effort for the review.

Thanks,
Daniel

[1]: pktgen_if_show:
https://elixir.bootlin.com/linux/latest/source/net/core/pktgen.c#L702
[2]: pktgen_thread_show:
https://elixir.bootlin.com/linux/latest/source/net/core/pktgen.c#L1739
