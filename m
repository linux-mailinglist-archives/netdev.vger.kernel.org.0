Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB95F585DB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfF0Pds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:33:48 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:36914 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0Pds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:33:48 -0400
Received: by mail-pl1-f170.google.com with SMTP id bh12so1498593plb.4
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 08:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=uYmzhCCoCq83izvilpBCYqAh+dKjbOTesnJ9p8H3tHI=;
        b=06lxSe0vtmY0A84JH1ehV9k2P9kR/gEQChZXoYMCQQsclLR7Gyv1Hi9Lvx3TVyv61z
         6mf3ZwlQIeShntmY++N8LSTRc1lBiP0Z/Xy8gs1sF+yyFkv1oIMd3hORqFu5EDBmjRKM
         T6Jmizo7iDDLk+633s6vDceY61OJhSXTbfax6pACsHGCkUsHDzgrcAz9ADEMjVMgmwa9
         JefmKw4r7WioZGwvGsF2sKZiBzhiNICpUcHm4HFtr6Dke7ENZ/bu7i1WMpVBO/axQYof
         jpzMO9DZYINICtRjjfXR/RKD+32IxOIzX3N2KrpQ8JDb1vym1A2lsvrAODlettB4LlE+
         TsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=uYmzhCCoCq83izvilpBCYqAh+dKjbOTesnJ9p8H3tHI=;
        b=RCkqYhNEO4IGjRGNkAYPKR95dJBEy1M83+CpGs2jZSBzg0vNP4WGel2IMgZDifH2rn
         y2M2T0baFBFYjUJ0rEPcqIFI+lxGWjn8TxhTfGJC9BjFzIOM9ZhFetQiOQrgAHYjEBj1
         7N6kIvojJIXjOjFpOVZOOpKCbDmw0QbJmkkLQpAzH0v0x9xtl+bhKLAXnCtfGgdIUYKN
         TO/dXR/JJ0VsslxlDUtB6xonGOsrPzzScHKVckSjIy6CLrq6u+ljM0Uh3cZX65BONMFc
         5q1aa1TLKYeIuhZ6OmYUYNW2Q3urj8zosDRhiEeAJa6Xx1i3s7+OAy2NPJFC3QZC1Rda
         hoKQ==
X-Gm-Message-State: APjAAAXp+4RulkQ//MIYFA2MKMyZfIHHxCs4j/vv6SUQMJ5pyaN+DoUC
        BNJcltrQOEU3T9XG1TTNi4jK2Wsu48Q=
X-Google-Smtp-Source: APXvYqxSz06TFZlQEKCrRo/vjFAh7wU5g1gDc1bHy5fIs5ddA/k22x9RdCyF3+KoVUFit39rSKbQJA==
X-Received: by 2002:a17:902:2a27:: with SMTP id i36mr5293363plb.161.1561649627571;
        Thu, 27 Jun 2019 08:33:47 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p12sm262948pgm.2.2019.06.27.08.33.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 08:33:47 -0700 (PDT)
Date:   Thu, 27 Jun 2019 08:33:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 204005] New: Code in __mkroute_input isn't full correct
Message-ID: <20190627083341.66bb8f49@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is on a very old kernel, and looks like not a valid bug.
But forwarding to list anyway since others may want to provide
input.

Begin forwarded message:

Date: Thu, 27 Jun 2019 09:33:27 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 204005] New: Code in __mkroute_input isn't full correct


https://bugzilla.kernel.org/show_bug.cgi?id=204005

            Bug ID: 204005
           Summary: Code in __mkroute_input isn't full correct
           Product: Networking
           Version: 2.5
    Kernel Version: 3.10.0-862
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: cliff.chen@nokia-sbell.com
        Regression: No

In function __mkroute_input(), there is issue in below code:
......
rt_cache:
                if (rt_cache_valid(rth)) { <<======
                        skb_dst_set_noref(skb, &rth->dst);
                        goto out;
                }

......
Once the route is failed, then rth.rt_type is set as unreachable(7).
however, once the route is correct again, because the condition
rt_cache_valid(rth) only check the rt_genid in cache and net space.
so even the route is recovery, then it always get the failed route cache.
one test env.
1) host1:
add ip1 on interface x

2) host2(proxy arp)
2.1) add ip2 on interface y1 with 32 prefix
2.2) add no IP on interface y2
Notes: x, y1 and y2 are in the same layer2 networkwork
set forwarding on y1 interface
set ip3 as arp proxy on interface y1

2.3) add ip3 on interface z on any interface which isn't the same layer2 as
interface y1 and y2.

3)run below test on host1 to check whether arp is back.
arping -I x -s ip1 ip3

The possible reason analysis:
since ARP is broadcast, then interface y2 can get this ARP request first,
because forwarding isn't set on on y2, then route failed. this is correct.
however, when ARP is received on y1, the route is always failed even the result
from fib_lookup is successfully. All these because the condition
rt_cache_valid(rth).
because, the rt_genid in cache isn't changed, and
 rg_genid in network space isn't changed, too.
therefore, it will never OK until, I 
down y2, or
ip route flush cache
to increase rt_genid in network space.

thanks
Cliff

-- 
You are receiving this mail because:
You are the assignee for the bug.
