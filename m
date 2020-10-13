Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0028C6B6
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 03:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgJMBSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 21:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgJMBSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 21:18:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536DFC0613D0;
        Mon, 12 Oct 2020 18:18:16 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so12868546pfa.9;
        Mon, 12 Oct 2020 18:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/9A0K1IzOHna1C0DxmV3XpbQqnDKqQQDF6op5A/lIOE=;
        b=Yo4t8KHitl7IijBwyBzbt+gmWaEcnfLB3k5bFe3RMkLOZGpv7uckNpQTdsfI1voSeo
         j/+15lQPSXGjI3uFic49xOYnjSCdFWRGO/fT1AtPB0eI6zk92pqx5ehhY4xJnk3rVALk
         ddkysd6k7Q3qCTPL299gXm2zoy8Kak3S5Qo60VN7TKbhWfirdSGdLmOYgPgv4y+qkCvd
         50S6QKUxR8Ey/wFnaMDDtatK4M6BZ24Yq9Xg1iPO5LbguUw3ygoT9MF454psQy7MW2gC
         urQ1gJaKpQ8XbW/mk+PZh0gmOZTST/vFP1P7F3zPSmNF1ceNYj1OHrCi+hoMbfMfWtC9
         GRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/9A0K1IzOHna1C0DxmV3XpbQqnDKqQQDF6op5A/lIOE=;
        b=YzmcsiHJtCDnyqYQzSDudV5aCY0Vf7UZ18i7+as5ZSpBqjIgd3b70o9u5Lume6oqCh
         CPyJCjxNruTT1CygCkCHkt4RqknMzEV3U1LyFKgoQXaBzFE07fyiYCBI1wcXP+wlHgWO
         +GN8v9n9RTpFrVrfktd9t0lD/OAyU0/JaskqYngo/U3olcN84uaA4zEd28H9oik6KKsA
         VD/7OsO+kVpVQKbSAzGeX7Wk9bvGDSDzyq9Plf6U+31D5eQuyQRK6jHKr5JCy6GtHNQg
         /z5mr2Z53a3uFvw32ZHkZWfN2uCfO9oaF4XQaF9qUd/lLP9n3BuaDDiaGTnD7fBy6MUt
         kLjw==
X-Gm-Message-State: AOAM5300XwAyQPLR5c4xV89Jfw08RAUCvZZnshNLl21G4cgxYKXV7R3s
        RtW/B/ZNMCrZEjQRAGwm9QOllhEgShJ/uw==
X-Google-Smtp-Source: ABdhPJwm1/3VSrSwzuGk4/Zydbtvz11dFFE2Xj3zygfVfOXds4aeHb7HYdhqd+iRm1poALRR9DjznQ==
X-Received: by 2002:a17:90b:17c4:: with SMTP id me4mr21967291pjb.91.1602551895798;
        Mon, 12 Oct 2020 18:18:15 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id b6sm24476508pjq.42.2020.10.12.18.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 18:18:14 -0700 (PDT)
Date:   Tue, 13 Oct 2020 10:18:10 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/6] staging: qlge: coredump via devlink health
 reporter
Message-ID: <20201013011810.GB41031@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-3-coiby.xu@gmail.com>
 <20201010074809.GB14495@f3>
 <20201010100258.px2go6nugsfbwoq7@Rk>
 <20201010132230.GA17351@f3>
 <20201012115114.lyh33rvmm4rt7mej@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012115114.lyh33rvmm4rt7mej@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-12 19:51 +0800, Coiby Xu wrote:
> On Sat, Oct 10, 2020 at 10:22:30PM +0900, Benjamin Poirier wrote:
> > On 2020-10-10 18:02 +0800, Coiby Xu wrote:
> > [...]
> > > > > +	do {                                                           \
> > > > > +		err = fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
> > > > > +		if (err) {					       \
> > > > > +			kvfree(dump);                                  \
> > > > > +			return err;				       \
> > > > > +		}                                                      \
> > > > > +	} while (0)
> > > > > +
> > > > > +static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
> > > > > +				  struct devlink_fmsg *fmsg, void *priv_ctx,
> > > > > +				  struct netlink_ext_ack *extack)
> > > > > +{
> > > > > +	int err = 0;
> > > > > +
> > > > > +	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);
> > > >
> > > > Please name this variable ql_devlink, like in qlge_probe().
> > > 
> > > I happened to find the following text in drivers/staging/qlge/TODO
> > > > * in terms of namespace, the driver uses either qlge_, ql_ (used by
> > > >  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
> > > >  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
> > > >  prefix.
> > 
> > This comment applies to global identifiers, not local variables.
> 
> Thank you for the explanation! Are you suggesting we should choose
> different naming styles so we better tell global identifiers from local
> variables?

That's not the main purpose IMO. Using a consistent prefix for global
identifiers (ex. "qlge_") is to avoid clashes (two drivers using the
same name, as in the examples above). Strictly speaking, it is not a
problem for symbols with internal linkage (ex. static functions) or type
definitions in local header files but it makes the code clearer because
it shows immediately that this identifier was defined in the driver.

For local variables, the name is more a matter of personal taste I think
but it should be consistent within the driver and with other users of
the same api, where applicable. A prefix is not needed but the name is
sometimes a simpler version of a type name which includes a prefix.

> > > So I will adopt qlge_ instead. Besides I prefer qlge_dl to ql_devlink.
> > 
> > Up to you but personally, I think ql_devlink is better. In any case,
> > "dev" is too general and often used for struct net_device pointers
> > instead.
> 
> Thank you for the suggestion. Another reason to use qlge_dl is many
> other network drivers supporting devlink interface also adopt this kind
> of style.

Sounds good. On second thought I regretted suggesting ql_devlink. While
local variable don't need any prefix; if they do have one, better not
mix qlge_ and ql_.
