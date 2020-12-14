Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730232D9CEB
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501971AbgLNQpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:45:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406416AbgLNQpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607964257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sTQlUJBJ+1xKcR7W+ayhV1sJLYL+miqfe6UVqpTkY4A=;
        b=Wj7sqjMn5tdnZacbI/yX5hl+SDmqtMOrsdUod1FG9ukEmmTgy5ZRdWnfFTEUy3JfGkKEC2
        DHblvULQLLA5xS23fRQLhzGH0hR2htJAZe6vxOUnILbQf+CtEWe3qfguwxNKRN05SCe+Iy
        0/m/48g4G1ZgHyWoFTwSv0z93FVJ0Vg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-Wo--0PubMTaIpPnFoYPzIA-1; Mon, 14 Dec 2020 11:44:15 -0500
X-MC-Unique: Wo--0PubMTaIpPnFoYPzIA-1
Received: by mail-wm1-f72.google.com with SMTP id f187so7009579wme.3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 08:44:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sTQlUJBJ+1xKcR7W+ayhV1sJLYL+miqfe6UVqpTkY4A=;
        b=DejsgWACU8BBJdxKgufBoF1/D9on3qyPrjbfvmIXLtY/tkxfXSYGpzFu/94yGEu/PF
         M2zDTge30LcQuG/7F8zh0Gj3jIkTx6UN7c8BmLyC8Y5fASMmpPdYghvDdl90bG8+9Lxg
         Vo1mHWannckWvTMYy+158/yrq7KmqHDagWxTKtksSZMRf1dejVDLH6BKC76CPG3rRx/n
         G6qNxR1cRYgNvyS8MPxOOUfunpI2+d8GpYUMb6zfAqqrrniytZHRXLysfYYAFhmbSx/q
         vCFfGHuQWXdTcRm7F93CBZo3JYue7Yjqcsr0R4q5FFo3woM8ug4Baozb98H0ULFkcqgn
         kJUA==
X-Gm-Message-State: AOAM531ONgUTLsAXcYoeYYsCcDeTfcWyiOtvb3S3cRqHWgdjjdEiIt5i
        9i01OUrB9nVxFddBaAjBmxxA1VTkNkGWc+MpLP5Qius/9odfAmr6uRSQwpIDbHrit3mxa89CWTu
        utEY0HRT9uMN7R+rh
X-Received: by 2002:a5d:610d:: with SMTP id v13mr30260413wrt.425.1607964253820;
        Mon, 14 Dec 2020 08:44:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKk43dStphquLYXnLDD/h4UkHfeQYfoqiZnRsZuI3MS0MCxLP8cVSaCwG2k2RP/zntvwZwXw==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr30260400wrt.425.1607964253550;
        Mon, 14 Dec 2020 08:44:13 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id a62sm34998124wmh.40.2020.12.14.08.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:44:12 -0800 (PST)
Date:   Mon, 14 Dec 2020 17:44:11 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: Urgent: BUG: PPP ioctl Transport endpoint is not connected
Message-ID: <20201214164411.GA8350@linux.home>
References: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
 <20201209164013.GA21199@linux.home>
 <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
 <20201209181033.GB21199@linux.home>
 <FDF5FB97-DB82-4DFD-AC05-28F60C6D166F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FDF5FB97-DB82-4DFD-AC05-28F60C6D166F@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 09:16:24AM +0200, Martin Zaharinov wrote:
> And one other 
> From other mailing I see you send patch to Denys Fedoryshchenko this patch is : 
> 
> diff --git a/drivers/net/ppp/ppp_generic.c 
> b/drivers/net/ppp/ppp_generic.c
> 
> index 255a5def56e9..2acf4b0eabd1 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -3161,6 +3161,15 @@ ppp_connect_channel(struct channel *pch, int 
> unit)
> 
> goto outl;
> 
> ppp_lock(ppp);
> +   spin_lock_bh(>downl);
> +   if (!pch->chan) {
> +   /* Don't connect unregistered channels */
> +   ppp_unlock(ppp);
> +   spin_unlock_bh(>downl);
> +   ret = -ENOTCONN;
> +   goto outl;
> +   }
> +   spin_unlock_bh(>downl);
> if (pch->file.hdrlen > ppp->file.hdrlen)
> ppp->file.hdrlen = pch->file.hdrlen;
> hdrlen = pch->file.hdrlen + 2;   /* for protocol bytes */

This was a quick untested patch that I sent to help debugging Denys'
problem. It has a lock inversion problem that I fixed before I formally
submitted it upstream. I even warned about it in the original thread:
https://lore.kernel.org/netdev/20180302174328.GD1413@alphalink.fr/

> But in official stable kernel three In ppp_generic.c is this : 
> 
> spin_lock_bh(&pch->downl); 
> 	if (!pch->chan) { 
> 	/* Don't connect unregistered channels */ 
> 	spin_unlock_bh(&pch->downl); 
> 	ppp_unlock(ppp); 
> 	ret = -ENOTCONN; 
> 	goto outl; }
> 	spin_unlock_bh(&pch->downl);	

This one is correct.

> It is  normal to unlock ppp after spin_unlock ?
> shouldn't it be as you wrote it?
> In your patch first :
> 
> +   ppp_unlock(ppp);
> +   spin_unlock_bh(>downl);

No, nested locks have to be released in the reverse order they were
acquired.

> But in stable kernel is : 
> 
> spin_unlock_bh(&pch->downl); 
> 	ppp_unlock(ppp); 

This is correct, and has been correctly backported to 4.14-stable.


> > On 9 Dec 2020, at 20:10, Guillaume Nault <gnault@redhat.com> wrote:
> > 
> > On Wed, Dec 09, 2020 at 06:57:44PM +0200, Martin Zaharinov wrote:
> >>> On 9 Dec 2020, at 18:40, Guillaume Nault <gnault@redhat.com> wrote:
> >>> On Wed, Dec 09, 2020 at 04:47:52PM +0200, Martin Zaharinov wrote:
> >>>> Hi All
> >>>> 
> >>>> I have problem with latest kernel release 
> >>>> And the problem is base on this late problem :
> >>>> 
> >>>> 
> >>>> https://www.mail-archive.com/search?l=netdev@vger.kernel.org&q=subject:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=newest&f=1
> >>>> 
> >>>> I have same problem in kernel 5.6 > now I use kernel 5.9.13 and have same problem.
> >>>> 
> >>>> 
> >>>> In kernel 5.9.13 now don’t have any crashes in dimes but in one moment accel service stop with defunct and in log have many of this line :
> >>>> 
> >>>> 
> >>>> error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> 
> >>>> In one moment connected user bump double or triple and after that service defunct and need wait to drop all session to start .
> >>>> 
> >>>> I talk with accel-ppp team and they said this is kernel related problem and to back to kernel 4.14 there is not this problem.
> >>>> 
> >>>> Problem is come after kernel 4.15 > and not have solution to this moment.
> >>> 
> >>> I'm sorry, I don't understand.
> >>> Do you mean that v4.14 worked fine (no crash, no ioctl() error)?
> >>> Did the problem start appearing in v4.15? Or did v4.15 work and the
> >>> problem appeared in v4.16?
> >> 
> >> In Telegram group I talk with Sergey and Dimka and told my the problem is come after changes from 4.14 to 4.15 
> >> Sergey write this : "as I know, there was a similar issue in kernel 4.15 so maybe it is still not fixed"
> > 
> > Ok, but what is your experience? Do you have a kernel version where
> > accel-ppp reports no ioctl() error and doesn't crash the kernel?
> > 
> > There wasn't a lot of changes between 4.14 and 4.15 for PPP.
> > The only PPP patch I can see that might have been risky is commit
> > 0171c4183559 ("ppp: unlock all_ppp_mutex before registering device").
> > 
> >> I don’t have options to test with this old kernel 4.14.xxx i don’t have support for them.
> >> 
> >> 
> >>> 
> >>>> Please help to find the problem.
> >>>> 
> >>>> Last time in link I see is make changes in ppp_generic.c 
> >>>> 
> >>>> ppp_lock(ppp);
> >>>>       spin_lock_bh(&pch->downl);
> >>>>       if (!pch->chan) {
> >>>>               /* Don't connect unregistered channels */
> >>>>               spin_unlock_bh(&pch->downl);
> >>>>               ppp_unlock(ppp);
> >>>>               ret = -ENOTCONN;
> >>>>               goto outl;
> >>>>       }
> >>>>       spin_unlock_bh(&pch->downl);
> >>>> 
> >>>> 
> >>>> But this fix only to don’t display error and freeze system 
> >>>> The problem is stay and is to big.
> >>> 
> >>> Do you use accel-ppp's unit-cache option? Does the problem go away if
> >>> you stop using it?
> >>> 
> >> 
> >> No I don’t use unit-cache , if I set unit-cache accel-ppp defunct same but user Is connect and disconnet more fast.
> >> 
> >> The problem is same with unit and without . 
> >> Only after this patch I don’t see error in dimes but this is not solution.
> > 
> > Soryy, what's "in dimes"?
> > Do you mean that reverting commit 77f840e3e5f0 ("ppp: prevent
> > unregistered channels from connecting to PPP units") fixes your problem?
> > 
> >> In network have customer what have power cut problem, when drop 600 user and back Is normal but in this moment kernel is locking and start to make this : 
> >> sessions:
> >>  starting: 4235
> >>  active: 3882
> >>  finishing: 378
> >> The problem is starting session is not real user normal user in this server is ~4k customers .
> > 
> > What type of session is it? L2TP, PPPoE, PPTP?
> > 
> >> I use pppd_compat .
> >> 
> >> Any idea ?
> >> 
> >>>> 
> >>>> Please help to fix.
> >> Martin
> 

