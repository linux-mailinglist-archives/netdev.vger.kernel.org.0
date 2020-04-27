Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA3A1BAAE9
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgD0RPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgD0RPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:15:17 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12F7C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:15:15 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id k8so14765495ejv.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQIIH/qXI4Oq0GPZjnqdBq+wB6tFDETGYU4fU6Cvqbg=;
        b=fGsrZpQGHw8T1qhXOn08sAVKc9hhBZGJGMiSdHmcQT8UGqNUbKZpdDeXlUrc7ffCAY
         ZrmyBBI0KztuOAwPhqx7Z1cWhqJ+/mJd3Z6fXxueGa/eJVHHqPmhKgD4b5m6jQIfGIz/
         VxFx7CxHaIqFHL9yA6tJm+QaueugHAVlFEI+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQIIH/qXI4Oq0GPZjnqdBq+wB6tFDETGYU4fU6Cvqbg=;
        b=rhON3/NvRITp8DimUC1o6RrvaXVNchTFC5B4lFGjRGqQbqlXV5MNkLaWKx/+UzibF5
         JhdXK6hN4IusUlIniT4svTstsFVhoRrmmfgZG2/wr8iU/tks8EvZwunRh7JA9W1ypcBw
         t8kNMC3pwnLaq873O+VP6Tswz0FhhPbM7AvrH9ANQWilBArfgaD60Ut/HoZwnTae6SRw
         uXZRsbgktk8Ipvv6a0yMrH5bNJIldjJ6BCiB7YFsOYsN0iu3S+cY4tTSgdD8AsURxaCg
         0VSf9D3+kAI1kT2lOqqfvUyCmyC/ki/+AzPvoMh3TdAiyUp2Il8aXBEcy+WSP/DyCtJv
         9ZEg==
X-Gm-Message-State: AGi0PuYTvvqI+h2mFhjVrJyxH6nPMM9bwatIagF5RGHS5Bo21ujBQqsj
        PTjMhzk24zBpSSR4OveO7PU3sMdbjEjhOHFLvZ7Tvg==
X-Google-Smtp-Source: APiQypLHty74OHVJKbXKvWIW4eZyotCiI+nPg29Apn009QimqfXruLPZ/iRD0GP9D2xgFy0aQOY0fkUwwvEz/cpyVVI=
X-Received: by 2002:a17:906:ce49:: with SMTP id se9mr17495986ejb.345.1588007714425;
 Mon, 27 Apr 2020 10:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
 <1587862128-24319-4-git-send-email-roopa@cumulusnetworks.com>
 <fd7e0fa8-dc1b-b410-a327-f09cbe929c82@gmail.com> <CAJieiUhpM7r0Ly4WUqvCJm34LUjuj=Mo5V9JiWrVTd=nLiAMHQ@mail.gmail.com>
In-Reply-To: <CAJieiUhpM7r0Ly4WUqvCJm34LUjuj=Mo5V9JiWrVTd=nLiAMHQ@mail.gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 27 Apr 2020 10:15:05 -0700
Message-ID: <CAJieiUiRdbPUWe0oKR2T_y+LgWeZfMqzhFMPjaw2KsqmrdeuxQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] selftests: net: add new testcases for
 nexthop API compat mode sysctl
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 11:38 AM Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>
> On Sun, Apr 26, 2020 at 10:40 AM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 4/25/20 6:48 PM, Roopa Prabhu wrote:
> > > @@ -253,6 +253,33 @@ check_route6()
> > >       check_output "${out}" "${expected}"
> > >  }
> > >
> > > +start_ip_monitor()
> > > +{
> > > +     local mtype=$1
> > > +
> > > +     # start the monitor in the background
> > > +     tmpfile=`mktemp /var/run/nexthoptestXXX`
> > > +     mpid=`($IP monitor $1 > $tmpfile & echo $!) 2>/dev/null`
> >
> > && echo?
> >
> > also, that looks weird. shouldn't it be:
> >         mpid=($IP monitor ${mtype} > $tmpfile 2>&1 && echo $!)
> >
>
> no, the & is for background. I picked this from the rtnetlink selftest.
> It can be moved to a library if there is one, this version is
> specifically for route monitor.
>
> > you declare mtype but use $1.
>
> will fix , thats a leftover from last min cleanup
>
> >
> >
> > > +     sleep 0.2
> > > +     echo "$mpid $tmpfile"
> > > +}
> > > +
> > > +stop_ip_monitor()
> > > +{
> > > +     local mpid=$1
> > > +     local tmpfile=$2
> > > +     local el=$3
> > > +
> > > +     # check the monitor results
> > > +     kill $mpid
> > > +     lines=`wc -l $tmpfile | cut "-d " -f1`
> >
> > just for consistency with the rest of the script, use $(...) instead of
> > `...`
> >
> > > +     test $lines -eq $el
> > > +     rc=$?
> > > +     rm -rf $tmpfile
> > > +
> > > +     return $rc
> > > +}
> > > +
> > >  ################################################################################
> > >  # basic operations (add, delete, replace) on nexthops and nexthop groups
> > >  #
> >
> > ...
> >
> > > +ipv6_compat_mode()
> > > +{
> > > +     local rc
> > > +
> > > +     echo
> > > +     echo "IPv6 nexthop api compat mode test"
> > > +     echo "--------------------------------"
> > > +
> > > +     sysctl_nexthop_compat_mode_check "IPv6"
> > > +     if [ $? -eq $ksft_skip ]; then
> > > +             return $ksft_skip
> > > +     fi
> > > +
> > > +     run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
> > > +     run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
> > > +     run_cmd "$IP nexthop add id 122 group 62/63"
> > > +     ipmout=$(start_ip_monitor route)
> > > +
> > > +     run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
> > > +     # route add notification should contain expanded nexthops
> > > +     stop_ip_monitor $ipmout 3
> > > +     log_test $? 0 "IPv6 compat mode on - route add notification"
> > > +
> > > +     # route dump should contain expanded nexthops
> > > +     check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop via 2001:db8:91::3 dev veth1 weight 1"
> > > +     log_test $? 0 "IPv6 compat mode on - route dump"
> > > +
> > > +     # change in nexthop group should generate route notification
> > > +     run_cmd "$IP nexthop add id 64 via 2001:db8:91::4 dev veth1"
> > > +     ipmout=$(start_ip_monitor route)
> > > +     run_cmd "$IP nexthop replace id 122 group 62/64"
> > > +     stop_ip_monitor $ipmout 3
> > > +
> > > +     log_test $? 0 "IPv6 compat mode on - nexthop change"
> > > +
> > > +     # set compat mode off
> > > +     sysctl_nexthop_compat_mode_set 0 "IPv6"
> > > +
> > > +     run_cmd "$IP -6 ro del 2001:db8:101::1/128 nhid 122"
> > > +
> > > +     run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
> > > +     run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
> > > +     run_cmd "$IP nexthop add id 122 group 62/63"
> > > +     ipmout=$(start_ip_monitor route)
> > > +
> > > +     run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
> > > +     # route add notification should not contain expanded nexthops
> > > +     stop_ip_monitor $ipmout 1
> > > +     log_test $? 0 "IPv6 compat mode off - route add notification"
> > > +
> > > +     # route dump should not contain expanded nexthops
> > > +     check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium"
> >
> > here and above, remove the 'pref medium' from the string; it was moved
> > by a recent iproute2 change (from Donald) so for compat with old and new
> > iproute2 just drop it. See 493f3cc7ee02.
> >
>
> ack, looks like my iproute2 is a little old

David, I still see pref with the latest iproute2-next. I have removed
it from v3. But there are other tests in fib_nexthops.sh that still
use 'pref'. Just fyi. I don't plan to respin the selftest patch,
unless you want me to. Just fyi
