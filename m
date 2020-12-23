Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110942E1A03
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLWIdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgLWIdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 03:33:12 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ED8C061793
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 00:32:31 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id u12so14382323ilv.3
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 00:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ys7TFOo2gjAWNRQXOF1XN1cJNsV8BZWzadPZAmkWV1o=;
        b=mvcQTsPksK0HQSXvxYh2rRnlQvY+pvdgdoCxwQPxvuo2qGgzmg0EBjDJur8TNx47FA
         KZ62yzHC50fYUxrJl7Kmv+YE5yQhVC2cuIyfvMY1Ggqzlk8p/glBh1wzO0Ki+03YO3LG
         u+Hi+3jxK9GfncEl+z8MGeoeM5io0tsMjlt4lF2ZDaa+o5io3JxlB1AGKUB6N1PIlLm3
         oCR187KSRNMPZRtKT04Uge4WqrvmPdqBZ/vhHrweEp3ruzLID9+OUfLyxeQMfpE6ML4g
         M0IqmnTxnGzmpiLBW616PVVWzFhPxYheObs+3MVjAhTWY1HeAY0WgU6+3O5qoQ7oqUwA
         yugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ys7TFOo2gjAWNRQXOF1XN1cJNsV8BZWzadPZAmkWV1o=;
        b=NMiWY2ZXW72Fx9xZDtZRjrpxPg98Avs+npQRoPRwAd7A9W+UxSul50Q9uR/UzXQm0q
         GfSHDOdRxwuphPLhKa2RPc/+tweTklur3vGxtYHX+egtSyR26/ZyfnuulgP9PTLqWiP0
         sGMqn+42wLen5yL+3Xb8nf7RAaviBfRhKMAo8d0tNE7b9vcgvaFejvs1cK5iEodUWyEL
         0ghUvTl/alLEgO8c+Nx8gfIOxarigmjbHtEi16OUKfbOOj+9mRes0oq6DvNTYc5iUdkN
         Dcn2kNf/oqJjkXy6pmQlKXX3G8fITgzdyeoqJ3hTK4Ki9+eF1CB/HSZriZdP/d52BgcL
         hd9g==
X-Gm-Message-State: AOAM530nv9WwlKX4whg2M9PYsVAIFMLo00SPdxHPueHwJYiI4sDiO/cv
        IbeTBRZz0bP7yR6cbUye+lm5s4lyjhNBjqsondSSf37LPkNrEF2t
X-Google-Smtp-Source: ABdhPJzQZRaL9GA3a9xVAO3HYfDCP6ZJfJ/ZkR4tQMJh5mg4o6UrcjwYYN0sFnAO0fulcwpJ5IUARWJC0lXV0mXcz6c=
X-Received: by 2002:a92:48d2:: with SMTP id j79mr24265519ilg.201.1608712351083;
 Wed, 23 Dec 2020 00:32:31 -0800 (PST)
MIME-Version: 1.0
References: <CAHZX3B_KBEzny0ejSP73q+1Y-n=f=39jTXjzBCDB8Lsrn5U2gg@mail.gmail.com>
In-Reply-To: <CAHZX3B_KBEzny0ejSP73q+1Y-n=f=39jTXjzBCDB8Lsrn5U2gg@mail.gmail.com>
From:   Bruce Liu <ccieliu@gmail.com>
Date:   Wed, 23 Dec 2020 16:31:52 +0800
Message-ID: <CAHZX3B_JrgbXhEv0FqvmZfVv0qy4W5shjupMj2CzSLHmGstxuA@mail.gmail.com>
Subject: Re: "ethtool" missing "master-slave" args in "do_sset" function.[TEXT/PLAIN]
To:     mkubecek@suse.cz, netdev@vger.kernel.org
Cc:     shlei@cisco.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal Kubecek and Network dev team,

Good day! Hope you are doing well.
This is Bruce from China, and please allow me to cc Rudy from Cisco
Systems in China team.

We are facing a weird behavior about "master-slave configuration"
function in ethtool.
Please correct me if I am wrong....

As you know, start from ethtool 5.8,  "master/slave configuration
support" added.
https://lwn.net/Articles/828044/

========================================================================
Appeal:
Confirm and discuss workaround

========================================================================
Issue description:
As we test in lab, no "master-slave" option supported.

========================================================================
Issue reproduce:
root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
ethtool: bad command line argument(s)
For more information run ethtool -h

========================================================================
Environment:
debian-live-10.7.0-amd64-standard.iso
Kernel 5.4.79
ethtool 5.10
Source code: https://mirrors.edge.kernel.org/pub/software/network/ethtool/ethtool-5.10.tar.xz

========================================================================
Troubleshooting:
root@raspberrypi:~# ethtool -h
ethtool version 5.10
Usage:
        ethtool [ FLAGS ] DEVNAME       Display standard information
about device
        ethtool [ FLAGS ] -s|--change DEVNAME   Change generic options
                [ speed %d ]
                [ duplex half|full ]
                [ port tp|aui|bnc|mii|fibre|da ]
                [ mdix auto|on|off ]
                [ autoneg on|off ]
                [ advertise %x[/%x] | mode on|off ... [--] ]
                [ phyad %d ]
                [ xcvr internal|external ]
                [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]
                [ sopass %x:%x:%x:%x:%x:%x ]
                [ msglvl %d[/%d] | type on|off ... [--] ]
                [ master-slave
master-preferred|slave-preferred|master-force|slave-force ]

root@raspberrypi:~# ethtool -s eth0 [double tab here]
advertise  autoneg    duplex     mdix       msglvl     phyad      port
      speed      wol        xcvr

========================================
Review 5.10 source code:
ethtool.c line:5616

static const struct option args[] = {
{
.opts = "-s|--change",
.func = do_sset,
.nlfunc = nl_sset,
.help = "Change generic options",
.xhelp = " [ speed %d ]\n"
 " [ duplex half|full ]\n"
 " [ port tp|aui|bnc|mii|fibre|da ]\n"
 " [ mdix auto|on|off ]\n"
 " [ autoneg on|off ]\n"
 " [ advertise %x[/%x] | mode on|off ... [--] ]\n"
 " [ phyad %d ]\n"
 " [ xcvr internal|external ]\n"
 " [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
 " [ sopass %x:%x:%x:%x:%x:%x ]\n"
 " [ msglvl %d[/%d] | type on|off ... [--] ]\n"
 " [ master-slave master-preferred|slave-preferred|master-force|slave-force ]\n"
},

========================================
ethtool.c line:2912  do_sset function
There is NOT an "else if" to catch "master-slave" option, and the
options matched final else, and print an error message   "ethtool: bad
command line argument(s)\n""For more information run ethtool -h\n""

ethtool.c line: 3069

  } else {
exit_bad_args();

========================================
root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
ethtool: bad command line argument(s)
For more information run ethtool -h

Look forward to your reply.

Cheers!
Bruce Liu (UTC +08)
Email: ccieliu@gmail.com


Cheers!

Bruce Liu    (UTC +08)
Email: ccieliu@gmail.com



Cheers!

Bruce Liu    (UTC +08)
Email: ccieliu@gmail.com


On Wed, Dec 23, 2020 at 3:49 PM Bruce Liu <ccieliu@gmail.com> wrote:
>
> Hi Michal Kubecek and Network dev team,
>
> Good day! Hope you are doing well.
> This is Bruce from China, and please allow me to cc Rudy from Cisco Systems in China team.
>
> We are facing a weird behavior about "master-slave configuration" function in ethtool.
> Please correct me if I am wrong....
>
> As you know, start from ethtool 5.8,  "master/slave configuration support" added.
> https://lwn.net/Articles/828044/
>
> ========================================================================
> Appeal:
> Confirm and discuss workaround
>
> ========================================================================
> Issue description:
> As we test in lab, no "master-slave" option supported.
>
> ========================================================================
> Issue reproduce:
> root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
> ethtool: bad command line argument(s)
> For more information run ethtool -h
>
> ========================================================================
> Environment:
> debian-live-10.7.0-amd64-standard.iso
> Kernel 5.4.79
> ethtool 5.10
> Source code: https://mirrors.edge.kernel.org/pub/software/network/ethtool/ethtool-5.10.tar.xz
>
> ========================================================================
> Troubleshooting:
> root@raspberrypi:~# ethtool -h
> ethtool version 5.10
> Usage:
>         ethtool [ FLAGS ] DEVNAME       Display standard information about device
>         ethtool [ FLAGS ] -s|--change DEVNAME   Change generic options
>                 [ speed %d ]
>                 [ duplex half|full ]
>                 [ port tp|aui|bnc|mii|fibre|da ]
>                 [ mdix auto|on|off ]
>                 [ autoneg on|off ]
>                 [ advertise %x[/%x] | mode on|off ... [--] ]
>                 [ phyad %d ]
>                 [ xcvr internal|external ]
>                 [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]
>                 [ sopass %x:%x:%x:%x:%x:%x ]
>                 [ msglvl %d[/%d] | type on|off ... [--] ]
>                 [ master-slave master-preferred|slave-preferred|master-force|slave-force ]
>
> root@raspberrypi:~# ethtool -s eth0 [double tab here]
> advertise  autoneg    duplex     mdix       msglvl     phyad      port       speed      wol        xcvr
>
> ========================================
> Review 5.10 source code:
> ethtool.c line:5616
>
> static const struct option args[] = {
> {
> .opts = "-s|--change",
> .func = do_sset,
> .nlfunc = nl_sset,
> .help = "Change generic options",
> .xhelp = " [ speed %d ]\n"
>  " [ duplex half|full ]\n"
>  " [ port tp|aui|bnc|mii|fibre|da ]\n"
>  " [ mdix auto|on|off ]\n"
>  " [ autoneg on|off ]\n"
>  " [ advertise %x[/%x] | mode on|off ... [--] ]\n"
>  " [ phyad %d ]\n"
>  " [ xcvr internal|external ]\n"
>  " [ wol %d[/%d] | p|u|m|b|a|g|s|f|d... ]\n"
>  " [ sopass %x:%x:%x:%x:%x:%x ]\n"
>  " [ msglvl %d[/%d] | type on|off ... [--] ]\n"
>  " [ master-slave master-preferred|slave-preferred|master-force|slave-force ]\n"
> },
>
> ========================================
> ethtool.c line:2912  do_sset function
> There is NOT an "else if" to catch "master-slave" option, and the options matched final else, and print an error message   "ethtool: bad command line argument(s)\n""For more information run ethtool -h\n""
>
> ethtool.c line: 3069
>
>   } else {
> exit_bad_args();
>
> ========================================
> root@raspberrypi:~# ethtool -s eth0 master-slave master-preferred
> ethtool: bad command line argument(s)
> For more information run ethtool -h
>
> Look forward to your reply.
>
> Cheers!
> Bruce Liu (UTC +08)
> Email: ccieliu@gmail.com
