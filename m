Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C738BA222F
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfH2RZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:25:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44239 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfH2RZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:25:43 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so1873260plr.11;
        Thu, 29 Aug 2019 10:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=O6/rw6fyYXK3X1buWGszqsqXgLe4Q/iuHvp4zHdAOQk=;
        b=A1GOpaZPd8TQWHez555novaUxU0bh30thynzh5VF2NbIghtS1sSUxx5Led0aaTeRdJ
         atbm9I1kXhX1GnYyckHUcmap9OFlpyA3tQg9x8L4lZLPsxDIBbUBnTgEc7ql8B4SRPgu
         McXUuHeVT8jRnxd9PwAhJX98MxAIYmLHbp+BZMTmJtXmXDHxPx7NqIBWnfXqstEyMGRi
         iCPWa5WZYuPBP8H3elxIwJBoPBEX8b1uSt+ka0HA/PaATo1NT7EMi7aWULErOpqWi2iA
         CnWtBcbVyl1qavHRMJKxvJKc8FgLaTS1KOlInQgWLUcxOjIB3VR88IhO0WFJvn0Q/qP3
         mjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=O6/rw6fyYXK3X1buWGszqsqXgLe4Q/iuHvp4zHdAOQk=;
        b=sAAp71MAJEWXnKHpkGEmTQLZ2vMkodQ56bsBmlxb1sDf+kUrnWyiggKrKpBss9CLpI
         MUq8t2XyuULsBvbE9adMRHzSRRpGg1tEOsp+8aUk6aqCLVa6RbKyVNlNWVHqAMix4G4W
         T0ep6pyNthJIWjVxfhViFK2tAf7tDVKoRdPB+m/KR0+7Wu6LJ/+jPZwStGtMf4v+gY4H
         NGy9DVEB7POMK50Oo1lEznV7E/yPDQAUNWsFcGCukeln4UHxV4OdzVV7bAqtXvheezZm
         +arSW/538261ktnkgEiP3boIi5JV52RtcM7iKalWNkLpr0pWcq4SgTueGIjFXUPjWlUh
         syHg==
X-Gm-Message-State: APjAAAVyUSGZRxPHZb9enG3KgGDKCFKCr+ziFwCEJdLi62b6568pa/ra
        Kc01zeQ6Ai9oPhF71z5DpAI=
X-Google-Smtp-Source: APXvYqyGtgleiIDvmQc3kbRiRgdrnVZpp1SLjMIECGNsc2qUk+re7BbM3WDh1f4GFE0ZDf/yyjbhlw==
X-Received: by 2002:a17:902:b604:: with SMTP id b4mr10849149pls.94.1567099542333;
        Thu, 29 Aug 2019 10:25:42 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:1347])
        by smtp.gmail.com with ESMTPSA id k8sm2750558pgm.14.2019.08.29.10.25.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 10:25:41 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:25:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net,
        davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Message-ID: <20190829172539.j4qnhokhdflvkfm2@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <a5ef2f94-acca-eb66-b48c-899494a9f8d0@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5ef2f94-acca-eb66-b48c-899494a9f8d0@6wind.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 03:36:42PM +0200, Nicolas Dichtel wrote:
> Le 29/08/2019 à 07:12, Alexei Starovoitov a écrit :
> [snip]
> > CAP_BPF and CAP_NET_ADMIN together allow the following:
> > - Attach to cgroup-bpf hooks and query
> > - skb, xdp, flow_dissector test_run command
> > 
> > CAP_NET_ADMIN allows:
> > - Attach networking bpf programs to xdp, tc, lwt, flow dissector
> I'm not sure to understand the difference between these last two points.
> But, with the current kernel, CAP_NET_ADMIN is not enough to attach bpf prog
> with tc and it's still not enough after your patch.
> The following command is rejected:
> $ tc filter add dev eth0 ingress matchall action bpf obj ./tc_test_kern.o sec test
> 
> Prog section 'test' rejected: Operation not permitted (1)!
>  - Type:         4
>  - Instructions: 22 (0 over limit)
>  - License:      GPL
> 
> Verifier analysis:
> 
> Error fetching program/map!
> bad action parsing
> parse_action: bad value (5:bpf)!
> Illegal "action"

because tc/iproute2 is doing load and attach.
Currently load needs cap_sys_admin and
attach needs cap_net_admin.

