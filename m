Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D827E71C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 02:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbfHBATF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 20:19:05 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34555 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730929AbfHBATF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 20:19:05 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so32921088plt.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 17:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IlvwkQY8yiovvTZDDlBm1I5pn1pB14Bf5zzjqC4gLhw=;
        b=lZPFxZSFk08iPqGRc69tIxlRf5qesTNat3cfVQ3hccW9grpVKizOwXZODN/HTyZ6aS
         tDGPZme0RYSNQLdLupmGYkB81g74f8fFOz3dfOULq46gA39bGuriyYfQSo3ZV0NHN8nx
         cd7x/bZNU/Snd+Mwa1vnqVDhSHXdbEQQvCFbXnpwVkymg2+Y53w9eQU2HreQ/N2CAX1b
         HX4vmCrsBDV+ZoHCtrrnxXgfxpydeK042arawQW3xrqV/n/pgPvy5K5wkIMrwTRPGeoN
         ba8WhUPMOhpm3hZPzUbYFILmsQFdub1QHVbpQ/RuvPu2Nhv0JaLq7l1Hzopulx6lbUWI
         T6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IlvwkQY8yiovvTZDDlBm1I5pn1pB14Bf5zzjqC4gLhw=;
        b=pd+jzoStd/tgPyLR6k5Dsl2QDGYaOmw6a/hStRabdnKbbgKTR+fwJ8cm0d8GkhWS7T
         sY32jZwbSL7vTHjEsLz+fPW+tujf0TzIprIevXaaMbrMBRkn6tnaeHrCKahvbFSKC9EY
         UydUujkPg9/HtEaiOTLUycvQwc4mLtwlKILsw6LiIjJVxA3yMwT+xB+TI/9GLxfUp4Ma
         9z/iH6cd7zrRG4/iazv4ubBUzGGf+PbTe6JMlyVRrgQj4uyiju4sNRabZ77KcgbVfXPW
         xf6pUwJoVYPcjGgElULsGMW7EzfFfZcS2F+JpS4Jf/O5fP+98Ja2HCI3st+7Iyfv/84l
         vx6g==
X-Gm-Message-State: APjAAAVvvkuOYDtzyAjGXYVPAfZpzX2ngGUa+cKjre9NmRoXAcpsw3DI
        jUsyFhg+7JZexRAktx7z/U0=
X-Google-Smtp-Source: APXvYqxO39RAq/YLvSs6MLfRTTfXGk2Ln7stcG3pJHecUd2/zeF7ao1KylCAhcNfQNbWQPHSp869OQ==
X-Received: by 2002:a17:902:7782:: with SMTP id o2mr45370071pll.12.1564705144339;
        Thu, 01 Aug 2019 17:19:04 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:f96b])
        by smtp.gmail.com with ESMTPSA id 85sm77639389pfv.130.2019.08.01.17.19.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 17:19:03 -0700 (PDT)
Date:   Thu, 1 Aug 2019 17:19:02 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
Message-ID: <20190802001900.uyuryet2lrr3hgsq@ast-mbp.dhcp.thefacebook.com>
References: <20190801185648.27653-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 11:56:33AM -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> This is a port the functional test cases created during the development
> of the VRF feature. It covers various permutations of icmp, tcp and udp
> for IPv4 and IPv6 including negative tests.

Thanks a lot for doing this!

Is there expected output ?
All tests suppose to pass on the latest net-next?

I'm seeing:
./fcnal-test.sh
...
SYSCTL: net.ipv4.raw_l3mdev_accept=0
TEST: ping out - ns-B IP                                                      [ OK ]
TEST: ping out, device bind - ns-B IP                                         [ OK ]
TEST: ping out, address bind - ns-B IP                                        [FAIL]
TEST: ping out - ns-B loopback IP                                             [ OK ]
TEST: ping out, device bind - ns-B loopback IP                                [ OK ]
TEST: ping out, address bind - ns-B loopback IP                               [FAIL]
TEST: ping in - ns-A IP                                                       [ OK ]
TEST: ping in - ns-A loopback IP                                              [ OK ]
TEST: ping local - ns-A IP                                                    [ OK ]
TEST: ping local - ns-A loopback IP                                           [ OK ]
TEST: ping local - loopback                                                   [ OK ]
TEST: ping local, device bind - ns-A IP                                       [ OK ]
TEST: ping local, device bind - ns-A loopback IP                              [FAIL]
TEST: ping local, device bind - loopback                                      [FAIL]

with -v I see:
COMMAND: ip netns exec ns-A ping -c1 -w1 -I 172.16.2.1 172.16.1.2
ping: unknown iface 172.16.2.1
TEST: ping out, address bind - ns-B IP                                        [FAIL]

Any tips for further debug?

Do you really need 'sleep 1' everywhere?
It makes them so slow to run...
What happens if you just remove it ? Tests will fail? Why?
