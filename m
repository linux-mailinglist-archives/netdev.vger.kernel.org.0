Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A32ECBEB2
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfJDPMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:12:09 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36573 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389196AbfJDPMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:12:09 -0400
Received: by mail-yw1-f66.google.com with SMTP id x64so2447542ywg.3
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W8Qik6CxLCk47wn0wFCq4Awps9BJ72NBHmb83Tu5eyM=;
        b=t6e/J8ivuGROYPd8ItygWymps151i21B5Q2bHiSgtti3h1Y9ElNXQkIxh1nyCfCcGD
         TGmDDKwgnL4tYdozYbNRKlWwGmVSRm9/yAaBoGK/M6aIavYb4srs3s8kYjz5V4kl2S8D
         /h8vEC+8sjWFay6fnBA3Wn+odAc2BYpYKQLLtrMNmIgHn8PI7B6CprCIRnm2nwKP6ZIV
         Pb5NN1Y3W4MRCPWBMrZc+6LsCpl+e+l+YXeC+pAcY6T2AFRAQuVEbbDoyKs6KvOo/QXH
         Pvti7rMOZ4AMVxeMAzvMvLTZ85c3gKoVheK2smQHt9FYwAK05bRn1pXVfPfEndbIhAd6
         fQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W8Qik6CxLCk47wn0wFCq4Awps9BJ72NBHmb83Tu5eyM=;
        b=cGyCtZTmlgJmd4DamB/PulO6puEyu7EDh9vz4H36a/MBgsV4qh8jUl9Ow4uF0jtbWh
         8abeD/cLiD/vD3SBehGJjjW5Dm6qWUBJRcOTNTSKDEDry5FIAqaafWIoa47oxx+TSMib
         2A52pbDxKsHU96haIHpW7q9oMePZ7H0haXaVojpU9cBlkWlK6O8Zzj72PdEG5j2buQ5o
         18RWiTrGstAdx1UxUcRchBwphP6ECQryvgKl+EAiXGCQVk0vjwVu1GBIWoKmdpF1bHGC
         pKQJa0HrXz1TDXhmMGEiswN60eBRKVAdHgFbbDYPLQNTuCTrtGwMbocayFILUBo867LM
         dGuQ==
X-Gm-Message-State: APjAAAVR6XE6ZtO54lQ5TeP1HOaxVev2KKd0jnCiieGUS1egnGHiq8Qh
        zmLXJ6Um6oZcKe9cdb45pGIpriBD0L91X6O0OwBR3aA09Q==
X-Google-Smtp-Source: APXvYqwQEMFj7mTA9IjyFKukNZLMsORVZJK4nxwBz5ps3xRXK+iZlBg96jhXA3dRGtgltLlRn6NFRwwggd/jTJFOJoA=
X-Received: by 2002:a81:7dc5:: with SMTP id y188mr10713464ywc.69.1570201927394;
 Fri, 04 Oct 2019 08:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191004013301.8686-1-danieltimlee@gmail.com> <20191004013301.8686-2-danieltimlee@gmail.com>
 <20191004152409.55bb1ae0@carbon>
In-Reply-To: <20191004152409.55bb1ae0@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 5 Oct 2019 00:11:49 +0900
Message-ID: <CAEKGpzj3AyU2cn4MTL_W2u2oFJEnC4MJLWx7WvdsvckzC2kOnQ@mail.gmail.com>
Subject: Re: [v4 2/4] samples: pktgen: fix proc_cmd command result check logic
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:24 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> [...]
>
> Is this comment still relevant?  You just excluded "pgctrl" from
> getting into this section.
>

Oops, will fix it right away.

> > +        if [[ "$result" == "" ]]; then
> > +        grep "Result:" $proc_ctrl >&2
>
> Missing tap/indention?
>
> > +        fi
> >      fi
> >      if (( $status != 0 )); then
> >       err 5 "Write error($status) occurred cmd: \"$@ > $proc_ctrl\""
> > @@ -105,6 +109,8 @@ function pgset() {
> >      fi
> >  }
> >
> > +trap 'pg_ctrl "reset"' EXIT
> > +
>
> This line is activated when I ctrl-C the scripts, but something weird
> happens, it reports:
>
>  ERROR: proc file:/proc/net/pktgen/pgctrl not writable, not root?!
>

Seems, the error is shown when the script is executed without sudo.
By grep-ing the debug info with 'set -x', you can find out that script elevate
itself to sudo by 'root_check_run_with_sudo'.

As you can see, there are three 'pg_ctrl reset'.

First one is called as preparation for packet sending,
Second is called as trap EXIT when sudo elevated script is done and exit.
Last one is also called as trap EXIT, but it is not executed as sudo.



$ ./pktgen_sample01_simple.sh 1>/dev/null 2>out
$ cat out | egrep -A 2 -B 2 'trap|sudo|pg_ctrl reset'
...
++ trap 'pg_ctrl "reset"' EXIT
+ root_check_run_with_sudo
+ '[' 1000 -ne 0 ']'
+ '[' -x ./pktgen_sample01_simple.sh ']'
+ info 'Not root, running with sudo'
+ [[ -n '' ]]
+ sudo ./pktgen_sample01_simple.sh
++ export PROC_DIR=/proc/net/pktgen
++ PROC_DIR=/proc/net/pktgen
++ trap 'pg_ctrl "reset"' EXIT
+ root_check_run_with_sudo
+ '[' 0 -ne 0 ']'
+ source ./parameters.sh
--
+ UDP_SRC_MIN=9
+ UDP_SRC_MAX=109
+ pg_ctrl reset
+ local proc_file=pgctrl
+ proc_cmd pgctrl reset
--
+ echo 'Result device: wlp2s0'
+ cat /proc/net/pktgen/wlp2s0
+ pg_ctrl reset
+ local proc_file=pgctrl
+ proc_cmd pgctrl reset
--
+ ((  0 != 0  ))
+ exit 0
+ pg_ctrl reset
+ local proc_file=pgctrl
+ proc_cmd pgctrl reset


As for solution, only call 'pg_ctrl reset' when it's running as sudo
will solve the problem.
-trap 'pg_ctrl "reset"' EXIT
+trap '[[ $EUID -eq 0 ]] && pg_ctrl "reset"' EXIT

Will apply this at next version of patch.

Thanks,
Daniel

>
> >  ## -- General shell tricks --
> >
> >  function root_check_run_with_sudo() {
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
