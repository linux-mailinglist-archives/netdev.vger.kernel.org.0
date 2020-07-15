Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBADD2215B9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGOUGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOUGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:06:11 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CCCC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 13:06:10 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 80so3093173qko.7
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 13:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Showm03rPwz5x6u/0lOnKIZybQu4gK9v4kmFyf2snNY=;
        b=iclvU3iLzUE2fe50NF58xUoiARGvPmV+pykgPxXXd1mYB6lrbV5l15RCJYxWlR4ke7
         XRrMpl/C5uJC+S82xbJtVUuwS1NjtUZXBdfPtZNJMv9MjgZvVw6+fFS/je/fvpf9Y6SR
         hpjyKIDIFm21ZEcX6XoESFAOvIo7VHu+HBpC58k8V4dNoNs802X4RO+r6SobCj1qOvtN
         HSPk9bBlCh8BBh+pBslNeialpqatOfn8LBSrWcYh98CTjt/vVpJbAxGtEaJFvrz5lSgU
         Zb72w2n0UuKPDXIYwWH53SlMT8L2Uu6JzJ6wOIVKY2CPonUFNpl1gQkRPxDWDKmcXeSK
         9Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Showm03rPwz5x6u/0lOnKIZybQu4gK9v4kmFyf2snNY=;
        b=IAZyVCRmDVSiSEtkn+EUUFsOZyoNclcO9VnGWxVgT+qJ4ZaprjCO7i329WdDXSTfqj
         B4K9nN2nd1pxCdzG7TWzG7sP2eDW5sNrPaytHKR44kIQQ8sMXYooM1ud8xC+AjxS3tX0
         5IUaK8QBSHPk3xeiO2o7kXTc46WZ45qYPUfIcSrhNkd1klMsnNSdAo8/UU150NPZZJIf
         wpBmFPWkHFfcYg0cwHUOa7dhjXZGYkfduP9Qg0mzCjKk5CiQ7HfHtDShxXW+NEVcjryE
         RkDBgfH2CKrX4twQeAbY/ZGMP6B6DumOlkJ9lBIvA5frvZi64zLjaRlVn+IAbmGAjA6+
         wNBg==
X-Gm-Message-State: AOAM533LCs2oDeEcU7VuGXCZoMLpjP4YMariWuhIdlMKIY8hG3m/tSnk
        EkgYaidQxztz+vHRG4It6hj0drLafR3oa5kfVYFlQYqC4S4=
X-Google-Smtp-Source: ABdhPJyXC80xZ1DS8JNne5DPfDboywCGRMR1EW3uwFmZ6xxCzuVf5/h2k77EzHUsKbcvqUsKbUOB3n/Kxf0ywbqVM/g=
X-Received: by 2002:a37:8283:: with SMTP id e125mr738293qkd.175.1594843569602;
 Wed, 15 Jul 2020 13:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
In-Reply-To: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 15 Jul 2020 22:05:58 +0200
Message-ID: <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
Subject: Re: NAT performance issue 944mbit -> ~40mbit
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a  lot of debugging it turns out that the bug is in igb...

driver: igb
version: 5.6.0-k
firmware-version:  0. 6-1

03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
Connection (rev 03)

It's interesting that it only seems to happen on longer links... Any clues?

On Sat, Jul 11, 2020 at 5:53 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
>
> Hi,
>
> I first detected this with 5.7.6 but it seems to apply as far back as 5.6.1...
> (so, 5.7.8 client -> nat (5.6.1 -> 5.8-rc4 -> server 5.7.7)
>
> It seems to me that the window size doesn't advance, so i did revert
> the tcp: grow window for OOO packets only for SACK flows [1]
> but it did no difference...
>
> I have a 384 MB tcpdump of a iperf3 session that starts low and then
> actually starts to get the bandwidth...
> I do use BBR - I have tried with cubic... it didn't help  - the NAT
> machine does use fq but changing it doesn't seem to yield any other
> results.
>
> Doing -P10 gives you the bandwith and can sometimes break the
> stalemate but you'll end up back with the lower transfer speed again.
> (it only seems to apply to NAT - the machine is a: A2SDi-12C-HLN4F and
> has handled this without problems in the past...)
>
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.7.8&id=bf780119617797b5690e999e59a64ad79a572374
>
> First iperf3 as a reference:
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec   113 MBytes   945 Mbits/sec    0    814 KBytes
> [  5]   1.00-2.00   sec   109 MBytes   912 Mbits/sec    0    806 KBytes
> [  5]   2.00-3.00   sec   112 MBytes   944 Mbits/sec   31    792 KBytes
> [  5]   3.00-4.00   sec   101 MBytes   849 Mbits/sec   31   1.18 MBytes
> [  5]   4.00-5.00   sec   108 MBytes   902 Mbits/sec    0    783 KBytes
> [  5]   5.00-6.00   sec   111 MBytes   933 Mbits/sec   31    778 KBytes
> [  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec   93    772 KBytes
> [  5]   7.00-8.00   sec   112 MBytes   944 Mbits/sec    0    778 KBytes
> [  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec   60    778 KBytes
> [  5]   9.00-10.00  sec   111 MBytes   933 Mbits/sec   92    814 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  1.07 GBytes   923 Mbits/sec  338             sender
> [  5]   0.00-10.01  sec  1.07 GBytes   919 Mbits/sec                  receiver
>
> After that:
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  4.77 MBytes  40.0 Mbits/sec    0   42.4 KBytes
> [  5]   1.00-2.00   sec  4.10 MBytes  34.4 Mbits/sec    0   84.8 KBytes
> [  5]   2.00-3.00   sec  4.60 MBytes  38.6 Mbits/sec    0   87.7 KBytes
> [  5]   3.00-4.00   sec  4.23 MBytes  35.4 Mbits/sec    0   42.4 KBytes
> [  5]   4.00-5.00   sec  4.23 MBytes  35.4 Mbits/sec    0   42.4 KBytes
> [  5]   5.00-6.00   sec  4.47 MBytes  37.5 Mbits/sec    0   76.4 KBytes
> [  5]   6.00-7.00   sec  5.47 MBytes  45.9 Mbits/sec    0   67.9 KBytes
> [  5]   7.00-8.00   sec  4.66 MBytes  39.1 Mbits/sec    0   67.9 KBytes
> [  5]   8.00-9.00   sec  4.35 MBytes  36.5 Mbits/sec    0   82.0 KBytes
> [  5]   9.00-10.00  sec  4.66 MBytes  39.1 Mbits/sec    0    139 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  45.5 MBytes  38.2 Mbits/sec    0             sender
> [  5]   0.00-10.00  sec  45.0 MBytes  37.8 Mbits/sec                  receiver
>
> You even get some:
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  5.38 MBytes  45.2 Mbits/sec    0   42.4 KBytes
> [  5]   1.00-2.00   sec  7.08 MBytes  59.4 Mbits/sec    0    535 KBytes
> [  5]   2.00-3.00   sec   108 MBytes   907 Mbits/sec    0    778 KBytes
> [  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec    0    814 KBytes
> [  5]   4.00-5.00   sec  91.2 MBytes   765 Mbits/sec    0    829 KBytes
> [  5]   5.00-6.00   sec   111 MBytes   933 Mbits/sec    0    783 KBytes
> [  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    769 KBytes
> [  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    0    778 KBytes
> [  5]   8.00-9.00   sec   112 MBytes   944 Mbits/sec    0    809 KBytes
> [  5]   9.00-10.00  sec   110 MBytes   923 Mbits/sec    0    823 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec   879 MBytes   738 Mbits/sec    0             sender
> [  5]   0.00-10.00  sec   875 MBytes   734 Mbits/sec                  receiver
