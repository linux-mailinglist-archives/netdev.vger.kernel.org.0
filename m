Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D86232B97
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgG3F6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3F6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 01:58:32 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D268C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 22:58:29 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j187so24585782qke.11
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 22:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=phd6O3yMyVkYT4PFMQTzBGjYeyD6/bbg4aQWWhxqFYo=;
        b=WRTqr8NyjcdEcUae816dG3ovpNjrpDSMTg0dXIyhE/mr53gMIw8yWWMEgjdVSuJ8Ay
         WtGWGOGcUySOCgGPo1/ZzVYKWMfr6Bj90xJzmuYR7qmirPuxDNepJmb9EN8xe2xlYGdJ
         HfgHiGgAHmzwrYeRoR+3zdVGRFDNB/YtQc6eDHJ5DACx1QYkrNkSNAlal1+oVKidrcPv
         vWx+r51AGp+cAvJVeszU+WdhYL6K/OnDy2yn1/2L0X6lzt0VECPebxcwKLiLKppcK3EU
         niK2lDDQa8OLLXsvY/y3mTpaeM6k24GwR4QEZRA8yLckuqV3tUFcS4gSWYs/t6I0itj5
         d+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=phd6O3yMyVkYT4PFMQTzBGjYeyD6/bbg4aQWWhxqFYo=;
        b=ZzH60sSLD+Wj+B6g+Ae9t3RyPSV4os0y/B+KR86HpQQXddfIhDsondNxHuJhiAFCYk
         0KGBZyzKjpHXt3jRzJX5RqwO4yRuxrEpmuy4RtcAGZqQuOZiFsbPN4pFKxeYutrELF6G
         2DUlLju8NnY/O4sZBWMxLSWyXtwuqrJfzaRcXoMmNKp54h9/BHZoqiMMcUiYYgOH9paR
         bT/ZA5kkKqX3AkdOH4uf8YbdKKM8DCu+2onT9tlr15NK1KQAgb9/Kcw5JrLTMxY0ZAm1
         Kk13DwXFdS+U8FDlD4bkFZlSsia0b50vp/PJ6cekOKUCczI9ToM2B1uIq9PlN8/fUHMU
         3UOA==
X-Gm-Message-State: AOAM530vLdjy0OFgpU2yx65X52sfClRMrejmmmkjajy9no7HqCzPxXhC
        NZWiuGVyV2i5xKdBOjTerHxDRvjRFiK5RtbtfiWVVg==
X-Google-Smtp-Source: ABdhPJx7mC8iIHX6qkV1NeL0SnyK0zXPm9WUW3SQNhvECWDHWYCi8kk4E2uD+DDGyoMQ4L0avHMwQN66ZL6FeyA7A9g=
X-Received: by 2002:a37:8241:: with SMTP id e62mr37765030qkd.250.1596088708115;
 Wed, 29 Jul 2020 22:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000006f179d05ab8e2cf2@google.com> <BYAPR11MB2632784BE3AD9F03C5C95263FF700@BYAPR11MB2632.namprd11.prod.outlook.com>
 <87tuxqxhgq.fsf@intel.com>
In-Reply-To: <87tuxqxhgq.fsf@intel.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 30 Jul 2020 07:58:16 +0200
Message-ID: <CACT4Y+ZMvaJMiXikYCm-Xym8ddKDY0n-5=kwH7i2Hu-9uJW1kQ@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogSU5GTzogcmN1IGRldGVjdGVkIHN0YWxsIGluIHRjX21vZGlmeV9xZA==?=
        =?UTF-8?B?aXNj?=
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        syzbot <syzbot+9f78d5c664a8c33f4cce@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 9:13 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> "Zhang, Qiang" <Qiang.Zhang@windriver.com> writes:
>
> > ________________________________________
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: linux-kernel-owner@vger.kernel.org <linux-=
kernel-owner@vger.kernel.org> =E4=BB=A3=E8=A1=A8 syzbot <syzbot+9f78d5c664a=
8c33f4cce@syzkaller.appspotmail.com>
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2020=E5=B9=B47=E6=9C=8829=E6=97=
=A5 13:53
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: davem@davemloft.net; fweisbec@gmail.com; j=
hs@mojatatu.com; jiri@resnulli.us; linux-kernel@vger.kernel.org; mingo@kern=
el.org; netdev@vger.kernel.org; syzkaller-bugs@googlegroups.com; tglx@linut=
ronix.de; vinicius.gomes@intel.com; xiyou.wangcong@gmail.com
> > =E4=B8=BB=E9=A2=98: INFO: rcu detected stall in tc_modify_qdisc
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    181964e6 fix a braino in cmsghdr_from_user_compat_to_ke=
rn()
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12925e38900=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df87a5e4232f=
db267
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D9f78d5c664a8c=
33f4cce
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=3D16587f8c900000
>
> It seems that syzkaller is generating an schedule with too small
> intervals (3ns in this case) which causes a hrtimer busy-loop which
> starves other kernel threads.
>
> We could put some limits on the interval when running in software mode,
> but I don't like this too much, because we are talking about users with
> CAP_NET_ADMIN and they have easier ways to do bad things to the system.

Hi Vinicius,

Could you explain why you don't like the argument if it's for CAP_NET_ADMIN=
?
Good code should check arguments regardless I think and it's useful to
protect root from, say, programming bugs rather than kill the machine
on any bug and misconfiguration. What am I missing?

Also are we talking about CAP_NET_ADMIN in a user ns as well
(effectively nobody)?
