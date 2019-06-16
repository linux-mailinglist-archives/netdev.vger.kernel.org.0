Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B374475F8
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 18:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFPQue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 12:50:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56798 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfFPQud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 12:50:33 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <christian.brauner@canonical.com>)
        id 1hcYMR-0003oA-7s
        for netdev@vger.kernel.org; Sun, 16 Jun 2019 16:50:31 +0000
Received: by mail-wr1-f71.google.com with SMTP id e8so3558069wrw.15
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 09:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4weMMDB1e4xggyN6QVuSK0L2mbvAhMQgtTR+U8gP2VI=;
        b=BxO+kul9NW2zCFLt8g5Z7ZW4+AOMdmgTw01bMBmr1AwV7Q2i1kS8sbVp5Vadtc/yCb
         BMSEndlLJBWI1C+999a79UqMINQj0HIEv/bTlQk6nV84KB2VgRiRmNekMQ5+b+hG57MB
         mlnHQCE2O8tU/Nb/vEdgJCmR5Mud1D6iy6j/aE1/ZrXR/xNRRZUDAoPz6LFTFWnFonEJ
         WVEluXYmyoOnk/NEH8cXcQI4CQdEby6g/xqAe9UqIpoq62LZ9xqcyoT+qECsFGdPeocV
         yynetYnP1xAXEKRWn6o3dHvFWV0mRAF5gII4LEZJKnqtpOX/ZfO12aRTapnjifVPR2Vo
         70TQ==
X-Gm-Message-State: APjAAAWqsrAaJAFCQOas/nVfpp0sGD7ts82TIm7ZG8fyU8mAlfxy6CG3
        F6osaS2R7WoSR7anDNJwvFoQ1dLrAgkMfdeJSvvy1AMZloTdDzzh3F2R+gFG4YWUbHlVCaDvOje
        XxQ5Kqx4ceVHsvDMG4Ons19fAEfe/ioPDwg==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr10550966wrm.191.1560703830526;
        Sun, 16 Jun 2019 09:50:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyAfKzA5GN6jq58JEOkyuPMZK3t2hID9fMyfxeAV6ksOEgtu2ETPFmf46Var84JITRXrsVC4A==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr10550947wrm.191.1560703830118;
        Sun, 16 Jun 2019 09:50:30 -0700 (PDT)
Received: from gmail.com ([212.91.227.56])
        by smtp.gmail.com with ESMTPSA id g19sm13495899wmg.10.2019.06.16.09.50.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 09:50:29 -0700 (PDT)
From:   Christian Brauner <christian.brauner@canonical.com>
X-Google-Original-From: Christian Brauner <christian.brauner@ubuntu.com>
Date:   Sun, 16 Jun 2019 18:50:28 +0200
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, avagin@virtuozzo.com,
        ktkhai@virtuozzo.com, "Serge E. Hallyn" <serge@hallyn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next 2/2 v5] netns: restrict uevents
Message-ID: <20190616165027.prdbshnipwphqtis@gmail.com>
References: <20180429104412.22445-1-christian.brauner@ubuntu.com>
 <20180429104412.22445-3-christian.brauner@ubuntu.com>
 <CAKdAkRTtffEQfZLnSW9CwzX_oYzHdOE816OvciGadqV7RHaV1Q@mail.gmail.com>
 <875zp5rbpf.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <875zp5rbpf.fsf@xmission.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 16, 2019 at 06:50:20AM -0500, Eric W. Biederman wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> > Hi Christian,
> >
> > On Sun, Apr 29, 2018 at 3:45 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> >>
> >> commit 07e98962fa77 ("kobject: Send hotplug events in all network namespaces")
> >>abhishekbh@google.com
> >> enabled sending hotplug events into all network namespaces back in 2010.
> >> Over time the set of uevents that get sent into all network namespaces has
> >> shrunk. We have now reached the point where hotplug events for all devices
> >> that carry a namespace tag are filtered according to that namespace.
> >> Specifically, they are filtered whenever the namespace tag of the kobject
> >> does not match the namespace tag of the netlink socket.
> >> Currently, only network devices carry namespace tags (i.e. network
> >> namespace tags). Hence, uevents for network devices only show up in the
> >> network namespace such devices are created in or moved to.
> >>
> >> However, any uevent for a kobject that does not have a namespace tag
> >> associated with it will not be filtered and we will broadcast it into all
> >> network namespaces. This behavior stopped making sense when user namespaces
> >> were introduced.
> >>
> >> This patch simplifies and fixes couple of things:
> >> - Split codepath for sending uevents by kobject namespace tags:
> >>   1. Untagged kobjects - uevent_net_broadcast_untagged():
> >>      Untagged kobjects will be broadcast into all uevent sockets recorded
> >>      in uevent_sock_list, i.e. into all network namespacs owned by the
> >>      intial user namespace.
> >>   2. Tagged kobjects - uevent_net_broadcast_tagged():
> >>      Tagged kobjects will only be broadcast into the network namespace they
> >>      were tagged with.
> >>   Handling of tagged kobjects in 2. does not cause any semantic changes.
> >>   This is just splitting out the filtering logic that was handled by
> >>   kobj_bcast_filter() before.
> >>   Handling of untagged kobjects in 1. will cause a semantic change. The
> >>   reasons why this is needed and ok have been discussed in [1]. Here is a
> >>   short summary:
> >>   - Userspace ignores uevents from network namespaces that are not owned by
> >>     the intial user namespace:
> >>     Uevents are filtered by userspace in a user namespace because the
> >>     received uid != 0. Instead the uid associated with the event will be
> >>     65534 == "nobody" because the global root uid is not mapped.
> >>     This means we can safely and without introducing regressions modify the
> >>     kernel to not send uevents into all network namespaces whose owning
> >>     user namespace is not the initial user namespace because we know that
> >>     userspace will ignore the message because of the uid anyway.
> >>     I have a) verified that is is true for every udev implementation out
> >>     there b) that this behavior has been present in all udev
> >>     implementations from the very beginning.
> >
> > Unfortunately udev is not the only consumer of uevents, for example on
> > Android there is healthd that also consumes uevents, and this
> > particular change broke Android running in a container on Chrome OS.
> > Can this be reverted? Or, if we want to keep this, how can containers
> > that use separate user namespace still listen to uevents?
> 
> The code has been in the main tree for over a year so at a minimum
> reverting this has the real chance of causing a regression for
> folks like lxc.
> 
> I don't think Android running in a container on Chrome OS was even
> available when this change was merged.  So I don't think this falls
> under the ordinary no regression rules.
> 
> I may be wrong but I think this is a case of developing new code on an
> old kernel and developing a dependence on a bug that had already been
> fixed in newer kernels.  I know Christian did his best to reach out to
> everyone when this change came through, so only getting a bug report
> over a year after the code was merged is concerning.
> 
> That said uevents should be completely useless in a user namespace
> except as letting you know something happened.  Is that what healthd
> is using them for?
> 
> 
> One solution would be to tweak the container userspace on ChromeOS to
> listen to the uevents outside the container and to relay them into the
> Android container.

Thanks for jumping in Eric! Welcome back. :)

Hey Dmitry,

Crostini on ChromeOS is making heavy use of this patchset and of LXD. So
reverting this almost 1.5 years after the fact will regress all of
Google's ChromeOS Crostini users, and all LXD/LXC users.

LXD and Crostini by using LXD (through Concierge/Tremplin etc. [2]) are
using this whole series e.g. when hotplugging usb devices into the
container.

When a usb hotplug happens, LXD will receive the relevant uevent and
will forward it to the container. Any process listening on a uevent
socket inside the container will now be able to see it.

Now, to talk briefly about solutions:
From what I gather from talking to the ChromeOS guys and from your
ChromeOS bugtracker and recent patchsets to ARC you are moving your
Android workloads into Crostini? So like Eric said this seems like a new
feature you're implementing.

If you need to be able to listen to uevents inside of a user namespace
and plan on using Crostini going forward then you can have Crostini
forward battery uevents to the container. The logic for doing this can
be found in the LXD codebase (cf. [3]). It's pretty simple. If you want
to go this route I'm happy to guide you. :)
Note, both options are a version of what Eric suggested in his last
paragraph!

What astonishes me is that healthd couldn't have possibly received
battery uevents for a long time even if Android already was run in user
namespaces prior to the new feature you're working on and the healthd I
see in master is not even using uevents anymore (cf. [8]) but rather is
using sysfs it seems. :)
Before that healthd was using (cf. [7])

uevent_kernel_multicast_recv()
|
-> uevent_kernel_multicast_uid_recv

the latter containing the check

if (cred->uid != 0) {
    /* ignoring netlink message from non-root user */
    goto out;
}

Before my patchset here the uevents sent out came with cred->uid == INVALID_UID
and so healthd never received those events until very recently.
And I can tell you exactly when it started receiving those events as I
reported the removal of this check as a bug against Android before
this patchset was ever merged and before a version of Android without
this check was released (cf. [6]). :)
While we're at it, removing this check is strange. Why would you have
any core tool of yours listen to uevents that do not come from the root
user? Especially when it comes from INVALID_UID. That's what I tried to
tell you in [6].

This patchset also fixes a real information leak. Netlink is a socket
and having those sockets respect network namespaces like all others
makes sense. Especially to allow containers to do their own thing and
to avoid information leakage.

Fyi, when I wrote this patch I informed the ChromeOS guys about it
multiple times as early as March/April 2018. At least two times the PM
in person (last time we talked about this was during FOSDEM because
ChromeOS was already reling on this). I also mentioned this feature on
the official ChromeOS bugtracker here [1] in April 2018 since ChromeOS
could use it.
So that this comes up as a problem almost 1.5 years later is a bit
surprising. :)
Additionally, I gave a presentation about this feature at LPC 2018 with
Google folks from Android around as well (cf. [4]). :)

Thanks!
Christian

[1]: https://bugs.chromium.org/p/chromium/issues/detail?id=831850#c2
[2]: https://bugs.chromium.org/p/chromium/issues/detail?id=956288
[3]: https://github.com/lxc/lxd 
[4]: https://www.youtube.com/watch?v=yI_1cuhoDgA&t=327s
[5]: https://android.googlesource.com/platform/system/core.git/+/android-4.2.2_r1/libcutils/uevent.c#77
[6]: https://issuetracker.google.com/issues/77764945
[7]: https://android.googlesource.com/platform/system/core/+/android-4.4_r1/healthd/healthd.cpp#135
[8]: https://android.googlesource.com/platform/system/core/+/master/healthd/BatteryMonitor.cpp
