Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29A919A32A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 03:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbgDABJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 21:09:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38784 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731554AbgDABJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 21:09:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so23984922ljh.5;
        Tue, 31 Mar 2020 18:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+xcJqhdr3IFgVYRzEjqu6L38w1/1INaRtNVeB4U8/vU=;
        b=Dzpnr5cjpt255dNU3N2cE4F1bo7h8z0jUeYUH0qu2vIYFewPfnhV2oXk+A80GCHWne
         bGXXMBbDuGsHEg+FnTZ82qKW/4Y/tis0lb99myCE8CxWVhaevZP+R4ZxCC39Gw8zIgnk
         r/x/6436nRntg6I70QCV/OEkE2vx933ugqAMCVdzgqFCjQYsE7MAdUvhtRGHODMv6HMh
         NljGmq4d8pBHbD0oWhPa4N5hbs1AwBxohLOK7Kjz2pG8OhfVBHQvYkYyKbCwvV32HJ8w
         QyxkNwP8ZCSmkGkUOm4CRMR7FhFyoulUw4Z5NQb76ZeDP55PJZTRhptqEFzokSy+2pic
         ugFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+xcJqhdr3IFgVYRzEjqu6L38w1/1INaRtNVeB4U8/vU=;
        b=EJhIyo/jV1mVd7gPt3uhkFd+fyN/yIEJ8TxmeY2Uufamk90AaOmBTkv8OBcNqrpL6x
         raNs0pQ3+3elizF4s3rVOadoNKd7xBvltAY42nC+4wvcjfmTnH4b75Z9K4xNWN7t9/Ay
         cNIgCIqwSBuXWl9KpbpDZoSUjS2rWg/BEk0jM3VuGQEP3JyIG5xMXolJjjyq21Oz/m1d
         rtNUjjrNnqCrseb2ISoY1ZdiyU4S4CC5cnsn4oR4+F3zUaBbruxVhPxZSWLNYNKpm8VN
         0M9P0dPH+2PRYo+J6tmNCkrb2EdKM4E7VNoV5vkZmuqnN0GkKIPx7fBijtXEWj9e3JxT
         5GaA==
X-Gm-Message-State: AGi0Puas4aJV9JnmWqel3t4Fr9vnd5hkPL3HR0ZD/MjGxvPYf0mXJHzB
        /iFJT56FYAPsXfWfNzta2KL0BPfbLwKL+F+T33w=
X-Google-Smtp-Source: APiQypJCyiCRScWm01RCRjzj/m8kcYKLOwiqshd4+NDrSy4vnpbUCRiQpozWfNLqnFwmRVZua3kFjX0pywSkSWDDbnU=
X-Received: by 2002:a2e:97c2:: with SMTP id m2mr199634ljj.228.1585703394946;
 Tue, 31 Mar 2020 18:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200331163559.132240-1-zenczykowski@gmail.com>
 <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr> <20200331181641.anvsbczqh6ymyrrl@salvia>
 <CAHo-Ooy-5CxfWhHuhWHO5M_wm8mO_ZMZT81qNSSNTyN5OAoJww@mail.gmail.com> <20200331232824.ici562aee6zr3w23@salvia>
In-Reply-To: <20200331232824.ici562aee6zr3w23@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 31 Mar 2020 18:09:44 -0700
Message-ID: <CAHo-OowPwBkA7ZO3TT3ntg3eiKV3iH1A-WnzvPzR3DMyN_dfdA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right, so if you look at the android common kernel implementation.
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainl=
ine/net/netfilter/xt_IDLETIMER.c#201

(and in particular grep for send_nl_msg throughout the file) the core
difference is the call to notify_netlink_uevent() at
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainl=
ine/net/netfilter/xt_IDLETIMER.c#101

this function is also defined in the same file, and it ends up calling
  kobject_uevent_env(idletimer_tg_kobj, KOBJ_CHANGE, envp);
with INTERFACE, STATE, UID and TIME_NS metadata.

this is later parsed in netd C++:
  https://android.googlesource.com/platform/system/netd/+/refs/heads/master=
/server/NetlinkHandler.cpp#208

which then via notifyInterfaceClassActivityChanged() I believe
generates a binder call into the java network stack
for further processing.

void NetlinkHandler::notifyInterfaceClassActivityChanged(int label,
bool isActive,
int64_t timestamp, int uid) {
LOG_EVENT_FUNC(BINDER_RETRY, onInterfaceClassActivityChanged,
isActive, label, timestamp, uid);
}

Ultimately the goal is to know WHO (uid - on Android it's 1 unix uid
per {user,app} combination) generated traffic
activity, WHEN (timestamp) and WHERE (label ie. interface).

ie. To figure out whether an interface is idle or not and can be
shutdown, or powersaved, etc.
WHO matters because some users (apps!) might be insufficiently
important (lack of background data privs) to prevent
a network device powersavings/sleep/disconnect or to cause a wakeup (I thin=
k).

My understanding is the 'timer' thing (aka HARDIDLETIMER) was added
because phones are almost constantly
entering suspend state, so we care about real clock time
(CLOCK_BOOTTIME) rather than cpu activity time (CLOCK_MONOTONIC which
doesn't include time the device is suspended).

I think this could probably be eventually switched to use the sysfs
notification mechanism,
but we can't change that on any of the already shipped devices and
it's kind of late even for devices shipping this year,
and that system would presumably need to be extended to support uids.

On Tue, Mar 31, 2020 at 4:28 PM Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> On Tue, Mar 31, 2020 at 02:21:00PM -0700, Maciej =C5=BBenczykowski wrote:
> > Right, this is not in 5.6 as it's only in net-next atm as it was only
> > merged very recently.
> > I mentioned this in the commit message.
> >
> > I'm not sure what you mean by code that uses this.
> > You can checkout aosp source and look there...
> > There's the kernel code (that's effectively already linked from the
> > commit message), and the iptables userspace changes (
> > https://android.googlesource.com/platform/external/iptables/+/refs/head=
s/master/extensions/libxt_IDLETIMER.c#39
>
> OK, so this is field ised set in userspace.
>
> > ), and the netd C++/Java layer that uses iptables -j IDLETIMER
> > --send_nl_msg 1 (
> > https://android.googlesource.com/platform/system/netd/+/refs/heads/mast=
er/server/IdletimerController.cpp#151
> > ) and the resulting notifications parsing (can't easily find it atm).
> >
> > If you mean by code that uses this patch... that's impossible as this
> > patch doesn't implement a usable feature.
> > It just moves the offset.
> >
> > Could you clarify what you're asking for?
>
> Maybe I'm misunderstanding. How is this field used in aosp?
>
> I mean, if --send_nl_msg 1 is passed, how does the existing behaviour
> changes?
