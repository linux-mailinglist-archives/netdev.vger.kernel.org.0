Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62502254BF0
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgH0RUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgH0RUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 13:20:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B77AC061264;
        Thu, 27 Aug 2020 10:20:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t2so5911487wma.0;
        Thu, 27 Aug 2020 10:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qPzfWQyO8ZKoNnlsZry2pD1TDViebKl3N80Cpi3LHjU=;
        b=uUZl8zMTtihRqQsz4gBJGEgvEf5Zq5lvFj/4ZdmwjCUkbcYJC1JdN2DzavNp1LKNBD
         Ixr3ql0Jpl6EyJyyVY7tfBrZEJwB4ZS+iIzQB7cJztZRtXEYuwz/fOxfcULcIwB2adxM
         zsXbe2pdS9VEgC9ZVchN8Nitc6dN+xpTB15k6G99AOTH2dIgGSloNxTa+dZ7uo/zHUnk
         kuLhL9fZza2PBXazblTnUQuNUK/7XQqhO3VSK8VGLA2OoOKtOJqRQkcM26w5KfCn7YCS
         DDLNXk+XYjljtcz3Fs3V9eoXANNjCcuoqb69A6oguNI3hZgD6nbA9pb/YHWWGe8oDy1v
         vzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qPzfWQyO8ZKoNnlsZry2pD1TDViebKl3N80Cpi3LHjU=;
        b=N6SPzc8CBsdVCb9uQClBjc7Ekd2bNjJiEQ8HBsxPob5SxsrTiNyFm+sNM1UMTeKOBJ
         DiiBnkGT+0hBBNLQmEAVjsbrlCC4FEgDW3LMMGRLWZ5/oHQqtzEy3GH8S86PXNFeHbl0
         3kfYLRC0S3fjVAnxJ3jhHubgzJnBUAz1tyv6W87WQ/81fK2UVh+UgwUREpShPXNK68S3
         bW4YX/8gLgSTd+zSXs5inBUXJ0DjDIm5BE2VumXg+pedcvE74HGHAkYFcMjPuvqvdOoP
         Jvm1I/yBFuMArUbqeeqXaT7fR79FgzOkSmiqncOtATEPNT19zFGId/zRay6qE4OKyN8d
         vDHA==
X-Gm-Message-State: AOAM533r+9oRPAfD6F67jWiem/O8Z9JukSoFxLsATXHHeiByJD/rp8C4
        9tnO7h4D6tiJLBGLVKTQE1M=
X-Google-Smtp-Source: ABdhPJxhATxQqFdUH4qNQi4vx9VSHG0W0+jNHTBZWQNVpbQRI5dqPQ06C7MWgfWWLfj/hnjEsJXing==
X-Received: by 2002:a1c:2808:: with SMTP id o8mr12238734wmo.108.1598548809699;
        Thu, 27 Aug 2020 10:20:09 -0700 (PDT)
Received: from medion (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id v11sm7003911wrr.10.2020.08.27.10.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 10:20:09 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
X-Google-Original-From: Alex Dewar <alex.dewar@gmx.co.uk>
Date:   Thu, 27 Aug 2020 18:20:06 +0100
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] netlabel: remove unused param from audit_log_format()
Message-ID: <20200827172006.gudui4alfbbf2a2p@medion>
References: <20200827163712.106303-1-alex.dewar90@gmail.com>
 <CAHC9VhRgi54TXae1Wi+SSzkuy9BL7HH=pZCHL1p215M9ZXKEOA@mail.gmail.com>
 <20200827170634.wogybzcxux7sgefb@medion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827170634.wogybzcxux7sgefb@medion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 06:06:34PM +0100, Alex Dewar wrote:
> On Thu, Aug 27, 2020 at 01:00:58PM -0400, Paul Moore wrote:
> > On Thu, Aug 27, 2020 at 12:39 PM Alex Dewar <alex.dewar90@gmail.com> wrote:
> > >
> > > Commit d3b990b7f327 ("netlabel: fix problems with mapping removal")
> > > added a check to return an error if ret_val != 0, before ret_val is
> > > later used in a log message. Now it will unconditionally print "...
> > > res=0". So don't print res anymore.
> > >
> > > Addresses-Coverity: ("Dead code")
> > > Fixes: d3b990b7f327 ("netlabel: fix problems with mapping removal")
> > > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > > ---
> > >
> > > I wasn't sure whether it was intended that something other than ret_val
> > > be printed in the log, so that's why I'm sending this as an RFC.
> > 
> > It's intentional for a couple of reasons:
> > 
> > * The people who care about audit logs like to see success/fail (e.g.
> > "res=X") for audit events/records, so printing this out gives them the
> > warm fuzzies.
> > 
> > * For a lot of awful reasons that I won't bore you with, we really
> > don't want to add/remove fields in the middle of an audit record so we
> > pretty much need to keep the "res=0" there even if it seems a bit
> > redundant.
> > 
> > So NACK from me, but thanks for paying attention just the same :)
> 
> Would you rather just have an explicit "res=0" in there, without looking
> at ret_val? The thing is that ret_val will *always* be zero at this point in
> the code, because, if not, the function will already have returned.
> That's why Coverity flagged it up as a redundant check.

Sorry, I meant "res=1". The code will always print res=1, because
ret_val is always 0.
> 
> > 
> > >  net/netlabel/netlabel_domainhash.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
> > > index f73a8382c275..526762b2f3a9 100644
> > > --- a/net/netlabel/netlabel_domainhash.c
> > > +++ b/net/netlabel/netlabel_domainhash.c
> > > @@ -612,9 +612,8 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
> > >         audit_buf = netlbl_audit_start_common(AUDIT_MAC_MAP_DEL, audit_info);
> > >         if (audit_buf != NULL) {
> > >                 audit_log_format(audit_buf,
> > > -                                " nlbl_domain=%s res=%u",
> > > -                                entry->domain ? entry->domain : "(default)",
> > > -                                ret_val == 0 ? 1 : 0);
> > > +                                " nlbl_domain=%s",
> > > +                                entry->domain ? entry->domain : "(default)");
> > >                 audit_log_end(audit_buf);
> > >         }
> > >
> > 
> > -- 
> > paul moore
> > www.paul-moore.com
