Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D181A0146
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDFWsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 18:48:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37897 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgDFWsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 18:48:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so8341319pfo.5
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 15:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+/uK1GMU5jAwK9ukyihG/G0TeXIjcT79c/SFYLXnz0=;
        b=RCjbXs9n4z9ZFdFfxutCu7XXU7qZ9LFgGaFeqAQSKR82o0dFxe1R9bHdZHUDKyH136
         Cv+KCsuM+T+fGzhUHRte4bg6/cMEch2b1H/z47JB5Sl3XHnenOJEL20uSp9EvnNxlWef
         04Ls7T4vjR/bWHnO+lE87ndHZ3Zdkpr4QOfhNUhTuSlWSaI85dXOYra5fV6t2qWByzYI
         +qGkYL2m5orcCfpU+ITeEVQLyUiCq1NoISq25yvEYhaY//BZWP94Awjnv5He1RW49SQN
         xh+WXfL7IGjFWmaS7iUmG2AL46hpTjFYIf/JdLX9yq7DbryzinUSw58LQMZyQ1Xrl12X
         irJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+/uK1GMU5jAwK9ukyihG/G0TeXIjcT79c/SFYLXnz0=;
        b=ZUBaXkuyTyQpqc/QsulJ8T97NwNV6LjNednU4g7ndMLE/yGEQqpJ4WdUQUbAh15O0D
         TVebAVFjwPT71yLW6pmsCyiS0ZfJh+j5QMq0l3FXG3s69kJnWVA6uLlDJn3m5rf/MQBL
         bCB+gy4sLwvHADSF5SIRADJd5nipqZX5VR7QkcCVnqg9eRcDlpqiAuhcU97NiUjb85pc
         cLHg5NrMznm+gJfPGPaP2LMp351/ICECeR2ljiqPTdcPEAgpwCiRZDfQlEn61hIIjtqL
         jCO9oRtOB5uIeX2e5gEu35iTfH/wunZ9zJNM7Ru6QXJllYMb247DyY8ie2GAwwYAQK/v
         ihMQ==
X-Gm-Message-State: AGi0PuZ6H+PHhnitgrHxinK8WQYGgDM0MirtaNW2YqSMffrbJoHycx4M
        grodvaX/e4YcsMvfawiIUkyEYA==
X-Google-Smtp-Source: APiQypI65vX9LAvgLflHPV9/yfT8lBuDdh+jHOAry7q/AJ/LfLa85NDILL8W6yOpXbxT/Z3g12R0Ow==
X-Received: by 2002:a63:5053:: with SMTP id q19mr1360263pgl.66.1586213333158;
        Mon, 06 Apr 2020 15:48:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id fh6sm601619pjb.7.2020.04.06.15.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 15:48:52 -0700 (PDT)
Date:   Mon, 6 Apr 2020 15:48:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        dsahern@gmail.com, davem@davemloft.net, kuba@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next] devlink: fix JSON output of mon
 command
Message-ID: <20200406154843.6b31b0b1@hermes.lan>
In-Reply-To: <87imice4uo.fsf@mellanox.com>
References: <20200402095608.18704-1-jiri@resnulli.us>
        <6c15c9ec-e1e3-cf78-e2bb-9c5db8d43abc@intel.com>
        <87imice4uo.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Apr 2020 22:28:31 +0200
Petr Machata <petrm@mellanox.com> wrote:

> Jacob Keller <jacob.e.keller@intel.com> writes:
> 
> > On 4/2/2020 2:56 AM, Jiri Pirko wrote:  
> >> From: Jiri Pirko <jiri@mellanox.com>
> >>
> >> The current JSON output of mon command is broken. Fix it and make sure
> >> that the output is a valid JSON. Also, handle SIGINT gracefully to allow
> >> to end the JSON properly.
> >>  
> >
> > I wonder if there is an easy way we could get "make check" or something
> > to add a test to help verify this is valid JSON?  
> 
> Simply piping to jq is an easy way to figure out if it's at least valid
> JSON. In principle it would be possible to write more detailed checks as
> TDC (tc-testing) selftests in the kernel.
> 
> Something like this:
> 
>     {
>         "id": "a520",
>         "name": "JSON",
>         "category": [
>             "qdisc",
>             "fifo"
>         ],
>         "setup": [
>             "$IP link add dev $DUMMY type dummy || /bin/true",
> 	    "$TC qdisc add dev $DUMMY handle 1: root bfifo"
>         ],
>         "cmdUnderTest": "/bin/true",
>         "expExitCode": "0",
>         "verifyCmd": "$TC -j qdisc show dev $DUMMY | jq '.[].kind'",
>         "matchPattern": "bfifo",
>         "matchCount": "1",
>         "teardown": [
>             "$TC qdisc del dev $DUMMY handle 1: root bfifo",
>             "$IP link del dev $DUMMY type dummy"
>         ]
>     }
> 
> Kinda verbose for this level of detail though.

I just use python -m json.tool which is easy (always available)
and picky
