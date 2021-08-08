Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288BA3E3B0F
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhHHPXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhHHPXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BE1160FC1;
        Sun,  8 Aug 2021 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628436201;
        bh=POEh85Mz0Mfu6he0iLlEtoaIKTEF+bxOsK4xezH/h0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=joSUfyFAOhTkGVbKYPLec+9Igb5jjsbVS+pj82uIEfS98Co0wOOAOi4QQzOjRze2y
         s22VPj13XxWjqKXGhzjSVIcqM6SuRQJ8GqcuwrcA726Qf5pRgRWtyGAACHNI93cdf4
         KpIldxzFknt/iYYPj2TZrsxWY3Ou+VgJlJFMqj/Fu6+vzm42PcBZ8xzcPGndIilB3P
         TuwDgD3Xc6+ZLKLHi1OD+P8AyBi69rnXTzxWhFSO1UQwJWtYailNlVUSlEQbhQ+lHp
         piKUAYyvQpXUQggfBW6axpMjcmMIQN26MrJOluijvJu9oB2XjIxWGEm0YVxuBc4EY6
         NWLYhELBDMkNg==
Received: by pali.im (Postfix)
        id DF35A13DC; Sun,  8 Aug 2021 17:23:18 +0200 (CEST)
Date:   Sun, 8 Aug 2021 17:23:18 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
Message-ID: <20210808152318.6nbbaj3bp6tpznel@pali>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com>
 <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Sunday 08 August 2021 18:14:09 Martin Zaharinov wrote:
> Add Pali Rohár,
> 
> If have any idea .
> 
> Martin
> 
> > On 6 Aug 2021, at 7:40, Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > On Thu, Aug 05, 2021 at 11:53:50PM +0300, Martin Zaharinov wrote:
> >> Hi Net dev team
> >> 
> >> 
> >> Please check this error :
> >> Last time I write for this problem : https://www.spinics.net/lists/netdev/msg707513.html
> >> 
> >> But not find any solution.
> >> 
> >> Config of server is : Bonding port channel (LACP)  > Accel PPP server > Huawei switch.
> >> 
> >> Server is work fine users is down/up 500+ users .
> >> But in one moment server make spike and affect other vlans in same server .

When this error started to happen? After kernel upgrade? After pppd
upgrade? Or after system upgrade? Or when more users started to
connecting?

> >> And in accel I see many row with this error.
> >> 
> >> Is there options to find and fix this bug.
> >> 
> >> With accel team I discus this problem  and they claim it is kernel bug and need to find solution with Kernel dev team.
> >> 
> >> 
> >> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> > 
> > These are userspace error messages, not kernel messages.
> > 
> > What kernel version are you using?

Yes, we need to know, what kernel version are you using.

> > thanks,
> > 
> > greg k-h
> 

And also another question, what version of pppd daemon are you using?

Also, are you able to dump state of ppp channels and ppp units? It is
needed to know to which tty device, file descriptor (or socket
extension) is (or should be) particular ppp channel bounded.
