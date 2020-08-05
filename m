Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BB723C9D7
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgHEKSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 06:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgHEKSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 06:18:37 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE2BC06174A
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 03:18:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ep8so4052165pjb.3
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 03:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8XMFtEhDtWsiDjWHcjQwp4AWLdGt1gB9lYGAi4kZkYw=;
        b=PceCjXqjS++iOvHdngw24IhA4b/8jA3DwBQ3UcrTwj7k7iK3OHEJAZghqhtug1rIpe
         EojG68gpuUSrxycur4TSFS/mt/P1d6WZ19xrPb4AiqfnKHmUG5vJgaaLXY5cF+j1h0cb
         NTSMI5lJB6DxZtBkLXhxAqLnfSSukbF/dCr5LqSxfpvLfEITdQpB9zBzX3VMnRqzUWi6
         x6WHCXqmtCgbU7AuaKKdosRrM3ztPICsKSgEzsLMzqsT53GhOlGxsekTZM0SDajq/9J8
         VwZcrRgY0xlAafO0s92BghTY9l+nB8EUkgeipQJS31Ab83Pv193QUvvN3TjRBzmHU9rN
         ZLTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8XMFtEhDtWsiDjWHcjQwp4AWLdGt1gB9lYGAi4kZkYw=;
        b=Fyg1JY6yR1dFPRhUFUrVSikXIJ3OXie95/ncya1LO8FlrZ9KLP8ZvT2uNmr2nakyn/
         XsRGJACr6TY1URERMUY80nisvXtyyRcLVoN0SrqTBlYyqahevo4IozS7Uqk/9L6FXnqC
         hP7Qvpefp4ygNCs6NtnN3x7RRit0IWkakOOUjdTJ6nxjoKlQEejkW4HVjy40rfEHD4EZ
         rxs4QbQjU26A7Fsg/XS7lpW3QNvz9/k3IsDECar9owcBaPRLrkg4Cupan7xaBR+MpBLF
         KojxDf/5VnZh7/sL43e6gDSntDHEuJeTbi3O3pEOeWdnPpIdmUXAy1WEB6qgdA9RDvIo
         UgTQ==
X-Gm-Message-State: AOAM530MwcxgikfcYyPYMFufZDOHTJMRDocJz3jV4C9SNtUhwWL8tLeq
        tJfHU/DRGZIzNDKe5UnD2oE=
X-Google-Smtp-Source: ABdhPJzv5+fROAdTfeYiU/YnLTo/4tQjw8Tkj2J8q67CKE/fz35iKN0SMpzuPDb3xS9q+L6rxvzUrg==
X-Received: by 2002:a17:902:820b:: with SMTP id x11mr2287375pln.229.1596622698528;
        Wed, 05 Aug 2020 03:18:18 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u29sm3162618pfl.180.2020.08.05.03.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 03:18:17 -0700 (PDT)
Date:   Wed, 5 Aug 2020 18:18:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Andreas Karis <akaris@redhat.com>
Subject: Re: [PATCH net] Revert "vxlan: fix tos value before xmit"
Message-ID: <20200805101807.GN2531@dhcp-12-153.nay.redhat.com>
References: <20200805024131.2091206-1-liuhangbin@gmail.com>
 <20200805084427.GC11547@pc-2.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805084427.GC11547@pc-2.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 10:44:27AM +0200, Guillaume Nault wrote:
> On Wed, Aug 05, 2020 at 10:41:31AM +0800, Hangbin Liu wrote:
> > This reverts commit 71130f29979c7c7956b040673e6b9d5643003176.
> > 
> > In commit 71130f29979c ("vxlan: fix tos value before xmit") we want to
> > make sure the tos value are filtered by RT_TOS() based on RFC1349.
> > 
> >        0     1     2     3     4     5     6     7
> >     +-----+-----+-----+-----+-----+-----+-----+-----+
> >     |   PRECEDENCE    |          TOS          | MBZ |
> >     +-----+-----+-----+-----+-----+-----+-----+-----+
> > 
> > But RFC1349 has been obsoleted by RFC2474. The new DSCP field defined like
> > 
> >        0     1     2     3     4     5     6     7
> >     +-----+-----+-----+-----+-----+-----+-----+-----+
> >     |          DS FIELD, DSCP           | ECN FIELD |
> >     +-----+-----+-----+-----+-----+-----+-----+-----+
> > 
> > So with
> > 
> > IPTOS_TOS_MASK          0x1E
> > RT_TOS(tos)		((tos)&IPTOS_TOS_MASK)
> > 
> > the first 3 bits DSCP info will get lost.
> > 
> > To take all the DSCP info in xmit, we should revert the patch and just push
> > all tos bits to ip_tunnel_ecn_encap(), which will handling ECN field later.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> I guess an explicit
> Fixes: 71130f29979c ("vxlan: fix tos value before xmit").
> tag would help the -stable maintainers.
> 
> Apart from that,
> Acked-by: Guillaume Nault <gnault@redhat.com>
> 

Thanks Guillaume. I saw some revert patches have the Fixes flag and some are
not, so I didn't add it.

Hi David,

Should I re-post the patch with Fixes flag?

Thanks
Hangbin
