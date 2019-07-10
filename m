Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3634764DDC
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 22:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfGJUyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 16:54:21 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37573 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJUyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 16:54:20 -0400
Received: by mail-io1-f66.google.com with SMTP id q22so7787147iog.4
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 13:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mF3ZHc55Yh8moYwvYA9inkAQ1iH1qdwKOeQwdO4O3sI=;
        b=jIpqPOZamJFc5xkbYe1a5QhvVuolUSZAWn+liye4D/ZWTw62G+n4ithO/XiVYe5ufs
         LpJ9o4Lh0NnHKtv5iljvytGGl/qKhmI1PLmBusBBMKzBZiD5yNgC9F1RdLXecFg+TojB
         uzoQGvcPtFAbusshTbudLPBj/rY5zPfjoH0Ta/QGa5iYvcT+QIYMqbA3ABzaDgUEtT2R
         U8Q81RIgc0nbKPajdIAeY3VmxThaLijVMX3/KDIwco0caFgOJmDNqz6AOufNgmKmj5vc
         6mieb0IgeC0HvdIZqWeVB20QogVvqf+EniXLh9+Z4LQqjw214bUUt0xvCq/8JdpUZpCs
         KJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mF3ZHc55Yh8moYwvYA9inkAQ1iH1qdwKOeQwdO4O3sI=;
        b=k45M1Qx33iP4XRjjTBHIhFO6qfEz+qnUREGZSDtMBi7tI81vqOKLL10eTKw21Vj9Re
         IbGFGJ0S0h+8xy5zlwUwF7Pl+iHP4bisLzCDRBoTnvXVJk2/jHOOJYaL1qbAvYCU/bpg
         k9Y1s1aQ62HtTVJ4W5laewYnJk83+j+MtbOeGR352m/9MBe6RM1Z64sMyrmJhaowl8s3
         G5moEeA/JB1GSuGkchXV2B9Vjk4jwQSx28Eoo2BkZx97Dn5dIsjfWc6NNtv2Y4RrPGzU
         5inN+zLlUD7khbzbwyd5I0vIxep0lCTa17uhHhz4SepHrfCwaqmRJQyO8t0WY31/5frg
         jtlQ==
X-Gm-Message-State: APjAAAU2ql4pauLRL+d+XSQCmrGZjnyq/G0/uOsw/I/kqa3UHQbhH/gI
        FU48lmGfNhwqEsvMvZ7Bh+fvo2ag
X-Google-Smtp-Source: APXvYqzEBKZ4yQ9t36blb689qOG25kqKF7OTH2P8UPvuYiGvBsIPMpnwAJ7zdCoG3jA+iJOZfBjUug==
X-Received: by 2002:a5d:9282:: with SMTP id s2mr84207iom.36.1562792059538;
        Wed, 10 Jul 2019 13:54:19 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:3913:d4da:8ed6:bdf3? ([2601:282:800:fd80:3913:d4da:8ed6:bdf3])
        by smtp.googlemail.com with ESMTPSA id p10sm5964532iob.54.2019.07.10.13.54.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 13:54:18 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: bond: add peer notification delay
 support
To:     Vincent Bernat <vincent@bernat.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20190707094141.1b98f3f4@hermes.lan>
 <20190707175115.3704-1-vincent@bernat.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cf1893e1-b0ea-f330-817d-654173793e07@gmail.com>
Date:   Wed, 10 Jul 2019 14:54:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190707175115.3704-1-vincent@bernat.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/19 11:51 AM, Vincent Bernat wrote:
> Ability to tweak the delay between gratuitous ND/ARP packets has been
> added in kernel commit 07a4ddec3ce9 ("bonding: add an option to
> specify a delay between peer notifications"), through
> IFLA_BOND_PEER_NOTIF_DELAY attribute. Add support to set and show this
> value.
> 
> Example:
> 
>     $ ip -d link set bond0 type bond peer_notify_delay 1000
>     $ ip -d link l dev bond0
>     2: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue
>     state UP mode DEFAULT group default qlen 1000
>         link/ether 50:54:33:00:00:01 brd ff:ff:ff:ff:ff:ff
>         bond mode active-backup active_slave eth0 miimon 100 updelay 0
>     downdelay 0 peer_notify_delay 1000 use_carrier 1 arp_interval 0
>     arp_validate none arp_all_targets any primary eth0
>     primary_reselect always fail_over_mac active xmit_hash_policy
>     layer2 resend_igmp 1 num_grat_arp 5 all_slaves_active 0 min_links
>     0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select
>     stable tlb_dynamic_lb 1 addrgenmode eu
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> ---
>  include/uapi/linux/if_link.h |  1 +
>  ip/iplink_bond.c             | 14 +++++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks
