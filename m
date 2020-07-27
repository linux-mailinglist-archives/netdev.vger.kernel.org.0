Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876B222FA2F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgG0Uhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgG0Uhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 16:37:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79204C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 13:37:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z5so10603644pgb.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 13:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iYO9TjwOJSBaFSmBVm/ApHPrs2/MEZADWea4D2t+VOA=;
        b=LQtjhILjp6R1W0qJF14TY81PwHb9zkH10r2BMLwtfOUifM+OGJ4vsCyEoou42d/Cku
         AdLwpT2HMB7hRI0aAhe/WxTy0/TZadWm9BpUDHaOqdB8ZE0PAHutKWCxlVBlCBbiavnk
         9USxHfKz3BFlUocWxPkOTGipTcajnrT6o01RezLjJENELmjU1irkxFVHfzjKx4tpbwjN
         XQZa+Mod88CfFXQcfH14zA2SUY4JjgbftJGiRAqZOrD0oev1txWoydxeC09khsQgdD62
         XvSoWofiUCW7wvZqVI2679jWN1ipMufo2RrDFcOQ9URPd65rilxw6CWawkl0W1LR4Shr
         OaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iYO9TjwOJSBaFSmBVm/ApHPrs2/MEZADWea4D2t+VOA=;
        b=EQJMX5vYe98ZfXlAm+vxrwrqGycE3gkA5K8L4IfErj80ZcGfO/t5EXjWTOuKstGGQo
         qLhSjSk8knusCln5IQ7vCKXCEZxJXSVksNIg7qqPvIpnSrYxZH4q/nqR0jizWehrom57
         OabIO2fqKFZKvXEpMoPTDRJyhzffAs+v3+ysaapT1XB4w6ntDqZtW1HrQy0etumzX0ay
         URGIcNFKUHxqyMAjTDLblLRhwLIlnoZ+/fhYvOdXXT2hGJ6tk5xHNNWoIdxGcA8lC2gd
         SxwZIxcENHe86fcuMcp4z6L7NnMZwjkqnPPICJf9DxqtzB38TxoGUvaVpPPyzojPD0bn
         x+WA==
X-Gm-Message-State: AOAM533DWB+z/oEJPSY0+5vn81RaSIi8g3RGV7NTfD/rY+4p4povgKsB
        bw0gpWHt4nIuMP/7l5sGyJb4uw==
X-Google-Smtp-Source: ABdhPJwRrhVBsPDgJDQyonWzT4HO61G5pvhEKFmnbCLMrRU7kkUdcUf6wZR2/OPVQVLpZQdUKI/VcQ==
X-Received: by 2002:a05:6a00:2bb:: with SMTP id q27mr22722031pfs.176.1595882254930;
        Mon, 27 Jul 2020 13:37:34 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v3sm16649023pfb.207.2020.07.27.13.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 13:37:34 -0700 (PDT)
Date:   Mon, 27 Jul 2020 13:37:30 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Briana Oursler <briana.oursler@gmail.com>, netdev@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: Question Print Formatting iproute2
Message-ID: <20200727133730.344d583e@hermes.lan>
In-Reply-To: <87wo2ohi07.fsf@mellanox.com>
References: <20200727044616.735-1-briana.oursler@gmail.com>
        <87wo2ohi07.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 21:31:36 +0200
Petr Machata <petrm@mellanox.com> wrote:

> Briana Oursler <briana.oursler@gmail.com> writes:
>=20
> > I git bisected and found d0e450438571("tc: q_red: Add support for
> > qevents "mark" and "early_drop"), the commit that introduced the
> > formatting change causing the break.
> >
> > -       print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_m=
ax, b3));
> > +       print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_ma=
x, b3));
> >
> > I made a patch that adds a space after the format specifier in the
> > iproute2 tc/q_red.c and tested it using: tdc.py -c qdisc. After the
> > change, all the broken tdc qdisc red tests return ok. I'm including the
> > patch under the scissors line.
> >
> > I wanted to ask the ML if adding the space after the specifier is prefe=
rred usage.
> > The commit also had:
> >  -               print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
> >  +               print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
> >
> > so I wanted to check with everyone. =20
>=20
> Yeah, I outsmarted myself with those space changes. Those two chunks
> need reversing, and qevents need to have the space changed. This should
> work:
>=20
> modified	  tc/q_red.c
> @@ -222,12 +222,12 @@ static int red_print_opt(struct qdisc_util *qu, FIL=
E *f, struct rtattr *opt)
>  	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
>  	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt->qth_min, b2));
>  	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
> -	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
> +	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
>=20
>  	tc_red_print_flags(qopt->flags);
>=20
>  	if (show_details) {
> -		print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
> +		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
>  		if (max_P)
>  			print_float(PRINT_ANY, "probability",
>  				    "probability %lg ", max_P / pow(2, 32));
> modified	  tc/tc_qevent.c
> @@ -82,8 +82,9 @@ void qevents_print(struct qevent_util *qevents, FILE *f)
>  			}
>=20
>  			open_json_object(NULL);
> -			print_string(PRINT_ANY, "kind", " qevent %s", qevents->id);
> +			print_string(PRINT_ANY, "kind", "qevent %s", qevents->id);
>  			qevents->print_qevent(qevents, f);
> +			print_string(PRINT_FP, NULL, "%s", " ");
>  			close_json_object();
>  		}
>  	}
>=20
> Are you going to take care of this, or should I?

Missing spaces makes it impossible to read adding extra spaces is annoying,=
=20
=46rom a long term perspective it is better if anything that is trying to
parse output pro grammatically should use JSON output format. With JSON
it is easier to handle new data and not as dependent on ordering.
Plus if some tests used JSON, maybe the issues would be found sooner.
