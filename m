Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2210A2CD653
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgLCNCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLCNB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:01:59 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ED0C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 05:01:18 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id y18so1867309qki.11
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BlFupbAyMY7MvCqKv2dKajN7rmT2PeiSLlIDh3Oih5w=;
        b=ccb1UOYbt4mdIcXmePhLSmFbx7icDZSNPTAJE+WybpUngbnnIR3ueUfRLRAiQOTWff
         hSZqV3xgCEQ4C8sb5KLwEDup+R9NqUgfT9wS4ytj+wqdWoRFPoW/gyf4ffNnbN0YXhiX
         iiHZgZljjbaC4Ko4cY/sA0b9/+CNea0HU0JuFoh7D0flIeQu+duisgO+gIV0vEMnZ1Db
         vE8Rx4DCg3PjVEVauvVrDxYqm5BBBZzkmsS11Pvjyn4Yxct4zVP9PCi8BIzx6inCYfbh
         OVRsWJQ9Vonh7WU2OTbyWlk5vVx59vyP7f9AQiIFgxfyFSCnh0J8egpPMyyvwfsTHsGU
         2HmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BlFupbAyMY7MvCqKv2dKajN7rmT2PeiSLlIDh3Oih5w=;
        b=R8vpjVio1XRpxAErM0VrdkeFVOJVK06VrpxPEAPvvmv2ghv4FrRNH+zOHm2TZND4vG
         VFcsZ3rca6He2OSHt4ZmKvnr4vTedZLA8Bo27IEonA4zFzjX39LIeztBiNf9Zxb9bnsh
         lRMx8FDjibGkpkOiIrCLoyERGAGJTbwwT9vIeOvja4hE2UePPZ5LUkLEOP+sIioj8D+h
         sZR+IDJKf+iSSLbgoF+zuhH91G3E5gh09hLdeAyQUE5Rqsj7a3gZtT570K88BUguLqRj
         76pW9vi2Ie3eUbMtBiGo8RnXabk/wIAfD3HAI/WEuQBBAGrzicSsLabGNgrSlYBmBymk
         Tj/Q==
X-Gm-Message-State: AOAM531Qo2WRkwBk2fgTYCwLjIN2DWY2a9DSJnPnHqVxR7axQQDx6xsW
        RyR4tKKoUbIJKXM2j6fgEQ==
X-Google-Smtp-Source: ABdhPJzhubpTqZ9+NmsplSe97diq1yyGyU4AG/MMDmK2Y9FmEDP9cxITk3ztvMarWp1/BJAa8weuDw==
X-Received: by 2002:a37:9b0b:: with SMTP id d11mr2633878qke.129.1607000478110;
        Thu, 03 Dec 2020 05:01:18 -0800 (PST)
Received: from vmserver ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id q18sm1285129qkn.96.2020.12.03.05.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:01:17 -0800 (PST)
Date:   Thu, 3 Dec 2020 08:01:09 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: VRF NS for lladdr sent on the wrong interface
Message-ID: <20201203130109.GA26743@vmserver>
References: <20201124002345.GA42222@ubuntu>
 <c04221cc-b407-4b30-4631-b405209853a3@gmail.com>
 <20201201190055.GA16436@ICIPI.localdomain>
 <70557d4f-cf35-ddba-391c-c66aa8ca242a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <70557d4f-cf35-ddba-391c-c66aa8ca242a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 01, 2020 at 06:06:53PM -0700, David Ahern wrote:
> >>
> >> With your patch does ping from both hosts work?
> > 
> > Yes, it does.
> > 
> >> What about all of the tests in
> >> tools/testing/selftests/net/fcnal-test.sh? specifically curious about
> >> the 'LLA to GUA' tests (link local to global). Perhaps those tests need
> >> a second interface (e.g., a dummy) that is brought up first to cause the
> >> ordering to be different.
> > 
> > The script needs nettest to be in the path...
> > 
> 
> nettest is in the same directory. Build it and then run the script -
> with your patch applied. We need to see if it affects existing tests.

The tests in fcnal-test.sh passed. There are two failures that are
expected, I think. Attached is the output.

If you agree that my patch is the right solution, I can send the patch
out for review.

Thanks,
Stephen.

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fcnal-test-output.txt"


###########################################################################
IPv4 ping
###########################################################################


#################################################################
No VRF

SYSCTL: net.ipv4.raw_l3mdev_accept=0

TEST: ping out - ns-B IP                                                      [ OK ]
TEST: ping out, device bind - ns-B IP                                         [ OK ]
TEST: ping out, address bind - ns-B IP                                        [ OK ]
TEST: ping out - ns-B loopback IP                                             [ OK ]
TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
TEST: ping out, address bind - ns-B loopback IP                               [ OK ]
TEST: ping in - ns-A IP                                                       [ OK ]
TEST: ping in - ns-A loopback IP                                              [ OK ]
TEST: ping local - ns-A IP                                                    [ OK ]
TEST: ping local - ns-A loopback IP                                           [ OK ]
TEST: ping local - loopback                                                   [ OK ]
TEST: ping local, device bind - ns-A IP                                       [ OK ]
TEST: ping local, device bind - ns-A loopback IP                              [ OK ]
TEST: ping local, device bind - loopback                                      [ OK ]
TEST: ping out, blocked by rule - ns-B loopback IP                            [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IP                             [ OK ]
TEST: ping out, blocked by route - ns-B loopback IP                           [ OK ]
TEST: ping in, blocked by route - ns-A loopback IP                            [ OK ]
TEST: ping out, unreachable default route - ns-B loopback IP                  [ OK ]
SYSCTL: net.ipv4.raw_l3mdev_accept=1

TEST: ping out - ns-B IP                                                      [ OK ]
TEST: ping out, device bind - ns-B IP                                         [ OK ]
TEST: ping out, address bind - ns-B IP                                        [ OK ]
TEST: ping out - ns-B loopback IP                                             [ OK ]
TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
TEST: ping out, address bind - ns-B loopback IP                               [ OK ]
TEST: ping in - ns-A IP                                                       [ OK ]
TEST: ping in - ns-A loopback IP                                              [ OK ]
TEST: ping local - ns-A IP                                                    [ OK ]
TEST: ping local - ns-A loopback IP                                           [ OK ]
TEST: ping local - loopback                                                   [ OK ]
TEST: ping local, device bind - ns-A IP                                       [ OK ]
TEST: ping local, device bind - ns-A loopback IP                              [ OK ]
TEST: ping local, device bind - loopback                                      [ OK ]
TEST: ping out, blocked by rule - ns-B loopback IP                            [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IP                             [ OK ]
TEST: ping out, blocked by route - ns-B loopback IP                           [ OK ]
TEST: ping in, blocked by route - ns-A loopback IP                            [ OK ]
TEST: ping out, unreachable default route - ns-B loopback IP                  [ OK ]

#################################################################
With VRF

SYSCTL: net.ipv4.raw_l3mdev_accept=1

TEST: ping out, VRF bind - ns-B IP                                            [ OK ]
TEST: ping out, device bind - ns-B IP                                         [ OK ]
TEST: ping out, vrf device + dev address bind - ns-B IP                       [ OK ]
TEST: ping out, vrf device + vrf address bind - ns-B IP                       [ OK ]
TEST: ping out, VRF bind - ns-B loopback IP                                   [ OK ]
TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
TEST: ping out, vrf device + dev address bind - ns-B loopback IP              [ OK ]
TEST: ping out, vrf device + vrf address bind - ns-B loopback IP              [ OK ]
TEST: ping in - ns-A IP                                                       [ OK ]
TEST: ping in - VRF IP                                                        [ OK ]
TEST: ping local, VRF bind - ns-A IP                                          [ OK ]
TEST: ping local, VRF bind - VRF IP                                           [ OK ]
TEST: ping local, VRF bind - loopback                                         [ OK ]
TEST: ping local, device bind - ns-A IP                                       [ OK ]
TEST: ping local, device bind - VRF IP                                        [ OK ]
TEST: ping local, device bind - loopback                                      [ OK ]
TEST: ping out, vrf bind, blocked by rule - ns-B loopback IP                  [ OK ]
TEST: ping out, device bind, blocked by rule - ns-B loopback IP               [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IP                             [ OK ]
TEST: ping out, vrf bind, unreachable route - ns-B loopback IP                [ OK ]
TEST: ping out, device bind, unreachable route - ns-B loopback IP             [ OK ]
TEST: ping in, unreachable route - ns-A loopback IP                           [ OK ]

###########################################################################
IPv4/TCP
###########################################################################


#################################################################
No VRF


#################################################################
tcp_l3mdev_accept disabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=0

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: Global server - ns-A loopback IP                                        [ OK ]
TEST: Device server - ns-A IP                                                 [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: No server - ns-A loopback IP                                            [ OK ]
TEST: Client - ns-B IP                                                        [ OK ]
TEST: Client, device bind - ns-B IP                                           [ OK ]
TEST: No server, unbound client - ns-B IP                                     [ OK ]
TEST: No server, device client - ns-B IP                                      [ OK ]
TEST: Client - ns-B loopback IP                                               [ OK ]
TEST: Client, device bind - ns-B loopback IP                                  [ OK ]
TEST: No server, unbound client - ns-B loopback IP                            [ OK ]
TEST: No server, device client - ns-B loopback IP                             [ OK ]
TEST: Global server, local connection - ns-A IP                               [ OK ]
TEST: Global server, local connection - ns-A loopback IP                      [ OK ]
TEST: Global server, local connection - loopback                              [ OK ]
TEST: Device server, unbound client, local connection - ns-A IP               [ OK ]
TEST: Device server, unbound client, local connection - ns-A loopback IP      [ OK ]
TEST: Device server, unbound client, local connection - loopback              [ OK ]
TEST: Global server, device client, local connection - ns-A IP                [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IP       [ OK ]
TEST: Global server, device client, local connection - loopback               [ OK ]
TEST: Device server, device client, local connection - ns-A IP                [ OK ]
TEST: No server, device client, local conn - ns-A IP                          [ OK ]
TEST: MD5: Single address config                                              [ OK ]
TEST: MD5: Server no config, client uses password                             [ OK ]
TEST: MD5: Client uses wrong password                                         [ OK ]
TEST: MD5: Client address does not match address configured with password     [ OK ]
TEST: MD5: Prefix config                                                      [ OK ]
TEST: MD5: Prefix config, client uses wrong password                          [ OK ]
TEST: MD5: Prefix config, client address not in configured prefix             [ OK ]

#################################################################
tcp_l3mdev_accept enabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=1

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: Global server - ns-A loopback IP                                        [ OK ]
TEST: Device server - ns-A IP                                                 [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: No server - ns-A loopback IP                                            [ OK ]
TEST: Client - ns-B IP                                                        [ OK ]
TEST: Client, device bind - ns-B IP                                           [ OK ]
TEST: No server, unbound client - ns-B IP                                     [ OK ]
TEST: No server, device client - ns-B IP                                      [ OK ]
TEST: Client - ns-B loopback IP                                               [ OK ]
TEST: Client, device bind - ns-B loopback IP                                  [ OK ]
TEST: No server, unbound client - ns-B loopback IP                            [ OK ]
TEST: No server, device client - ns-B loopback IP                             [ OK ]
TEST: Global server, local connection - ns-A IP                               [ OK ]
TEST: Global server, local connection - ns-A loopback IP                      [ OK ]
TEST: Global server, local connection - loopback                              [ OK ]
TEST: Device server, unbound client, local connection - ns-A IP               [ OK ]
TEST: Device server, unbound client, local connection - ns-A loopback IP      [ OK ]
TEST: Device server, unbound client, local connection - loopback              [ OK ]
TEST: Global server, device client, local connection - ns-A IP                [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IP       [ OK ]
TEST: Global server, device client, local connection - loopback               [ OK ]
TEST: Device server, device client, local connection - ns-A IP                [ OK ]
TEST: No server, device client, local conn - ns-A IP                          [ OK ]
TEST: MD5: Single address config                                              [ OK ]
TEST: MD5: Server no config, client uses password                             [ OK ]
TEST: MD5: Client uses wrong password                                         [ OK ]
TEST: MD5: Client address does not match address configured with password     [ OK ]
TEST: MD5: Prefix config                                                      [ OK ]
TEST: MD5: Prefix config, client uses wrong password                          [ OK ]
TEST: MD5: Prefix config, client address not in configured prefix             [ OK ]

#################################################################
With VRF


#################################################################
Global server disabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=0

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: VRF server - ns-A IP                                                    [ OK ]
TEST: Device server - ns-A IP                                                 [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: Global server - VRF IP                                                  [ OK ]
TEST: VRF server - VRF IP                                                     [ OK ]
TEST: Device server - VRF IP                                                  [ OK ]
TEST: No server - VRF IP                                                      [ OK ]
TEST: Global server, local connection - ns-A IP                               [ OK ]
TEST: MD5: VRF: Single address config                                         [ OK ]
TEST: MD5: VRF: Server no config, client uses password                        [ OK ]
TEST: MD5: VRF: Client uses wrong password                                    [ OK ]
TEST: MD5: VRF: Client address does not match address configured with password  [ OK ]
TEST: MD5: VRF: Prefix config                                                 [ OK ]
TEST: MD5: VRF: Prefix config, client uses wrong password                     [ OK ]
TEST: MD5: VRF: Prefix config, client address not in configured prefix        [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in VRF     [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in default VRF  [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw  [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw  [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in VRF             [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF     [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw  [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw  [ OK ]
TEST: MD5: VRF: Device must be a VRF - single address                         [ OK ]
TEST: MD5: VRF: Device must be a VRF - prefix                                 [ OK ]

#################################################################
VRF Global server enabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=1

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: VRF server - ns-A IP                                                    [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: Global server - VRF IP                                                  [ OK ]
TEST: VRF server - VRF IP                                                     [ OK ]
TEST: No server - VRF IP                                                      [ OK ]
TEST: Device server - ns-A IP                                                 [ OK ]
TEST: Global server, local connection - ns-A IP                               [ OK ]
TEST: Global server, local connection - VRF IP                                [ OK ]
TEST: Client, VRF bind - ns-B IP                                              [ OK ]
TEST: Client, device bind - ns-B IP                                           [ OK ]
TEST: No server, VRF client - ns-B IP                                         [ OK ]
TEST: No server, device client - ns-B IP                                      [ OK ]
TEST: Client, VRF bind - ns-B loopback IP                                     [ OK ]
TEST: Client, device bind - ns-B loopback IP                                  [ OK ]
TEST: No server, VRF client - ns-B loopback IP                                [ OK ]
TEST: No server, device client - ns-B loopback IP                             [ OK ]
TEST: VRF server, VRF client, local connection - ns-A IP                      [ OK ]
TEST: VRF server, VRF client, local connection - VRF IP                       [ OK ]
TEST: VRF server, VRF client, local connection - loopback                     [ OK ]
TEST: VRF server, device client, local connection - ns-A IP                   [ OK ]
TEST: VRF server, unbound client, local connection - ns-A IP                  [ OK ]
TEST: Device server, VRF client, local connection - ns-A IP                   [ OK ]
TEST: Device server, device client, local connection - ns-A IP                [ OK ]

###########################################################################
IPv4/UDP
###########################################################################


#################################################################
No VRF


#################################################################
udp_l3mdev_accept disabled

SYSCTL: net.ipv4.udp_l3mdev_accept=0

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: Global server - ns-A loopback IP                                        [ OK ]
TEST: No server - ns-A loopback IP                                            [ OK ]
TEST: Device server - ns-A IP                                                 [ OK ]
TEST: Client - ns-B IP                                                        [ OK ]
TEST: Client, device bind - ns-B IP                                           [ OK ]
TEST: Client, device send via cmsg - ns-B IP                                  [ OK ]
TEST: Client, device bind via IP_UNICAST_IF - ns-B IP                         [ OK ]
TEST: No server, unbound client - ns-B IP                                     [ OK ]
TEST: No server, device client - ns-B IP                                      [ OK ]
TEST: Client - ns-B loopback IP                                               [ OK ]
TEST: Client, device bind - ns-B loopback IP                                  [ OK ]
TEST: Client, device send via cmsg - ns-B loopback IP                         [ OK ]
TEST: Client, device bind via IP_UNICAST_IF - ns-B loopback IP                [ OK ]
TEST: No server, unbound client - ns-B loopback IP                            [ OK ]
TEST: No server, device client - ns-B loopback IP                             [ OK ]
TEST: Global server, local connection - ns-A IP                               [ OK ]
TEST: Global server, local connection - ns-A loopback IP                      [ OK ]
TEST: Global server, local connection - loopback                              [ OK ]
TEST: Device server, unbound client, local connection - ns-A IP               [ OK ]
TEST: Device server, unbound client, local connection - ns-A loopback IP      [ OK ]
TEST: Device server, unbound client, local connection - loopback              [ OK ]
TEST: Global server, device client, local connection - ns-A IP                [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A IP         [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A IP  [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IP       [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A loopback IP  [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A loopback IP  [ OK ]
TEST: Global server, device client, local connection - loopback               [ OK ]
TEST: Global server, device send via cmsg, local connection - loopback        [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - loopback  [ OK ]
TEST: Device server, device client, local conn - ns-A IP                      [ OK ]
TEST: No server, device client, local conn - ns-A IP                          [ OK ]

#################################################################
udp_l3mdev_accept enabled

SYSCTL: net.ipv4.udp_l3mdev_accept=1

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: Global server - ns-A loopback IP                                        [ OK ]
TEST: No server - ns-A loopback IP                                            [ OK ]
TEST: Device server - ns-A IP                                                 [ OK ]
TEST: Client - ns-B IP                                                        [ OK ]
TEST: Client, device bind - ns-B IP                                           [ OK ]
TEST: Client, device send via cmsg - ns-B IP                                  [ OK ]
TEST: Client, device bind via IP_UNICAST_IF - ns-B IP                         [ OK ]
TEST: No server, unbound client - ns-B IP                                     [ OK ]
TEST: No server, device client - ns-B IP                                      [ OK ]
TEST: Client - ns-B loopback IP                                               [ OK ]
TEST: Client, device bind - ns-B loopback IP                                  [ OK ]
TEST: Client, device send via cmsg - ns-B loopback IP                         [ OK ]
TEST: Client, device bind via IP_UNICAST_IF - ns-B loopback IP                [ OK ]
TEST: No server, unbound client - ns-B loopback IP                            [ OK ]
TEST: No server, device client - ns-B loopback IP                             [ OK ]
TEST: Global server, local connection - ns-A IP                               [ OK ]
TEST: Global server, local connection - ns-A loopback IP                      [ OK ]
TEST: Global server, local connection - loopback                              [ OK ]
TEST: Device server, unbound client, local connection - ns-A IP               [ OK ]
TEST: Device server, unbound client, local connection - ns-A loopback IP      [ OK ]
TEST: Device server, unbound client, local connection - loopback              [ OK ]
TEST: Global server, device client, local connection - ns-A IP                [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A IP         [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A IP  [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IP       [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A loopback IP  [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A loopback IP  [ OK ]
TEST: Global server, device client, local connection - loopback               [ OK ]
TEST: Global server, device send via cmsg, local connection - loopback        [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - loopback  [ OK ]
TEST: Device server, device client, local conn - ns-A IP                      [ OK ]
TEST: No server, device client, local conn - ns-A IP                          [ OK ]

#################################################################
With VRF


#################################################################
Global server disabled

SYSCTL: net.ipv4.udp_l3mdev_accept=0

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: VRF server - ns-A IP                                                    [ OK ]
TEST: Enslaved device server - ns-A IP                                        [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: Global server, VRF client, local connection - ns-A IP                   [ OK ]
TEST: Global server - VRF IP                                                  [ OK ]
TEST: VRF server - VRF IP                                                     [ OK ]
TEST: Enslaved device server - VRF IP                                         [ OK ]
TEST: No server - VRF IP                                                      [ OK ]
TEST: Global server, VRF client, local connection - VRF IP                    [ OK ]
TEST: VRF server, VRF client, local conn - ns-A IP                            [ OK ]
TEST: VRF server, enslaved device client, local connection - ns-A IP          [ OK ]
TEST: Enslaved device server, VRF client, local conn - ns-A IP                [ OK ]
TEST: Enslaved device server, device client, local conn - ns-A IP             [ OK ]

#################################################################
Global server enabled

SYSCTL: net.ipv4.udp_l3mdev_accept=1

TEST: Global server - ns-A IP                                                 [ OK ]
TEST: VRF server - ns-A IP                                                    [ OK ]
TEST: Enslaved device server - ns-A IP                                        [ OK ]
TEST: No server - ns-A IP                                                     [ OK ]
TEST: Global server - VRF IP                                                  [ OK ]
TEST: VRF server - VRF IP                                                     [ OK ]
TEST: Enslaved device server - VRF IP                                         [ OK ]
TEST: No server - VRF IP                                                      [ OK ]
TEST: VRF client                                                              [ OK ]
TEST: Enslaved device client                                                  [ OK ]
TEST: No server, VRF client                                                   [ OK ]
TEST: No server, enslaved device client                                       [ OK ]
TEST: Global server, VRF client, local conn - ns-A IP                         [ OK ]
TEST: VRF server, VRF client, local conn - ns-A IP                            [ OK ]
TEST: VRF server, device client, local conn - ns-A IP                         [ OK ]
TEST: Enslaved device server, VRF client, local conn - ns-A IP                [ OK ]
TEST: Enslaved device server, device client, local conn - ns-A IP             [ OK ]
TEST: Global server, VRF client, local conn - VRF IP                          [ OK ]
TEST: Global server, VRF client, local conn - loopback                        [ OK ]
TEST: VRF server, VRF client, local conn - VRF IP                             [ OK ]
TEST: VRF server, VRF client, local conn - loopback                           [ OK ]
TEST: No server, VRF client, local conn - ns-A IP                             [ OK ]
TEST: No server, VRF client, local conn - VRF IP                              [ OK ]
TEST: No server, VRF client, local conn - loopback                            [ OK ]

###########################################################################
Run time tests - ipv4
###########################################################################

TEST: Device delete with active traffic - ping in - ns-A IP                   [ OK ]
TEST: Device delete with active traffic - ping in - VRF IP                    [ OK ]
TEST: Device delete with active traffic - ping out - ns-B IP                  [ OK ]
TEST: TCP active socket, global server - ns-A IP                              [ OK ]
TEST: TCP active socket, global server - VRF IP                               [ OK ]
TEST: TCP active socket, VRF server - ns-A IP                                 [ OK ]
TEST: TCP active socket, VRF server - VRF IP                                  [ OK ]
TEST: TCP active socket, enslaved device server - ns-A IP                     [ OK ]
TEST: TCP active socket, VRF client - ns-A IP                                 [ OK ]
TEST: TCP active socket, enslaved device client - ns-A IP                     [ OK ]
TEST: TCP active socket, global server, VRF client, local - ns-A IP           [ OK ]
TEST: TCP active socket, global server, VRF client, local - VRF IP            [ OK ]
TEST: TCP active socket, VRF server and client, local - ns-A IP               [ OK ]
TEST: TCP active socket, VRF server and client, local - VRF IP                [ OK ]
TEST: TCP active socket, global server, enslaved device client, local - ns-A IP  [ OK ]
TEST: TCP active socket, VRF server, enslaved device client, local - ns-A IP  [ OK ]
TEST: TCP active socket, enslaved device server and client, local - ns-A IP   [ OK ]
TEST: TCP passive socket, global server - ns-A IP                             [ OK ]
TEST: TCP passive socket, global server - VRF IP                              [ OK ]
TEST: TCP passive socket, VRF server - ns-A IP                                [ OK ]
TEST: TCP passive socket, VRF server - VRF IP                                 [ OK ]
TEST: TCP passive socket, enslaved device server - ns-A IP                    [ OK ]
TEST: TCP passive socket, VRF client - ns-A IP                                [ OK ]
TEST: TCP passive socket, enslaved device client - ns-A IP                    [ OK ]
TEST: TCP passive socket, global server, VRF client, local - ns-A IP          [ OK ]
TEST: TCP passive socket, global server, VRF client, local - VRF IP           [ OK ]
TEST: TCP passive socket, VRF server and client, local - ns-A IP              [ OK ]
TEST: TCP passive socket, VRF server and client, local - VRF IP               [ OK ]
TEST: TCP passive socket, global server, enslaved device client, local - ns-A IP  [ OK ]
TEST: TCP passive socket, VRF server, enslaved device client, local - ns-A IP  [ OK ]
TEST: TCP passive socket, enslaved device server and client, local - ns-A IP  [ OK ]

###########################################################################
IPv4 Netfilter
###########################################################################


#################################################################
TCP reset

TEST: Global server, reject with TCP-reset on Rx - ns-A IP                    [ OK ]
TEST: Global server, reject with TCP-reset on Rx - VRF IP                     [ OK ]

#################################################################
ICMP unreachable

TEST: Global TCP server, Rx reject icmp-port-unreach - ns-A IP                [ OK ]
TEST: Global TCP server, Rx reject icmp-port-unreach - VRF IP                 [ OK ]
TEST: Global UDP server, Rx reject icmp-port-unreach - ns-A IP                [ OK ]
TEST: Global UDP server, Rx reject icmp-port-unreach - VRF IP                 [ OK ]

###########################################################################
IPv6 ping
###########################################################################


#################################################################
No VRF

SYSCTL: net.ipv4.raw_l3mdev_accept=0

TEST: ping out - ns-B IPv6                                                    [ OK ]
TEST: ping out - ns-B loopback IPv6                                           [ OK ]
TEST: ping out - ns-B IPv6 LLA                                                [ OK ]
TEST: ping out - multicast IP                                                 [ OK ]
TEST: ping out, device bind - ns-B IPv6                                       [ OK ]
TEST: ping out, loopback address bind - ns-B IPv6                             [ OK ]
TEST: ping out, device bind - ns-B loopback IPv6                              [ OK ]
TEST: ping out, loopback address bind - ns-B loopback IPv6                    [ OK ]
TEST: ping in - ns-A IPv6                                                     [ OK ]
TEST: ping in - ns-A loopback IPv6                                            [ OK ]
TEST: ping in - ns-A IPv6 LLA                                                 [ OK ]
TEST: ping in - multicast IP                                                  [ OK ]
TEST: ping local, no bind - ns-A IPv6                                         [ OK ]
TEST: ping local, no bind - ns-A loopback IPv6                                [ OK ]
TEST: ping local, no bind - IPv6 loopback                                     [ OK ]
TEST: ping local, no bind - ns-A IPv6 LLA                                     [ OK ]
TEST: ping local, no bind - multicast IP                                      [ OK ]
TEST: ping local, device bind - ns-A IPv6                                     [ OK ]
TEST: ping local, device bind - ns-A IPv6 LLA                                 [ OK ]
TEST: ping local, device bind - multicast IP                                  [ OK ]
TEST: ping local, device bind - ns-A loopback IPv6                            [ OK ]
TEST: ping local, device bind - IPv6 loopback                                 [ OK ]
TEST: ping out, blocked by rule - ns-B loopback IPv6                          [ OK ]
TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6             [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IPv6                           [ OK ]
TEST: ping out, blocked by route - ns-B loopback IPv6                         [ OK ]
TEST: ping out, device bind, blocked by route - ns-B loopback IPv6            [ OK ]
TEST: ping in, blocked by route - ns-A loopback IPv6                          [ OK ]
TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]

#################################################################
With VRF

SYSCTL: net.ipv4.raw_l3mdev_accept=1

TEST: ping out, VRF bind - ns-B IPv6                                          [ OK ]
TEST: ping out, VRF bind - ns-B loopback IPv6                                 [ OK ]
TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [FAIL]
TEST: ping out, VRF bind - multicast IP                                       [FAIL]
TEST: ping out, device bind - ns-B IPv6                                       [ OK ]
TEST: ping out, device bind - ns-B loopback IPv6                              [ OK ]
TEST: ping out, device bind - ns-B IPv6 LLA                                   [ OK ]
TEST: ping out, device bind - multicast IP                                    [ OK ]
TEST: ping out, vrf device+address bind - ns-B IPv6                           [ OK ]
TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [ OK ]
TEST: ping in - ns-A IPv6                                                     [ OK ]
TEST: ping in - VRF IPv6                                                      [ OK ]
TEST: ping in - ns-A IPv6 LLA                                                 [ OK ]
TEST: ping in - multicast IP                                                  [ OK ]
TEST: ping in - ns-A loopback IPv6                                            [ OK ]
TEST: ping local, VRF bind - ns-A IPv6                                        [ OK ]
TEST: ping local, VRF bind - VRF IPv6                                         [ OK ]
TEST: ping local, VRF bind - IPv6 loopback                                    [ OK ]
TEST: ping local, device bind - ns-A IPv6                                     [ OK ]
TEST: ping local, device bind - ns-A IPv6 LLA                                 [ OK ]
TEST: ping local, device bind - multicast IP                                  [ OK ]
TEST: ping in, LLA to GUA - ns-A IPv6                                         [ OK ]
TEST: ping in, LLA to GUA - VRF IPv6                                          [ OK ]
TEST: ping out, blocked by rule - ns-B loopback IPv6                          [ OK ]
TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6             [ OK ]
TEST: ping in, blocked by rule - ns-A loopback IPv6                           [ OK ]
TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]
TEST: ping in, unreachable route - ns-A loopback IPv6                         [ OK ]

###########################################################################
IPv6/TCP
###########################################################################


#################################################################
No VRF


#################################################################
tcp_l3mdev_accept disabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=0

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Global server - ns-A loopback IPv6                                      [ OK ]
TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - ns-A loopback IPv6                                          [ OK ]
TEST: No server - ns-A IPv6 LLA                                               [ OK ]
TEST: Client - ns-B IPv6                                                      [ OK ]
TEST: Client - ns-B loopback IPv6                                             [ OK ]
TEST: Client - ns-B IPv6 LLA                                                  [ OK ]
TEST: Client, device bind - ns-B IPv6                                         [ OK ]
TEST: Client, device bind - ns-B loopback IPv6                                [ OK ]
TEST: Client, device bind - ns-B IPv6 LLA                                     [ OK ]
TEST: No server, device client - ns-B IPv6                                    [ OK ]
TEST: No server, device client - ns-B loopback IPv6                           [ OK ]
TEST: No server, device client - ns-B IPv6 LLA                                [ OK ]
TEST: Global server, local connection - ns-A IPv6                             [ OK ]
TEST: Global server, local connection - ns-A loopback IPv6                    [ OK ]
TEST: Global server, local connection - IPv6 loopback                         [ OK ]
TEST: Device server, unbound client, local connection - ns-A IPv6             [ OK ]
TEST: Device server, unbound client, local connection - ns-A loopback IPv6    [ OK ]
TEST: Device server, unbound client, local connection - IPv6 loopback         [ OK ]
TEST: Global server, device client, local connection - ns-A IPv6              [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IPv6     [ OK ]
TEST: Global server, device client, local connection - IPv6 loopback          [ OK ]
TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
TEST: Device server, device client, local conn - ns-A IPv6 LLA                [ OK ]
TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
TEST: No server, device client, local conn - ns-A IPv6 LLA                    [ OK ]
TEST: MD5: Single address config                                              [ OK ]
TEST: MD5: Server no config, client uses password                             [ OK ]
TEST: MD5: Client uses wrong password                                         [ OK ]
TEST: MD5: Client address does not match address configured with password     [ OK ]
TEST: MD5: Prefix config                                                      [ OK ]
TEST: MD5: Prefix config, client uses wrong password                          [ OK ]
TEST: MD5: Prefix config, client address not in configured prefix             [ OK ]

#################################################################
tcp_l3mdev_accept enabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=1

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Global server - ns-A loopback IPv6                                      [ OK ]
TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - ns-A loopback IPv6                                          [ OK ]
TEST: No server - ns-A IPv6 LLA                                               [ OK ]
TEST: Client - ns-B IPv6                                                      [ OK ]
TEST: Client - ns-B loopback IPv6                                             [ OK ]
TEST: Client - ns-B IPv6 LLA                                                  [ OK ]
TEST: Client, device bind - ns-B IPv6                                         [ OK ]
TEST: Client, device bind - ns-B loopback IPv6                                [ OK ]
TEST: Client, device bind - ns-B IPv6 LLA                                     [ OK ]
TEST: No server, device client - ns-B IPv6                                    [ OK ]
TEST: No server, device client - ns-B loopback IPv6                           [ OK ]
TEST: No server, device client - ns-B IPv6 LLA                                [ OK ]
TEST: Global server, local connection - ns-A IPv6                             [ OK ]
TEST: Global server, local connection - ns-A loopback IPv6                    [ OK ]
TEST: Global server, local connection - IPv6 loopback                         [ OK ]
TEST: Device server, unbound client, local connection - ns-A IPv6             [ OK ]
TEST: Device server, unbound client, local connection - ns-A loopback IPv6    [ OK ]
TEST: Device server, unbound client, local connection - IPv6 loopback         [ OK ]
TEST: Global server, device client, local connection - ns-A IPv6              [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IPv6     [ OK ]
TEST: Global server, device client, local connection - IPv6 loopback          [ OK ]
TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
TEST: Device server, device client, local conn - ns-A IPv6 LLA                [ OK ]
TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
TEST: No server, device client, local conn - ns-A IPv6 LLA                    [ OK ]
TEST: MD5: Single address config                                              [ OK ]
TEST: MD5: Server no config, client uses password                             [ OK ]
TEST: MD5: Client uses wrong password                                         [ OK ]
TEST: MD5: Client address does not match address configured with password     [ OK ]
TEST: MD5: Prefix config                                                      [ OK ]
TEST: MD5: Prefix config, client uses wrong password                          [ OK ]
TEST: MD5: Prefix config, client address not in configured prefix             [ OK ]

#################################################################
With VRF


#################################################################
Global server disabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=0

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Global server - VRF IPv6                                                [ OK ]
TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
TEST: VRF server - ns-A IPv6                                                  [ OK ]
TEST: VRF server - VRF IPv6                                                   [ OK ]
TEST: VRF server - ns-A IPv6 LLA                                              [ OK ]
TEST: Device server - ns-A IPv6                                               [ OK ]
TEST: Device server - VRF IPv6                                                [ OK ]
TEST: Device server - ns-A IPv6 LLA                                           [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - VRF IPv6                                                    [ OK ]
TEST: No server - ns-A IPv6 LLA                                               [ OK ]
TEST: Global server, local connection - ns-A IPv6                             [ OK ]
TEST: MD5: VRF: Single address config                                         [ OK ]
TEST: MD5: VRF: Server no config, client uses password                        [ OK ]
TEST: MD5: VRF: Client uses wrong password                                    [ OK ]
TEST: MD5: VRF: Client address does not match address configured with password  [ OK ]
TEST: MD5: VRF: Prefix config                                                 [ OK ]
TEST: MD5: VRF: Prefix config, client uses wrong password                     [ OK ]
TEST: MD5: VRF: Prefix config, client address not in configured prefix        [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in VRF     [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in default VRF  [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw  [ OK ]
TEST: MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw  [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in VRF             [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF     [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw  [ OK ]
TEST: MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw  [ OK ]
TEST: MD5: VRF: Device must be a VRF - single address                         [ OK ]
TEST: MD5: VRF: Device must be a VRF - prefix                                 [ OK ]

#################################################################
VRF Global server enabled

SYSCTL: net.ipv4.tcp_l3mdev_accept=1

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Global server - VRF IPv6                                                [ OK ]
TEST: VRF server - ns-A IPv6                                                  [ OK ]
TEST: VRF server - VRF IPv6                                                   [ OK ]
TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
TEST: VRF server - ns-A IPv6 LLA                                              [ OK ]
TEST: Device server - ns-A IPv6                                               [ OK ]
TEST: Device server - ns-A IPv6 LLA                                           [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - VRF IPv6                                                    [ OK ]
TEST: No server - ns-A IPv6 LLA                                               [ OK ]
TEST: Global server, local connection - ns-A IPv6                             [ OK ]
TEST: Global server, local connection - VRF IPv6                              [ OK ]
TEST: Client, VRF bind - ns-B IPv6                                            [ OK ]
TEST: Client, VRF bind - ns-B loopback IPv6                                   [ OK ]
TEST: Client, VRF bind - ns-B IPv6 LLA                                        [ OK ]
TEST: Client, device bind - ns-B IPv6                                         [ OK ]
TEST: Client, device bind - ns-B loopback IPv6                                [ OK ]
TEST: Client, device bind - ns-B IPv6 LLA                                     [ OK ]
TEST: No server, VRF client - ns-B IPv6                                       [ OK ]
TEST: No server, VRF client - ns-B loopback IPv6                              [ OK ]
TEST: No server, device client - ns-B IPv6                                    [ OK ]
TEST: No server, device client - ns-B loopback IPv6                           [ OK ]
TEST: No server, device client - ns-B IPv6 LLA                                [ OK ]
TEST: VRF server, VRF client, local connection - ns-A IPv6                    [ OK ]
TEST: VRF server, VRF client, local connection - VRF IPv6                     [ OK ]
TEST: VRF server, VRF client, local connection - IPv6 loopback                [ OK ]
TEST: VRF server, device client, local connection - ns-A IPv6                 [ OK ]
TEST: VRF server, unbound client, local connection - ns-A IPv6                [ OK ]
TEST: Device server, VRF client, local connection - ns-A IPv6                 [ OK ]
TEST: Device server, device client, local connection - ns-A IPv6              [ OK ]
TEST: Device server, device client, local connection - ns-A IPv6 LLA          [ OK ]
SYSCTL: net.ipv4.udp_early_demux=1


###########################################################################
IPv6/UDP
###########################################################################


#################################################################
No VRF


#################################################################
udp_l3mdev_accept disabled

SYSCTL: net.ipv4.udp_l3mdev_accept=0

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Device server - ns-A IPv6                                               [ OK ]
TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
TEST: Device server - ns-A IPv6 LLA                                           [ OK ]
TEST: Global server - ns-A loopback IPv6                                      [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - ns-A loopback IPv6                                          [ OK ]
TEST: No server - ns-A IPv6 LLA                                               [ OK ]
TEST: Client - ns-B IPv6                                                      [ OK ]
TEST: Client, device bind - ns-B IPv6                                         [ OK ]
TEST: Client, device send via cmsg - ns-B IPv6                                [ OK ]
TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6                     [ OK ]
TEST: No server, unbound client - ns-B IPv6                                   [ OK ]
TEST: No server, device client - ns-B IPv6                                    [ OK ]
TEST: Client - ns-B loopback IPv6                                             [ OK ]
TEST: Client, device bind - ns-B loopback IPv6                                [ OK ]
TEST: Client, device send via cmsg - ns-B loopback IPv6                       [ OK ]
TEST: Client, device bind via IPV6_UNICAST_IF - ns-B loopback IPv6            [ OK ]
TEST: No server, unbound client - ns-B loopback IPv6                          [ OK ]
TEST: No server, device client - ns-B loopback IPv6                           [ OK ]
TEST: Client - ns-B IPv6 LLA                                                  [ OK ]
TEST: Client, device bind - ns-B IPv6 LLA                                     [ OK ]
TEST: Client, device send via cmsg - ns-B IPv6 LLA                            [ OK ]
TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6 LLA                 [ OK ]
TEST: No server, unbound client - ns-B IPv6 LLA                               [ OK ]
TEST: No server, device client - ns-B IPv6 LLA                                [ OK ]
TEST: Global server, local connection - ns-A IPv6                             [ OK ]
TEST: Global server, local connection - ns-A loopback IPv6                    [ OK ]
TEST: Global server, local connection - IPv6 loopback                         [ OK ]
TEST: Device server, unbound client, local connection - ns-A IPv6             [ OK ]
TEST: Device server, local connection - ns-A loopback IPv6                    [ OK ]
TEST: Device server, local connection - IPv6 loopback                         [ OK ]
TEST: Global server, device client, local connection - ns-A IPv6              [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A IPv6       [ OK ]
TEST: Global server, device client via IPV6_UNICAST_IF, local connection - ns-A IPv6  [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IPv6     [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A loopback IPv6  [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A loopback IPv6  [ OK ]
TEST: Global server, device client, local connection - IPv6 loopback          [ OK ]
TEST: Global server, device send via cmsg, local connection - IPv6 loopback   [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - IPv6 loopback  [ OK ]
TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
TEST: UDP in - LLA to GUA                                                     [ OK ]

#################################################################
udp_l3mdev_accept enabled

SYSCTL: net.ipv4.udp_l3mdev_accept=1

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Device server - ns-A IPv6                                               [ OK ]
TEST: Global server - ns-A IPv6 LLA                                           [ OK ]
TEST: Device server - ns-A IPv6 LLA                                           [ OK ]
TEST: Global server - ns-A loopback IPv6                                      [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - ns-A loopback IPv6                                          [ OK ]
TEST: No server - ns-A IPv6 LLA                                               [ OK ]
TEST: Client - ns-B IPv6                                                      [ OK ]
TEST: Client, device bind - ns-B IPv6                                         [ OK ]
TEST: Client, device send via cmsg - ns-B IPv6                                [ OK ]
TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6                     [ OK ]
TEST: No server, unbound client - ns-B IPv6                                   [ OK ]
TEST: No server, device client - ns-B IPv6                                    [ OK ]
TEST: Client - ns-B loopback IPv6                                             [ OK ]
TEST: Client, device bind - ns-B loopback IPv6                                [ OK ]
TEST: Client, device send via cmsg - ns-B loopback IPv6                       [ OK ]
TEST: Client, device bind via IPV6_UNICAST_IF - ns-B loopback IPv6            [ OK ]
TEST: No server, unbound client - ns-B loopback IPv6                          [ OK ]
TEST: No server, device client - ns-B loopback IPv6                           [ OK ]
TEST: Client - ns-B IPv6 LLA                                                  [ OK ]
TEST: Client, device bind - ns-B IPv6 LLA                                     [ OK ]
TEST: Client, device send via cmsg - ns-B IPv6 LLA                            [ OK ]
TEST: Client, device bind via IPV6_UNICAST_IF - ns-B IPv6 LLA                 [ OK ]
TEST: No server, unbound client - ns-B IPv6 LLA                               [ OK ]
TEST: No server, device client - ns-B IPv6 LLA                                [ OK ]
TEST: Global server, local connection - ns-A IPv6                             [ OK ]
TEST: Global server, local connection - ns-A loopback IPv6                    [ OK ]
TEST: Global server, local connection - IPv6 loopback                         [ OK ]
TEST: Device server, unbound client, local connection - ns-A IPv6             [ OK ]
TEST: Device server, local connection - ns-A loopback IPv6                    [ OK ]
TEST: Device server, local connection - IPv6 loopback                         [ OK ]
TEST: Global server, device client, local connection - ns-A IPv6              [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A IPv6       [ OK ]
TEST: Global server, device client via IPV6_UNICAST_IF, local connection - ns-A IPv6  [ OK ]
TEST: Global server, device client, local connection - ns-A loopback IPv6     [ OK ]
TEST: Global server, device send via cmsg, local connection - ns-A loopback IPv6  [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - ns-A loopback IPv6  [ OK ]
TEST: Global server, device client, local connection - IPv6 loopback          [ OK ]
TEST: Global server, device send via cmsg, local connection - IPv6 loopback   [ OK ]
TEST: Global server, device client via IP_UNICAST_IF, local connection - IPv6 loopback  [ OK ]
TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
TEST: UDP in - LLA to GUA                                                     [ OK ]

#################################################################
With VRF


#################################################################
Global server disabled

SYSCTL: net.ipv4.udp_l3mdev_accept=0

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Global server - VRF IPv6                                                [ OK ]
TEST: VRF server - ns-A IPv6                                                  [ OK ]
TEST: VRF server - VRF IPv6                                                   [ OK ]
TEST: Enslaved device server - ns-A IPv6                                      [ OK ]
TEST: Enslaved device server - VRF IPv6                                       [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - VRF IPv6                                                    [ OK ]
TEST: Global server, VRF client, local conn - ns-A IPv6                       [ OK ]
TEST: Global server, VRF client, local conn - VRF IPv6                        [ OK ]
TEST: VRF server, VRF client, local conn - ns-A IPv6                          [ OK ]
TEST: VRF server, VRF client, local conn - VRF IPv6                           [ OK ]
TEST: Global server, device client, local conn - ns-A IPv6                    [ OK ]
TEST: VRF server, device client, local conn - ns-A IPv6                       [ OK ]
TEST: Enslaved device server, VRF client, local conn - ns-A IPv6              [ OK ]
TEST: Enslaved device server, device client, local conn - ns-A IPv6           [ OK ]

#################################################################
Global server enabled

SYSCTL: net.ipv4.udp_l3mdev_accept=1

TEST: Global server - ns-A IPv6                                               [ OK ]
TEST: Global server - VRF IPv6                                                [ OK ]
TEST: VRF server - ns-A IPv6                                                  [ OK ]
TEST: VRF server - VRF IPv6                                                   [ OK ]
TEST: Enslaved device server - ns-A IPv6                                      [ OK ]
TEST: Enslaved device server - VRF IPv6                                       [ OK ]
TEST: No server - ns-A IPv6                                                   [ OK ]
TEST: No server - VRF IPv6                                                    [ OK ]
TEST: VRF client                                                              [ OK ]
TEST: No server, VRF client                                                   [ OK ]
TEST: Enslaved device client                                                  [ OK ]
TEST: No server, enslaved device client                                       [ OK ]
TEST: Global server, VRF client, local conn - ns-A IPv6                       [ OK ]
TEST: VRF server, VRF client, local conn - ns-A IPv6                          [ OK ]
TEST: Global server, VRF client, local conn - VRF IPv6                        [ OK ]
TEST: VRF server, VRF client, local conn - VRF IPv6                           [ OK ]
TEST: No server, VRF client, local conn - ns-A IPv6                           [ OK ]
TEST: No server, VRF client, local conn - VRF IPv6                            [ OK ]
TEST: Global server, device client, local conn - ns-A IPv6                    [ OK ]
TEST: VRF server, device client, local conn - ns-A IPv6                       [ OK ]
TEST: Device server, VRF client, local conn - ns-A IPv6                       [ OK ]
TEST: Device server, device client, local conn - ns-A IPv6                    [ OK ]
TEST: No server, device client, local conn - ns-A IPv6                        [ OK ]
TEST: Global server, linklocal IP                                             [ OK ]
TEST: No server, linklocal IP                                                 [ OK ]
TEST: Enslaved device client, linklocal IP                                    [ OK ]
TEST: No server, device client, peer linklocal IP                             [ OK ]
TEST: Enslaved device client, local conn - linklocal IP                       [ OK ]
TEST: No server, device client, local conn  - linklocal IP                    [ OK ]
TEST: UDP in - LLA to GUA                                                     [ OK ]

###########################################################################
Run time tests - ipv6
###########################################################################

TEST: Device delete with active traffic - ping in - ns-A IPv6                 [ OK ]
TEST: Device delete with active traffic - ping out - ns-A IPv6                [ OK ]
TEST: TCP active socket, global server - ns-A IPv6                            [ OK ]
TEST: TCP active socket, global server - VRF IPv6                             [ OK ]
TEST: TCP active socket, VRF server - ns-A IPv6                               [ OK ]
TEST: TCP active socket, VRF server - VRF IPv6                                [ OK ]
TEST: TCP active socket, enslaved device server - ns-A IPv6                   [ OK ]
TEST: TCP active socket, enslaved device server - VRF IPv6                    [ OK ]
TEST: TCP active socket, VRF client                                           [ OK ]
TEST: TCP active socket, enslaved device client                               [ OK ]
TEST: TCP active socket, global server, VRF client - ns-A IPv6                [ OK ]
TEST: TCP active socket, global server, VRF client - VRF IPv6                 [ OK ]
TEST: TCP active socket, VRF server and client - ns-A IPv6                    [ OK ]
TEST: TCP active socket, VRF server and client - VRF IPv6                     [ OK ]
TEST: TCP active socket, global server, device client - ns-A IPv6             [ OK ]
TEST: TCP active socket, VRF server, device client - ns-A IPv6                [ OK ]
TEST: TCP active socket, device server, device client - ns-A IPv6             [ OK ]
TEST: TCP passive socket, global server - ns-A IPv6                           [ OK ]
TEST: TCP passive socket, global server - VRF IPv6                            [ OK ]
TEST: TCP passive socket, VRF server - ns-A IPv6                              [ OK ]
TEST: TCP passive socket, VRF server - VRF IPv6                               [ OK ]
TEST: TCP passive socket, enslaved device server - ns-A IPv6                  [ OK ]
TEST: TCP passive socket, enslaved device server - VRF IPv6                   [ OK ]
TEST: TCP passive socket, VRF client                                          [ OK ]
TEST: TCP passive socket, enslaved device client                              [ OK ]
TEST: TCP passive socket, global server, VRF client - ns-A IPv6               [ OK ]
TEST: TCP passive socket, global server, VRF client - VRF IPv6                [ OK ]
TEST: TCP passive socket, VRF server and client - ns-A IPv6                   [ OK ]
TEST: TCP passive socket, VRF server and client - VRF IPv6                    [ OK ]
TEST: TCP passive socket, global server, device client - ns-A IPv6            [ OK ]
TEST: TCP passive socket, VRF server, device client - ns-A IPv6               [ OK ]
TEST: TCP passive socket, device server, device client - ns-A IPv6            [ OK ]
TEST: UDP active socket, global server - ns-A IPv6                            [ OK ]
TEST: UDP active socket, global server - VRF IPv6                             [ OK ]
TEST: UDP active socket, VRF server - ns-A IPv6                               [ OK ]
TEST: UDP active socket, VRF server - VRF IPv6                                [ OK ]
TEST: UDP active socket, enslaved device server - ns-A IPv6                   [ OK ]
TEST: UDP active socket, enslaved device server - VRF IPv6                    [ OK ]
TEST: UDP active socket, VRF client                                           [ OK ]
TEST: UDP active socket, enslaved device client                               [ OK ]
TEST: UDP active socket, global server, VRF client - ns-A IPv6                [ OK ]
TEST: UDP active socket, global server, VRF client - VRF IPv6                 [ OK ]
TEST: UDP active socket, VRF server and client - ns-A IPv6                    [ OK ]
TEST: UDP active socket, VRF server and client - VRF IPv6                     [ OK ]
TEST: UDP active socket, global server, device client - ns-A IPv6             [ OK ]
TEST: UDP active socket, VRF server, device client - ns-A IPv6                [ OK ]
TEST: UDP active socket, device server, device client - ns-A IPv6             [ OK ]

###########################################################################
IPv6 Netfilter
###########################################################################


#################################################################
TCP reset

TEST: Global server, reject with TCP-reset on Rx - ns-A IPv6                  [ OK ]
TEST: Global server, reject with TCP-reset on Rx - VRF IPv6                   [ OK ]

#################################################################
ICMP unreachable

TEST: Global TCP server, Rx reject icmp-port-unreach - ns-A IPv6              [ OK ]
TEST: Global TCP server, Rx reject icmp-port-unreach - VRF IPv6               [ OK ]
TEST: Global UDP server, Rx reject icmp-port-unreach - ns-A IPv6              [ OK ]
TEST: Global UDP server, Rx reject icmp-port-unreach - VRF IPv6               [ OK ]

###########################################################################
Use cases
###########################################################################

TEST: Bridge into VRF - IPv4 ping out                                         [ OK ]
TEST: Bridge into VRF - IPv6 ping out                                         [ OK ]
TEST: Bridge into VRF - IPv4 ping in                                          [ OK ]
TEST: Bridge into VRF - IPv6 ping in                                          [ OK ]
TEST: Bridge into VRF with br_netfilter - IPv4 ping out                       [ OK ]
TEST: Bridge into VRF with br_netfilter - IPv6 ping out                       [ OK ]
TEST: Bridge into VRF with br_netfilter - IPv4 ping in                        [ OK ]
TEST: Bridge into VRF with br_netfilter - IPv6 ping in                        [ OK ]
TEST: Bridge vlan into VRF - IPv4 ping out                                    [ OK ]
TEST: Bridge vlan into VRF - IPv6 ping out                                    [ OK ]
TEST: Bridge vlan into VRF - IPv4 ping in                                     [ OK ]
TEST: Bridge vlan into VRF - IPv6 ping in                                     [ OK ]
TEST: Bridge vlan into VRF with br_netfilter - IPv4 ping out                  [ OK ]
TEST: Bridge vlan into VRF with br_netfilter - IPv6 ping out                  [ OK ]
TEST: Bridge vlan into VRF - IPv4 ping in                                     [ OK ]
TEST: Bridge vlan into VRF - IPv6 ping in                                     [ OK ]

Tests passed: 708
Tests failed:   2

--y0ulUmNC+osPPQO6--
