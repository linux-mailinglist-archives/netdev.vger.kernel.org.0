Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB1F31E209
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhBQWZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:25:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43422 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhBQWZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 17:25:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A10E04D2DE5D2;
        Wed, 17 Feb 2021 14:25:04 -0800 (PST)
Date:   Wed, 17 Feb 2021 14:25:04 -0800 (PST)
Message-Id: <20210217.142504.1617036353780732221.davem@davemloft.net>
To:     andreas.a.roeseler@gmail.com
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, lkp@intel.com, dan.carpenter@oracle.com
Subject: Re: [PATCH V3 net-next 0/5] add support for RFC 8335 PROBE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 17 Feb 2021 14:25:04 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Roeseler <andreas.a.roeseler@gmail.com>
Date: Wed, 17 Feb 2021 10:07:38 -0800

> The popular utility ping has several severe limitations such as the
> inability to query specific interfaces on a node and requiring
> bidirectional connectivity between the probing and probed interfaces.
> RFC 8335 attempts to solve these limitations by creating the new utility
> PROBE which is a specialized ICMP message that makes use of the ICMP
> Extention Structure outlined in RFC 4884.
> 
> This patchset adds definitions for the ICMP Extended Echo Request and
> Reply (PROBE) types for both IPV4 and IPV6, adds a sysctl to enable 
> response to PROBE messages, expands the list of supported ICMP messages
> to accommodate PROBE types, and adds functionality to respond to PROBE
> requests.
> 
> Changes since v1:
>  - Add AFI definitions
>  - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
>    net devices 
> 
> Changes since v2:
> Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
>  - Add verification of incoming messages before looking up netdev
>  - Add prefix for PROBE specific defined variables
>  - Use proc_dointvec_minmax with zero and one  
>  - Create struct icmp_ext_echo_iio for parsing incoming packet
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>  - Include net/addrconf.h library for ipv6_dev_find

Thi is too late for the current merge window, sorry.  Please resubmit when net-next opens
back up, thank you.
