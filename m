Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E3214ECCD
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgAaM6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:58:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53914 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728514AbgAaM6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580475504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sgTfRaVBDRCmw+myA/TCCEBxkQJTkrEbUjL7m09+FDs=;
        b=FaEo//5HaHt/W60qJKW8OZ4HrmzLk/jL18UsYdD36UGD4qI3RN323GpYwscdIQRIAfSHv7
        foS4X0I14tCcoNylbCcp25Rc7OuTH6vd63AAo5VrhKVhABejE6FkFfKHYvpXZL2X68ITd3
        JbZx4wIHt9j+Z2ZAyCTNbGaSd/wWTCc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-4Gyaou66OryW-jp1eLDjjw-1; Fri, 31 Jan 2020 07:58:18 -0500
X-MC-Unique: 4Gyaou66OryW-jp1eLDjjw-1
Received: by mail-wm1-f71.google.com with SMTP id m18so2005657wmc.4
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 04:58:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sgTfRaVBDRCmw+myA/TCCEBxkQJTkrEbUjL7m09+FDs=;
        b=OaiWF3KJjvOeFlomFpLLOhgCgP9cJgvmxflvrM9rCgZqbwRQ6TPpqU/VMkPWpPCEZT
         F/RK/z8rIexsGTHnW0cTNhcA3CmjNZZ4F1O/N8ohgM4NXXaDk7tYI/k5u+NnR5NwJLGJ
         vYW6OApt16t7bFX77nWLu/Z//YFB1Xenw3Dfk6hILcFGt12T4FiNNqc/9UmTAPInKSwY
         hIzTlllwgqe8aQzza7PwlEySmWMX0drlTxK256QQoi3KTjR81FTQTfXbCR+xsqMLifYF
         5YdEnWaqAgHx5iMR09/tFJfLVhzS4LpiUVEuYC0oMnRvRqOhuwkYu/bg8Lcoh/Ly8cw7
         6WXA==
X-Gm-Message-State: APjAAAVGzLHiFyr0snYc99yy5LJNcE83qOqfmhqCWPn78O4WAEHccu1g
        uqE60tfuGWTDtw8NSjntwyaLtGzRkK9pFGQMMvZYSADhbGk2rlXJ88oylRMN/QlQHrPeFAkhlPr
        M42UbSKf5dWIE+fMu
X-Received: by 2002:a5d:6a42:: with SMTP id t2mr7986612wrw.83.1580475496869;
        Fri, 31 Jan 2020 04:58:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqyqpfosN7PC6N5s4p3w2nTqzSokPswONvfggt/rWgy+OdbNpPzqm1w6ZrFHstcEuhM+DkfmXQ==
X-Received: by 2002:a5d:6a42:: with SMTP id t2mr7986603wrw.83.1580475496681;
        Fri, 31 Jan 2020 04:58:16 -0800 (PST)
Received: from pc-61.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id q1sm6211153wrw.5.2020.01.31.04.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:58:16 -0800 (PST)
Date:   Fri, 31 Jan 2020 13:58:14 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Ridge Kennedy <ridgek@alliedtelesis.co.nz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200131125814.GC32428@pc-61.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <alpine.DEB.2.21.2001171016080.9038@ridgek-dl.ws.atlnz.lc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001171016080.9038@ridgek-dl.ws.atlnz.lc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 10:26:09AM +1300, Ridge Kennedy wrote:
> On Thu, 16 Jan 2020, Guillaume Nault wrote:
> > On Thu, Jan 16, 2020 at 11:34:47AM +1300, Ridge Kennedy wrote:
> > > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > > index f82ea12bac37..0cc86227c618 100644
> > > --- a/net/l2tp/l2tp_core.c
> > > +++ b/net/l2tp/l2tp_core.c
> > > @@ -323,7 +323,9 @@ int l2tp_session_register(struct l2tp_session *session,
> > >  		spin_lock_bh(&pn->l2tp_session_hlist_lock);
> > > 
> > >  		hlist_for_each_entry(session_walk, g_head, global_hlist)
> > > -			if (session_walk->session_id == session->session_id) {
> > > +			if (session_walk->session_id == session->session_id &&
> > > +			    (session_walk->tunnel->encap == L2TP_ENCAPTYPE_IP ||
> > > +			     tunnel->encap == L2TP_ENCAPTYPE_IP)) {
> > >  				err = -EEXIST;
> > >  				goto err_tlock_pnlock;
> > >  			}
> > Well, I think we have a more fundamental problem here. By adding
> > L2TPoUDP sessions to the global list, we allow cross-talks with L2TPoIP
> > sessions. That is, if we have an L2TPv3 session X running over UDP and
> > we receive an L2TP_IP packet targetted at session ID X, then
> > l2tp_session_get() will return the L2TP_UDP session to l2tp_ip_recv().
> > 
> > I guess l2tp_session_get() should be dropped and l2tp_ip_recv() should
> > look up the session in the context of its socket, like in the UDP case.
> > 
> > But for the moment, what about just not adding L2TP_UDP sessions to the
> > global list? That should fix both your problem and the L2TP_UDP/L2TP_IP
> > cross-talks.
> 
> I did consider not adding the L2TP_UDP sessions to the global list, but that
> change looked a little more involved as the netlink interface was also
> making use of the list to lookup sessions by ifname. At a minimum
> it looks like this would require rework of l2tp_session_get_by_ifname().
> 
Yes, you're right. Now that we all agree on this fix, can you please
repost your patch?

BTW, I wouldn't mind a small comment on top of the conditional to
explain that IP encap assumes globally unique session IDs while UDP
doesn't.

