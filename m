Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9957E2A7E47
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 13:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgKEMGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 07:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730270AbgKEMGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 07:06:43 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AE8C0613CF;
        Thu,  5 Nov 2020 04:06:43 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id oq3so2242729ejb.7;
        Thu, 05 Nov 2020 04:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Sn/aYlWmXDGmFRHLTMaa0NIVzI9EMOinFodzXgmolWU=;
        b=cjOoTOcu0q40i5XFzBJ2xVgbzc0Ozs9Xuw+h0FTIDtR5bgwzTs1wreNPSu2ad/5k4h
         bZ7AVHEGvNPBmloFk2ysqfv2CvCrEpGe7nbkjva17Ineg5aCK8XxJ2E3NfcnDfsBxnp+
         T0gw8zfTGjG75OYzU9A6BT+EzPYkGi1hiwbG/qqUlHLS0G3eywGBed7xj0fLuSgFVhG2
         vGiiDeKyfVuxS9UVHzUw5FKus1qlPXQnfCHANxcLei1D1/BPIrrJv6da9BMVvZhJPlqS
         RFg8mud35v+uNbJh8jtBdns0thiZPhdI274P6/tpPEJlv+1dfGSlpvoU3i8HrKcrqxAF
         uJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Sn/aYlWmXDGmFRHLTMaa0NIVzI9EMOinFodzXgmolWU=;
        b=AUenuMR9YtiZcst7+L4V///z6qLdsjYznm3BAFBrIrzrfBszmTP16YVqmzo6HZ0GCi
         u7USdsEfgAtj1MOF9Qq+lnHsHtjm2P6lBSD00jglJm+4FQUzW/9J1JGfqzNSUbloLLPK
         HXC8kQew2hzxqVJhBkkk7oZx2bMgJhEHNW0Iar8+ZCg+FOpvpNaGNhibYV/xDKuxtMyZ
         0GSXiRS3errRgHifnc5ygrVdu5UqGpiK8yGwLwMBP39aJWHu3ml1wyYFBZvN+CSVyVrE
         eZ1TS2HS87XPf1WgYMpgaIGKOS+KWiNnzv6+xUHgCntuM3Y0STz2Y/lxNVXqWkisd6wV
         otEQ==
X-Gm-Message-State: AOAM533BOJQEZIGiNCHaL7VdzlfGp/tTze2/z920rcUrZBIUq7JxUGPz
        7d8hKgBtoQYgauA33dCoWTA=
X-Google-Smtp-Source: ABdhPJx0wNJO5bkkdrneALqSB25f5n8OAdtgSA1Ypo3ILc6984/3saechrsqKJqyNd1FNz2dTuN79w==
X-Received: by 2002:a17:906:17d1:: with SMTP id u17mr1825341eje.229.1604578002245;
        Thu, 05 Nov 2020 04:06:42 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id p20sm816136ejd.78.2020.11.05.04.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 04:06:41 -0800 (PST)
Date:   Thu, 5 Nov 2020 14:06:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201105120640.5ltlf4vu5vmkf3xl@skbuf>
References: <20201104065524.36a85743@kernel.org>
 <20201104084710.wr3eq4orjspwqvss@skbuf>
 <20201104112511.78643f6e@kernel.org>
 <20201104113545.0428f3fe@kernel.org>
 <20201104110059.whkku3zlck6spnzj@skbuf>
 <20201104121053.44fae8c7@kernel.org>
 <20201104121424.th4v6b3ucjhro5d3@skbuf>
 <20201105105418.555d6e54@kernel.org>
 <20201105105642.pgdxxlytpindj5fq@skbuf>
 <20201105123043.3b114bec@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201105123043.3b114bec@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 12:30:43PM +0100, Marek Behún wrote:
> On Thu, 5 Nov 2020 12:56:42 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
>
> > On Thu, Nov 05, 2020 at 10:54:18AM +0100, Marek Behún wrote:
> > > I thought that static inline functions are preferred to macros, since
> > > compiler warns better if they are used incorrectly...
> >
> > Citation needed.
>
> Just search for substring "instead of macro" in git log, there are
> multiple such changes that were accepted since it provides better
> typechecking. I am not saying it is documented anywhere, just that I
> thought it was preffered.
>
> > Also, how do static inline functions wrapped in macros
> > (i.e. your patch) stack up against your claim about better warnings?
>
> If they are defined as functions (they don't have to be inline,
> of course) instead of macros and they are used incorrectly, the compiler
> provides more readable warnings. (Yes, in current versions of gcc it is
> much better than in the past, but still there are more lines of
> warnings printed: "in expansion of macro"...).

Ok, but I mean, we're not even in contradiction at this point? I only
provided you macro definitions of pla_ocp_* and usb_ocp_* to prove that
they can be defined in a cleaner way than your attempt. If you still
think it's worth having the pla_ocp_* and usb_ocp_* helpers defined as
separate functions just to avoid passing the extra MCU_TYPE_* argument,
then go ahead.
