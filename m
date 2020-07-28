Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0A1230080
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgG1EN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgG1EN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 00:13:29 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C51C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 21:13:28 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id z3so10198027pfn.12
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 21:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Y26xJDtu4q7AcJbx3x9ynvIADYjKmM/hY1zylCYulRU=;
        b=LIhGz4qL/F+tlIX7hEfEj4X5JBe808hkE4e7Cz6Yc4gr8IyR2JIkOtrVbFSchgPBzW
         oaZoExmE2pc7TZU3jF6TL89i8FjZgW8gD1DKHbxWQBYkTmKlyLemjTSyDBXmqwRgOf2b
         eDs/33CAroZg4r1w53cjJMviHygH77eao0CXGW6fQpH9OWXrx5/oTv7bM8DU3M5ecRlq
         GeY3bvYes2hbHI3+uFnTnX9kfrMESMldGdL9qTIwSG/Y5j0OAw+Jt1IZEPz0HD+6qez2
         xOJg6LDeQIMUCSS3svCe3okTsb741p93Gzruh6bK5CjwTe7CJzSD6OYLQ7wI/fS+f65G
         SUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Y26xJDtu4q7AcJbx3x9ynvIADYjKmM/hY1zylCYulRU=;
        b=I58JC/H/MuXGyz+yKHE65USV6ym5rFKPA27JmaaXX+AvQQG5eRe7HhYJJOQ/SR+4nh
         kKMbeCNMM+Dt/1iyEcI00CFNe6iDmEzag5MrgxXiviYPmfdSO77q75a+0I/RjlQt2KmX
         LzbHyy+8CrTnCNK0NJHSY4Ung0sFwg1cWavLd6u6bTq5z/Z9mnELzPD/wNJnwntyMYKY
         CfYoK9diHYboOtuAUvGa0mg7CFRz9Yu2lM7QRaswEzo+h14Z+qmuqqJEg+xnLlORuiEd
         JEIGZolKr+Rpl/YCkdj56s1ilfx0QzPoHFTwQW2cekyESkHHLAfRN7GUrekgdRX9DwO4
         d5BA==
X-Gm-Message-State: AOAM532I6TZDBvF3SHRngU8RILUEZO9QPP3qQOujFETTROQNw6VzA5Su
        UXxhfrcefcoQjdU12u4dNfE=
X-Google-Smtp-Source: ABdhPJw08Q0H7UA7DbrQ4XmmyL0LDQLixwgdnaifxvYW1NjNGwlsntBc+MOZV963lCSbnFSiZXeQPA==
X-Received: by 2002:a62:cd0c:: with SMTP id o12mr22688063pfg.70.1595909607898;
        Mon, 27 Jul 2020 21:13:27 -0700 (PDT)
Received: from nebula (035-132-134-040.res.spectrum.com. [35.132.134.40])
        by smtp.gmail.com with ESMTPSA id w16sm1192704pjd.50.2020.07.27.21.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 21:13:27 -0700 (PDT)
Message-ID: <03088b77a44bbe9694ad3b337d0106b1df3fd449.camel@gmail.com>
Subject: Re: Question Print Formatting iproute2
From:   Briana Oursler <briana.oursler@gmail.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
Date:   Mon, 27 Jul 2020 21:12:54 -0700
In-Reply-To: <87wo2ohi07.fsf@mellanox.com>
References: <20200727044616.735-1-briana.oursler@gmail.com>
         <87wo2ohi07.fsf@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-27 at 21:31 +0200, Petr Machata wrote:
> Briana Oursler <briana.oursler@gmail.com> writes:
> 
> > I git bisected and found d0e450438571("tc: q_red: Add support for
> > qevents "mark" and "early_drop"), the commit that introduced the
> > formatting change causing the break.
> > 
> > -       print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt-
> > >qth_max, b3));
> > +       print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt-
> > >qth_max, b3));
> > 
> > I made a patch that adds a space after the format specifier in the
> > iproute2 tc/q_red.c and tested it using: tdc.py -c qdisc. After the
> > change, all the broken tdc qdisc red tests return ok. I'm including
> > the
> > patch under the scissors line.
> > 
> > I wanted to ask the ML if adding the space after the specifier is
> > preferred usage.
> > The commit also had:
> >  -               print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt-
> > >Wlog);
> >  +               print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt-
> > >Wlog);
> > 
> > so I wanted to check with everyone.
> 
> Yeah, I outsmarted myself with those space changes. Those two chunks
> need reversing, and qevents need to have the space changed. This
> should
> work:
> 
Thank you for the response. I see what you are saying. I had not seen
the qevents, I'll put all 3 in.

> modified	  tc/q_red.c
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
> modified	  tc/tc_qevent.c
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
> 
> Are you going to take care of this, or should I?

I will, I'll amend the commit I included so it will have the other
changes you suggest and send as a regular patch. 

