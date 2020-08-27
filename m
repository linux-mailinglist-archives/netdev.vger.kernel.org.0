Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C99254B94
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgH0RGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgH0RGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 13:06:38 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F77C061264;
        Thu, 27 Aug 2020 10:06:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b79so5154334wmb.4;
        Thu, 27 Aug 2020 10:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/fFA1WLpHbnNTNwIh9B2EeU8KTOzhsZgTvYscZeUWFg=;
        b=HGhCur1mL4dshQkU9byv+6eK1rO2nm7oO/8OP4K75mn6WMyTdMUeeIKbbnVdQFJvB4
         cQZQ7Veom8LgedeStKQFIh9smUbJasu/TX/jSNoprLsC+ipaidHMGmEqZD7Ko11/X0+x
         7lVh78IbsEIYOE6zpRcTCaWB1tHQLit4ddogoszLPZXZZyWBsbpsVCOuc0DxES51FJUd
         OxwHwXlarzXo76tuWI91YYfURGnCAn2LjLqwjj/JWNgTIwea+Vy/5QDQmGlawwUHSrrA
         3nJUd9jcf93VCqw/EYGU5oQUUgFMtIbEEKWYvxfg7mP7blU6FI94S0gqsjUTjldDkaFs
         kCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/fFA1WLpHbnNTNwIh9B2EeU8KTOzhsZgTvYscZeUWFg=;
        b=G97vgbrWHUgCUFBlGESN4Lw9NTvjXd5gdatld6CdxgBM+8kL3HbWxGVsNmf0yBRU0F
         IRwApPXmOtBd7D0DeEoHTf3sUgmpW/s9/1PLj5+ww57pSwdiZg3/IvR4fRbJpLSH0qTP
         6CLxPPZNYvNqJJ0PM4/xa1zR8wGoPACnB/LQqs2mhdqfpQ1/xBulddd4aqWniR7v2tcc
         UxbdPfEyDsgAkxp++Ib2mIVSBT9AbLzQEijc/CkRB6m3y+Mx0lvqTnYvU+sPv9/l3mBH
         GfKoKZmQpzCKiwPlC4mccXrRn4z1AB0xYtyZgr2RtHJqedtPuDrR/Acr9B8BquQvUdqD
         8nAA==
X-Gm-Message-State: AOAM533/JT+NC0T9c3ayYTMQY62iwyPs8I+BIz5rnl8CWCS/fwEeLNrz
        /lN6h7eBh0pGAd04yM7FQ9y18I3rBhPmFEt0
X-Google-Smtp-Source: ABdhPJxMurd9bLa/1v0D1EHiQ6jIp4qAvIxdw+FCd+eRWkUKmFnA6sFqkDDsUT+hEcqkUxDDpW1ZUA==
X-Received: by 2002:a7b:c0c8:: with SMTP id s8mr12206518wmh.72.1598547996825;
        Thu, 27 Aug 2020 10:06:36 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id 22sm5792136wmk.10.2020.08.27.10.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 10:06:36 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Thu, 27 Aug 2020 18:06:34 +0100
To:     Paul Moore <paul@paul-moore.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] netlabel: remove unused param from audit_log_format()
Message-ID: <20200827170634.wogybzcxux7sgefb@medion>
References: <20200827163712.106303-1-alex.dewar90@gmail.com>
 <CAHC9VhRgi54TXae1Wi+SSzkuy9BL7HH=pZCHL1p215M9ZXKEOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRgi54TXae1Wi+SSzkuy9BL7HH=pZCHL1p215M9ZXKEOA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 01:00:58PM -0400, Paul Moore wrote:
> On Thu, Aug 27, 2020 at 12:39 PM Alex Dewar <alex.dewar90@gmail.com> wrote:
> >
> > Commit d3b990b7f327 ("netlabel: fix problems with mapping removal")
> > added a check to return an error if ret_val != 0, before ret_val is
> > later used in a log message. Now it will unconditionally print "...
> > res=0". So don't print res anymore.
> >
> > Addresses-Coverity: ("Dead code")
> > Fixes: d3b990b7f327 ("netlabel: fix problems with mapping removal")
> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > ---
> >
> > I wasn't sure whether it was intended that something other than ret_val
> > be printed in the log, so that's why I'm sending this as an RFC.
> 
> It's intentional for a couple of reasons:
> 
> * The people who care about audit logs like to see success/fail (e.g.
> "res=X") for audit events/records, so printing this out gives them the
> warm fuzzies.
> 
> * For a lot of awful reasons that I won't bore you with, we really
> don't want to add/remove fields in the middle of an audit record so we
> pretty much need to keep the "res=0" there even if it seems a bit
> redundant.
> 
> So NACK from me, but thanks for paying attention just the same :)

Would you rather just have an explicit "res=0" in there, without looking
at ret_val? The thing is that ret_val will *always* be zero at this point in
the code, because, if not, the function will already have returned.
That's why Coverity flagged it up as a redundant check.

> 
> >  net/netlabel/netlabel_domainhash.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
> > index f73a8382c275..526762b2f3a9 100644
> > --- a/net/netlabel/netlabel_domainhash.c
> > +++ b/net/netlabel/netlabel_domainhash.c
> > @@ -612,9 +612,8 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
> >         audit_buf = netlbl_audit_start_common(AUDIT_MAC_MAP_DEL, audit_info);
> >         if (audit_buf != NULL) {
> >                 audit_log_format(audit_buf,
> > -                                " nlbl_domain=%s res=%u",
> > -                                entry->domain ? entry->domain : "(default)",
> > -                                ret_val == 0 ? 1 : 0);
> > +                                " nlbl_domain=%s",
> > +                                entry->domain ? entry->domain : "(default)");
> >                 audit_log_end(audit_buf);
> >         }
> >
> 
> -- 
> paul moore
> www.paul-moore.com
