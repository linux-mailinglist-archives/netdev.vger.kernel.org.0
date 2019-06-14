Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7B45701
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFNILY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:11:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40876 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfFNILY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:11:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so1307537wmj.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 01:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aeRkT0KDMg7INH0mXEzaUJoP1GiOUJd6ZYM4XKRu0wY=;
        b=jdIR7LaKhwGgwnZ38F62g8XXx+p8NBEks/cJLc4zPbFGYvPhiBeZfr+EezCh54d55W
         PTsLS3rr58M85WEHyV1Js8GQ+HNp+TvGt+WwpDHd7r13oU8OPz15EmrLcDI+qL/QK+C2
         h+w7yKZ9lX9yZ372IdrT1ufD4x7Wg7uaN6NU+jeEf2MUadUJeM6qBgkqOnUwGd1C7uu6
         GAABTKcaaNYETrdWMIAeqD2HzDtE8k22Dd2saqtTorp589j2T25Kho4P/tXTKAYdPIkd
         hcJSSvqmkmU4PGa7spybBrzKiHM2673m1XZDv8KnS/UszFYAaYaun3+x7nC9j4BSdUNY
         4rLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aeRkT0KDMg7INH0mXEzaUJoP1GiOUJd6ZYM4XKRu0wY=;
        b=f78WtGq+kJu4gFDO1A0WiJGWFwAskd2WszW0oong1OWqU4D8wenDipCwZGJnctqqle
         tXGkmiVCBerMTejiBmILReWzNua/RruYGT6iogg1mdQE/BerzzUbo+I6xH/kMS+ViZdS
         jotJz8ByO8djGXXtozwvQ1gDEkogePvWAMt1Gdbeh2ESKO9n3WXggHqnhHEItdY2Hmrg
         Gf+tn3bSgY7AupgGpwRzSJGHSRk1UPtXJr97nlFD3cq52DkCOtWnwbAJt4KsMQ4nuT7v
         oBTkqjrOpm/txawE7R+muZ94FvLc+xUtR0OcYnQDpEOj31d4wqvvxfp+YJHo+IgolplC
         X2og==
X-Gm-Message-State: APjAAAWob4JxQwL4NQYzEeGoCoWTp5HlzIKuJaZlfIqAfkv0sJ9Pe0uT
        RrW7Pj7o14bZ1fFLeTun3PKzVw==
X-Google-Smtp-Source: APXvYqwJZp+xGgug153JLJ4QDsEry7M/ppomEgRLBf9ZC/4jibHaAuiH19s2QckG92kgfS5h+HX0YQ==
X-Received: by 2002:a1c:c912:: with SMTP id f18mr6564019wmb.118.1560499881398;
        Fri, 14 Jun 2019 01:11:21 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id n10sm2088474wrw.83.2019.06.14.01.11.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:11:21 -0700 (PDT)
Date:   Fri, 14 Jun 2019 10:11:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, dcaratti@redhat.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next v2 2/3] net: sched: include mpls actions in
 hardware intermediate representation
Message-ID: <20190614081120.GD2242@nanopsycho>
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
 <1560447839-8337-3-git-send-email-john.hurley@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560447839-8337-3-git-send-email-john.hurley@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 13, 2019 at 07:43:58PM CEST, john.hurley@netronome.com wrote:
>A recent addition to TC actions is the ability to manipulate the MPLS
>headers on packets.
>
>In preparation to offload such actions to hardware, update the IR code to
>accept and prepare the new actions.
>
>Signed-off-by: John Hurley <john.hurley@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>---
> include/net/flow_offload.h   | 10 +++++++
> include/net/tc_act/tc_mpls.h | 64 ++++++++++++++++++++++++++++++++++++++++++++
> net/sched/cls_api.c          | 26 ++++++++++++++++++
> 3 files changed, 100 insertions(+)
>
>diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>index 36fdb85..e26ae81 100644
>--- a/include/net/flow_offload.h
>+++ b/include/net/flow_offload.h
>@@ -123,6 +123,10 @@ enum flow_action_id {
> 	FLOW_ACTION_QUEUE,
> 	FLOW_ACTION_SAMPLE,
> 	FLOW_ACTION_POLICE,
>+	FLOW_ACTION_MPLS_PUSH,
>+	FLOW_ACTION_MPLS_POP,
>+	FLOW_ACTION_MPLS_MANGLE,
>+	FLOW_ACTION_MPLS_DEC_TTL,
> };
> 
> /* This is mirroring enum pedit_header_type definition for easy mapping between
>@@ -172,6 +176,12 @@ struct flow_action_entry {
> 			s64			burst;
> 			u64			rate_bytes_ps;
> 		} police;
>+		struct {				/* FLOW_ACTION_MPLS */
>+			u32		label;
>+			__be16		proto;
>+			u8		tc;
>+			u8		ttl;
>+		} mpls;


This patch is not really useful without a driver offloading this...

[...]
