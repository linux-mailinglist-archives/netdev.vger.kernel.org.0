Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A7F3C3339
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 08:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhGJGgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 02:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhGJGgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 02:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C333A61375;
        Sat, 10 Jul 2021 06:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625898819;
        bh=VNm9/Ak6s/CzjktMVEDWaoLYk+ioO7EhXz5ijCF6AIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w8vIT1mXTYGGJE4vsScr2a8AU9r3OfMTIQC8GJwP+2M66YUBsfTOz9B+HauwQXqSI
         ohsyQxRw8H//DYz3jCJqrS8bRf3fYcxdYnRnHWS6ugrFGgfNhcSP5wyi/orlVhjabj
         1bs2PV+PKH46ycfj5Iyq2CNs6CKE5u+u272lJF9Q=
Date:   Sat, 10 Jul 2021 08:33:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Davis Mosenkovs <davikovs@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
Message-ID: <YOk/QNc0X71cF6Id@kroah.com>
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
 <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name>
 <YNtdKb+2j02fxfJl@kroah.com>
 <872e3ea6-bbdf-f67c-58f9-4c2dafc2023a@nbd.name>
 <CAHQn7pJY4Vv_eWpeCvuH_C6SHwAvKrSE2cQ=cTir72Ffcr9VXg@mail.gmail.com>
 <56afa72ef9addbf759ffb130be103a21138712f9.camel@sipsolutions.net>
 <CAHQn7pLxUt03sgL0B2_H0_p0iS0DT-LOEpMOkO_kd_w_WVTKBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQn7pLxUt03sgL0B2_H0_p0iS0DT-LOEpMOkO_kd_w_WVTKBA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 10:48:06PM +0300, Davis Mosenkovs wrote:
> On 2021-07-02 at 09:54 Johannes Berg (<johannes@sipsolutions.net>) wrote:
> >
> > > If testing procedure mentioned in my first email is sufficient (and
> > > using skb->data is the correct solution in kernel trees where current
> > > code doesn't work properly), I can make and test the patches.
> > > Should I do that?
> >
> > Yes, please do.
> >
> > Thanks,
> > johannes
> >
> I have done the testing on kernel versions 4.4.274, 4.9.274, 4.14.238,
> 4.19.196, 5.4.130, 5.10.48, 5.12.15 and 5.13.1.
> Only kernels 4.4.274, 4.9.274 and 4.14.238 are affected.
> On kernels 4.19.196, 5.4.130, 5.10.48, 5.12.15 and 5.13.1 current code
> works properly (and skb->data produces incorrect pointer when used
> instead of skb_mac_header()).
> I have submitted patches for the affected kernel versions:
> https://lore.kernel.org/r/20210707213800.1087974-1-davis@mosenkovs.lv
> https://lore.kernel.org/r/20210707213820.1088026-1-davis@mosenkovs.lv
> https://lore.kernel.org/r/20210707213834.1088078-1-davis@mosenkovs.lv

Please resend and cc: the stable@vger.kernel.org list so these can
actually be applied.

You have read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
right?

thanks,

greg k-h
