Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F5DE4210
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404134AbfJYDXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:23:44 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40528 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404099AbfJYDXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:23:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id y81so488960qkb.7;
        Thu, 24 Oct 2019 20:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mF+E+Kulq/U+/4Iw09P1PnKHPZ8m7Hs14KSqIJvXQ3Y=;
        b=Xx35ycOiSBhhWraVPruZTqVaMS2thWkF68FRAHwwQcaeGeH2W+wQc9jzv3vFArrqG4
         PFtluEsQ+Vllc36YoijqOG3P57Xqg2QciQPqREr23pay86jemEBPHX0fxqf/6sg7rxWQ
         cbEOPeWB6njE4S4UfGIEimhDZWR5SOWAqeiibS6lntOcV1hqPJpdB4xVhUgUfUeY+FW+
         i/5f8jAqq2hHr6z9KZxl1OnjK5wSC4/KjY2tgfYs2O7Ua3dUxGka4xaiMYI441g893VA
         FJveSTxGFh1IX3vOUgmiluN6hXG1+0A4nYrDI3cT0fdVIEFtmWyuWizxCAqmzBuDLks2
         d4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mF+E+Kulq/U+/4Iw09P1PnKHPZ8m7Hs14KSqIJvXQ3Y=;
        b=iLC7MhaqIF+y/fZo7gto/6gGgmVbXCUkGfrpVmiPhHAbKdYDE+mHy2QUonncvVGklq
         3zkdM+UOGipmWrodB/2dtCWgx4qpsECvGY/dpEBU1eeRDyqYMUOOE3WelT47V9SXOjkW
         rGz4MCQQBud3JL/T/uxn2PzmaTg9UGNqSy2u9A1cyu/j/Dv061tDtY0il9jR/fvDPHqG
         BsAfcvFRLNldRCi/rPrthFVn4k1OTUG62sXpRg7jTrqdrPx/Y+Vw8oIUjIOKZXhszySO
         qBi5RMIREIwruFHroTM3/rSFe/KlOHkCkfdtECrhbxMTvVAR1Mm2Lu7LY+9cPGsks9TO
         g1GQ==
X-Gm-Message-State: APjAAAWcOTmoJomxwQv7/c+m6ZcOHt3wCbPQeAoTVXDqq/nDt+5LEyUa
        5v/GoXSizIo9LV0HD08tITA=
X-Google-Smtp-Source: APXvYqzX84HtjiiwE9KK0K+pthTGWHO5i8wCDcSraLGy9cnWHUYH8GU8GvMsP/vb+JZvUEZMDP6MFw==
X-Received: by 2002:a37:5d06:: with SMTP id r6mr1062680qkb.16.1571973820911;
        Thu, 24 Oct 2019 20:23:40 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:4432:ec84:3b11:57ab:7f98])
        by smtp.gmail.com with ESMTPSA id c21sm485998qtg.61.2019.10.24.20.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 20:23:40 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id AFED9C0AD9; Fri, 25 Oct 2019 00:23:37 -0300 (-03)
Date:   Fri, 25 Oct 2019 00:23:37 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: Re: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock
 and asoc
Message-ID: <20191025032337.GC4326@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 02:14:45PM +0800, Xin Long wrote:
> As said in rfc7829, section 3, point 12:
> 
>   The SCTP stack SHOULD expose the PF state of its destination
>   addresses to the ULP as well as provide the means to notify the
>   ULP of state transitions of its destination addresses from
>   active to PF, and vice versa.  However, it is recommended that
>   an SCTP stack implementing SCTP-PF also allows for the ULP to be
>   kept ignorant of the PF state of its destinations and the
>   associated state transitions, thus allowing for retention of the
>   simpler state transition model of [RFC4960] in the ULP.
> 
> Not only does it allow to expose the PF state to ULP, but also
> allow to ignore sctp-pf to ULP.
> 
> So this patch is to add pf_expose per netns, sock and asoc. And in
> sctp_assoc_control_transport(), ulp_notify will be set to false if
> asoc->expose is not set.
> 
> It also allows a user to change pf_expose per netns by sysctl, and
> pf_expose per sock and asoc will be initialized with it.

I also do see value on this sysctl. We currently have an
implementation that sits in between the states that the RFC defines
and this allows the system to remain using the original Linux
behavior, while also forcing especially the disabled state. This can
help on porting applications to Linux.

> 
> Note that pf_expose also works for SCTP_GET_PEER_ADDR_INFO sockopt,
> to not allow a user to query the state of a sctp-pf peer address
> when pf_expose is not enabled, as said in section 7.3.
> 
> v1->v2:
>   - Fix a build warning noticed by Nathan Chancellor.
> v2->v3:
>   - set pf_expose to UNUSED by default to keep compatible with old
>     applications.

Hmmm UNUSED can be quite confusing.
What about "UNSET" instead? (though I'm not that happy with UNSET
either, but couldn't come up with a better name)
And make UNSET=0. (first on the enum)

So we have it like:
"If unset, the exposure is done as Linux used to do it, while setting
it to 1 blocks it and 2, enables it, according to the RFC."

Needs a new entry on Documentation/ip-sysctl.txt, btw. We have
pf_enable in there.

...

> @@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
>  
>  	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
>  					   pinfo.spinfo_assoc_id);
> -	if (!transport)
> -		return -EINVAL;
> +	if (!transport) {
> +		retval = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (transport->state == SCTP_PF &&
> +	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
> +		retval = -EACCES;
> +		goto out;
> +	}

As is on v3, this is NOT an UAPI violation. The user has to explicitly
set the system or the socket into the disabled state in order to
trigger this new check.

>  
>  	pinfo.spinfo_assoc_id = sctp_assoc2id(transport->asoc);
>  	pinfo.spinfo_state = transport->state;
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index 238cf17..5d1ad44 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -34,6 +34,7 @@ static int rto_alpha_min = 0;
>  static int rto_beta_min = 0;
>  static int rto_alpha_max = 1000;
>  static int rto_beta_max = 1000;
> +static int pf_expose_max = SCTP_PF_EXPOSE_MAX;
>  
>  static unsigned long max_autoclose_min = 0;
>  static unsigned long max_autoclose_max =
> @@ -318,6 +319,15 @@ static struct ctl_table sctp_net_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "pf_expose",
> +		.data		= &init_net.sctp.pf_expose,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= &pf_expose_max,
> +	},
>  
>  	{ /* sentinel */ }
>  };
> -- 
> 2.1.0
> 
