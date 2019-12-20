Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E1F1278BC
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfLTKEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:04:55 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:43888 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfLTKEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 05:04:54 -0500
Received: by mail-qv1-f67.google.com with SMTP id p2so3388615qvo.10;
        Fri, 20 Dec 2019 02:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k5ntohK44y9SzROwbNQOVcdZmF6dV1Js5qOUS4gznT4=;
        b=bAY0QErfi02P10UweYDaTWxvV0kicL5gTI5FzrlFdYox7Tkm9t8aCet1M1VPI1hR/5
         0x42fC7eip7eN6iqRWhtsiroEqbfnSxUrydVkW/hJf6Pb9b8rUw0SRpYmOLX+fsZDZGB
         ckEsT0JM0rS13Joox3lQK0an7D9WuaGuTqPNKbi8O3bCgPVMtVVqyGxv7GuFxfrYDBZj
         CM/SkCZVKZDfoBcpEn9Wfq/44jRGlHJW1l9SQk/c32m7x72gcdVLdEWjdXbcPZVjKJAc
         pqTuRH6LVV+cv8Agvn3xsPrYJFC/jYgg/HtI59hg51uflKHkBiTfQdF4gllNqanFDdbw
         20DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k5ntohK44y9SzROwbNQOVcdZmF6dV1Js5qOUS4gznT4=;
        b=GkOB2cdU1Xz8PjqOr8NZKJSLPsmXp/W57yOmcnyWaAUQqo3ZXaXvp9JTIPpHRt/XvH
         ORiG6w+WWtEJJcN1m1vviWMlqe1Jft8C7evDGiPZIlStkzWLz5ljo8PoqtsjNWOhmTag
         VB5Ta9otUuWBssHHP2JwmUG9vyYXCGIyVoaldUoU+MUyf5Y6rqAASWLe0hlcTMnNUGvJ
         GFssiJoZoA+dq2MJFXqvs7afC1Uki8hqTos1wyXTIJosDi82MmFtD9y5aQ7gCJCeLRoA
         umrRdX6rOuVNzSokFPENHGFcouDbogEQTNPjBX+2Z//aA2kCMKrh4MohEtM3eFG8noRg
         VE/Q==
X-Gm-Message-State: APjAAAUMTLfsY56UQx3BFAgakQDgehTPOfu9BZHMFm/RtO5yEC2wyn4y
        zIVQcKyh8BjPNh/+5shHiLWvtRNeOzg0CgNN3/k=
X-Google-Smtp-Source: APXvYqzlB0SkWr6l0HDkEHm25k6WBxVgglGqtuN6WQG4aU3Fa7ZNpeSN8iylVyH6bcRjIr166ye/pLQYZ1qJoEHXBlQ=
X-Received: by 2002:a0c:e2cf:: with SMTP id t15mr11851582qvl.127.1576836293652;
 Fri, 20 Dec 2019 02:04:53 -0800 (PST)
MIME-Version: 1.0
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
In-Reply-To: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 20 Dec 2019 11:04:42 +0100
Message-ID: <CAJ+HfNjAC-hFdW14yCDSkBUZVmRM=ya+GFyWV5AOYAi8=KBV6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] Enhancements to xdpsock application
To:     Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Dec 2019 at 09:55, Jay Jayatheerthan
<jay.jayatheerthan@intel.com> wrote:
>
> This series of patches enhances xdpsock application with command line
> parameters to set transmit packet size and fill pattern among other optio=
ns.
> The application has also been enhanced to use Linux Ethernet/IP/UDP heade=
r
> structs and calculate IP and UDP checksums.
>
> I have measured the performance of the xdpsock application before and aft=
er
> this patch set and have not been able to detect any difference.
>
> Packet Size:
> ------------
> There is a new option '-s' or '--tx-pkt-size' to specify the transmit pac=
ket
> size. It ranges from 47 to 4096 bytes. Default packet size is 64 bytes
> which is same as before.
>
> Fill Pattern:
> -------------
> The transmit UDP payload fill pattern is specified using '-P' or
> '--tx-pkt-pattern'option. It is an unsigned 32 bit field and defaulted
> to 0x12345678.
>
> Packet Count:
> -------------
> The number of packets to send is specified using '-C' or '--tx-pkt-count'
> option. If it is not specified, the application sends packets forever.
>
> Batch Size:
> -----------
> The batch size for transmit, receive and l2fwd features of the applicatio=
n is
> specified using '-b' or '--batch-size' options. Default value when this o=
ption
> is not provided is 64 (same as before).
>
> Duration:
> ---------
> The application supports '-d' or '--duration' option to specify number of
> seconds to run. This is used in tx, rx and l2fwd features. If this option=
 is
> not provided, the application runs for ever.
>
> This patchset has been applied against commit 99cacdc6f661f50f
> ("Merge branch 'replace-cg_bpf-prog'")
>

Thanks for the hard work! I really like the synchronous cleanup! My
scripts are already using the '-d' flag!

For the series:
Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


> Jay Jayatheerthan (6):
>   samples/bpf: xdpsock: Add duration option to specify how long to run
>   samples/bpf: xdpsock: Use common code to handle signal and main exit
>   samples/bpf: xdpsock: Add option to specify batch size
>   samples/bpf: xdpsock: Add option to specify number of packets to send
>   samples/bpf: xdpsock: Add option to specify tx packet size
>   samples/bpf: xdpsock: Add option to specify transmit fill pattern
>
>  samples/bpf/xdpsock_user.c | 426 +++++++++++++++++++++++++++++++++----
>  1 file changed, 387 insertions(+), 39 deletions(-)
>
> --
> 2.17.1
>
