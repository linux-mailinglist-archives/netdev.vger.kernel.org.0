Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CDB23021B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgG1FyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgG1FyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:54:09 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62541C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 22:54:09 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id r11so2427583pfl.11
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 22:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=vb21OqFItnARQwQltnaJpDPq8jZArDQHYRbPDYS57rE=;
        b=hGm4Y/QbVUvZ3sUalaPa0abHYEUNilQOgmRyPLPIM8/HdzlOnK4Lq6dUniDp11sj1H
         QIQCl5Snu+EVaeF3fsRgr1mVTSJQkJWXz3bSrgLWacLsmxba2kfI8SyPbBsv1UVX8XG7
         AFBo+IO12pRM6pWZYGEiCh8RbOj00jSmhDwUfRQioAmQHV4gjlD2b3Kty1mCgu2u5cA7
         BDxPdQ/+u8/jUEFnwqh1mDoYmPN3mn/e7Krt1+fWlYr2P9yhY9O4sRha0Qf+sLza4Pt+
         LUOG+g67siMrlH0tCkJCAWvNdulh+5f7iltlUKUJx/Eu/HIkDa3CyseNXKdnmDdpo9sU
         35Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vb21OqFItnARQwQltnaJpDPq8jZArDQHYRbPDYS57rE=;
        b=DxB+ejPQ4AfSptmlRhD0YPurynDdy2DVB3CJqwzKDCO1+AqanWGtAZtPFOpJoKWGPQ
         53bIdAr7zbWMiTqwpO4tOaIkjp181vlT3sO9G/sa/bdZv1RsLH/sWFiGTUbCSmYKKAwG
         GCyGk8YveALQwvJKS3N0J2YbdxsV/3n6nl2m7PodeS/Sh2LHB14M3gwrAmRTAEf/IbMA
         ZYXV7VAI68WCZXGh8gBhCXAhSDxBaMFFm24xzKuVOmsDQEUUf6wDOBETJT7S2XETqG5/
         W1yt4YVoRIyOttwD7avNU5IKKjt2Gp+fgOhkl1gi/ER6lYDkDKb4pYBDg100xQo8IntZ
         39yQ==
X-Gm-Message-State: AOAM531YGxl3+Sm5I6rfKF4Xc4Na5TE2dShZ4wYgrbWhE0nCYC6tEmDi
        SrqEZmWSixbNo4I8wirDS6c=
X-Google-Smtp-Source: ABdhPJyaFzR2HSS/DXxc709iIAXDDQpaBH5Eqkyjl39JF4KC4CYZTZ1c2uMOUqEOeFZZ1UqNxtCOTA==
X-Received: by 2002:a63:d10a:: with SMTP id k10mr23117533pgg.382.1595915648895;
        Mon, 27 Jul 2020 22:54:08 -0700 (PDT)
Received: from nebula (035-132-134-040.res.spectrum.com. [35.132.134.40])
        by smtp.gmail.com with ESMTPSA id bx18sm1455776pjb.49.2020.07.27.22.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 22:54:08 -0700 (PDT)
Message-ID: <2ba95cf58c6f72279dc42a2ccbd65a00abeeac95.camel@gmail.com>
Subject: Re: [PATCH iproute2] tc: Add space after format specifier
From:   Briana Oursler <briana.oursler@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Petr Machata <petrm@mellanox.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
Date:   Mon, 27 Jul 2020 22:53:50 -0700
In-Reply-To: <20200728052048.7485-1-briana.oursler@gmail.com>
References: <20200727164714.6ee94a11@hermes.lan>
         <20200728052048.7485-1-briana.oursler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-27 at 22:20 -0700, Briana Oursler wrote:
> Add space after format specifier in print_string call. Fixes broken
> qdisc tests within tdc testing suite. Per suggestion from Petr
> Machata,
> remove a space and change spacing in tc/q_event.c to complete the
> fix.
> 
> Tested fix in tdc using:
> ./tdc.py -c qdisc
> 
> All qdisc RED tests return ok.
> 
> Fixes: d0e450438571("tc: q_red: Add support for
> qevents "mark" and "early_drop")
> 
> Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
> ---
>  tc/q_red.c     | 4 ++--
>  tc/tc_qevent.c | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/tc/q_red.c b/tc/q_red.c
> index dfef1bf8..df788f8f 100644
> --- a/tc/q_red.c
> +++ b/tc/q_red.c
> @@ -222,12 +222,12 @@ static int red_print_opt(struct qdisc_util *qu,
> FILE *f, struct rtattr *opt)
>  	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
>  	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt-
> >qth_min, b2));
>  	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
> -	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt-
> >qth_max, b3));
> +	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt-
> >qth_max, b3));
>  
>  	tc_red_print_flags(qopt->flags);
>  
>  	if (show_details) {
> -		print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
> +		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
>  		if (max_P)
>  			print_float(PRINT_ANY, "probability",
>  				    "probability %lg ", max_P / pow(2,
> 32));
> diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
> index 2c010fcf..34568070 100644
> --- a/tc/tc_qevent.c
> +++ b/tc/tc_qevent.c
> @@ -82,8 +82,9 @@ void qevents_print(struct qevent_util *qevents,
> FILE *f)
>  			}
>  
>  			open_json_object(NULL);
> -			print_string(PRINT_ANY, "kind", " qevent %s",
> qevents->id);
> +			print_string(PRINT_ANY, "kind", "qevent %s",
> qevents->id);
>  			qevents->print_qevent(qevents, f);
> +			print_string(PRINT_FP, NULL, "%s", " ");
>  			close_json_object();
>  		}
>  	}

I made the subject PATCH iproute2 after the question discussion with
everyone, but I realized that the patch it fixes is in iproute2-next
but not yet in iproute2. Sorry about the confusion. Should I resend to
iproute2-next?

