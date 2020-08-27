Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED73254FDA
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 22:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgH0UKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 16:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgH0UKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 16:10:45 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7606DC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 13:10:45 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c10so6043123edk.6
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 13:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p+NhuGqZ1s2YOIDcL/NLneD1sSa9p1wUOJUKqaMqRkw=;
        b=Md/xHyaGoYRdh+UNIrfduX3a2nUDPbw1zFgSowMyJTCFVTN1fTpyRBimXcJichIHef
         Jo0srQdtzmRNP+gsin5OTAz8TQtg3zpd1S50BCMb7vaCV+vm3L7n39g1+UF4hkspZhM6
         DmT+eDm2ALzIDH9aA6TtStWercvL3mLFc9ebukS+Gv+ohl+3/12AAD8neUeekyHQQ+0S
         k/0Z8wxUyqtAuGCo0zVxoY3bqYvIy8RdYG36Oe/CxDqQHjsjCk52SpCtHlPpX8gF+XoN
         aF3pI9+MypDBQ5ubIuGAP9jpr4vTAgne9KefuEJ/CP8PmL8AgXvH+hsYnL105GPvFEqD
         hUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p+NhuGqZ1s2YOIDcL/NLneD1sSa9p1wUOJUKqaMqRkw=;
        b=n7omtMhddb8ndn93Qv+4DAqk/9SfVFcUZYbbZFJd5P5MaVkKMzwUxSvUph0QRPjX0c
         XqC1UCrwCOfWN7uNcNsUo3Ha5DyMKM8Bgk1e6rny/N9ubim8zSM8xSJhykRYhve6Bt6N
         2Utfr5m3UF5L9BuddJ8HqVdrUA/Zxmrwd5g49b0N/OLQ2PVEhFKwKHRnQCmzgot0pnct
         qgU71WhSl7geQk/AiU9rrXzSpnhjtlVN02pRRHsi3x82rpHEujo6359JiNxmbs0CPQGl
         duXQAqSzejlIfbAYs//7ocBKC28JepI5sboZGwI9KY4TCxXRtc1QmkE/Xq49vCeODzP0
         tnkA==
X-Gm-Message-State: AOAM533scowL5j8AZqv9WhkuJ7jEUgeRFyerJUi8myuahQNHgVGUmLvu
        fg9knGHE0sjCVRlQwcn1BaP8pFQzt497H9VqC2s8
X-Google-Smtp-Source: ABdhPJxJvE6mA822Q9ll6TLmIZgcHK/6bfOb1ebbRtjm3udhvJdA1rH7i+/IZ4kQ1knmS+cF4kf7wKpLGnK+Z3jqYvU=
X-Received: by 2002:aa7:c6ca:: with SMTP id b10mr13274121eds.269.1598559044015;
 Thu, 27 Aug 2020 13:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200827163712.106303-1-alex.dewar90@gmail.com>
 <CAHC9VhRgi54TXae1Wi+SSzkuy9BL7HH=pZCHL1p215M9ZXKEOA@mail.gmail.com>
 <20200827170634.wogybzcxux7sgefb@medion> <20200827172006.gudui4alfbbf2a2p@medion>
In-Reply-To: <20200827172006.gudui4alfbbf2a2p@medion>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 27 Aug 2020 16:10:32 -0400
Message-ID: <CAHC9VhRtTykJVze_93ed+n+v14Ai9J5Mbre9nGEc2rkqbqKc_g@mail.gmail.com>
Subject: Re: [PATCH RFC] netlabel: remove unused param from audit_log_format()
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 1:20 PM Alex Dewar <alex.dewar90@gmail.com> wrote:
> On Thu, Aug 27, 2020 at 06:06:34PM +0100, Alex Dewar wrote:
> > On Thu, Aug 27, 2020 at 01:00:58PM -0400, Paul Moore wrote:
> > > On Thu, Aug 27, 2020 at 12:39 PM Alex Dewar <alex.dewar90@gmail.com> wrote:
> > > >
> > > > Commit d3b990b7f327 ("netlabel: fix problems with mapping removal")
> > > > added a check to return an error if ret_val != 0, before ret_val is
> > > > later used in a log message. Now it will unconditionally print "...
> > > > res=0". So don't print res anymore.
> > > >
> > > > Addresses-Coverity: ("Dead code")
> > > > Fixes: d3b990b7f327 ("netlabel: fix problems with mapping removal")
> > > > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> > > > ---
> > > >
> > > > I wasn't sure whether it was intended that something other than ret_val
> > > > be printed in the log, so that's why I'm sending this as an RFC.
> > >
> > > It's intentional for a couple of reasons:
> > >
> > > * The people who care about audit logs like to see success/fail (e.g.
> > > "res=X") for audit events/records, so printing this out gives them the
> > > warm fuzzies.
> > >
> > > * For a lot of awful reasons that I won't bore you with, we really
> > > don't want to add/remove fields in the middle of an audit record so we
> > > pretty much need to keep the "res=0" there even if it seems a bit
> > > redundant.
> > >
> > > So NACK from me, but thanks for paying attention just the same :)
> >
> > Would you rather just have an explicit "res=0" in there, without looking
> > at ret_val? The thing is that ret_val will *always* be zero at this point in
> > the code, because, if not, the function will already have returned.
> > That's why Coverity flagged it up as a redundant check.
>
> Sorry, I meant "res=1". The code will always print res=1, because
> ret_val is always 0.

That's okay, I can't tell you how many times I've made that mistake
with "res=" :)

Anyway, yes at that point ret_val should always be 0, and "res=X"
should always be "res=1", so if you wanted to change it to a fixed
value so you could get rid of the ternary statement that would be
okay.

> > > >  net/netlabel/netlabel_domainhash.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
> > > > index f73a8382c275..526762b2f3a9 100644
> > > > --- a/net/netlabel/netlabel_domainhash.c
> > > > +++ b/net/netlabel/netlabel_domainhash.c
> > > > @@ -612,9 +612,8 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
> > > >         audit_buf = netlbl_audit_start_common(AUDIT_MAC_MAP_DEL, audit_info);
> > > >         if (audit_buf != NULL) {
> > > >                 audit_log_format(audit_buf,
> > > > -                                " nlbl_domain=%s res=%u",
> > > > -                                entry->domain ? entry->domain : "(default)",
> > > > -                                ret_val == 0 ? 1 : 0);
> > > > +                                " nlbl_domain=%s",
> > > > +                                entry->domain ? entry->domain : "(default)");
> > > >                 audit_log_end(audit_buf);
> > > >         }
> > > >

-- 
paul moore
www.paul-moore.com
