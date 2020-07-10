Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1B21BB6A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgGJQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgGJQwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:52:46 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7552BC08C5DC;
        Fri, 10 Jul 2020 09:52:46 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 145so5894803qke.9;
        Fri, 10 Jul 2020 09:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n2GO5ZJ8LczdnU8kmwHXchFCiGk6Ti6c0vCFbbXfOVs=;
        b=h+kxtmgCb6TYJADBiDvGER3yYkaALQ3l7K88ZBh3uhwl2R06QupSmOgAX5c+0n/Xrl
         iguyUOPj1Ft+Tm+hasuLMzPH53PErjy7qWFE6lVVflkvm5xyZQn4zVc3VRzBhDUe7P/a
         V0moqVaf+/UZno0F/lxB+/rJbr548uZofZU8OS5k8IzOxN6PeszcwxIQFytI4WRdbtJI
         lFxyvZ5Y8b0w0Nd3Yw6GFzyPk0tN5NzQeG3CDwTuCwZRlcr/2FsY272EYZn76mzLIyKz
         P+cawwRS3KbzLNyDIKA9UO3AYuC+2U1/QvkojH7j7pSINwjROdQIkRGDAdSx1PlHTj6i
         RnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n2GO5ZJ8LczdnU8kmwHXchFCiGk6Ti6c0vCFbbXfOVs=;
        b=FPTNqSeos6n7KumeR1STUCULKePeve5hv2lVzGuO2sBteVu2QlRIlOKppfPnCN2lBa
         vvnstjy+PlXwFwg2BCZvzpdL0mWOJxCphObPB+OdBMLvCDl4FCW5hAAHKY0pQq0OTPc/
         +ElDcR2YjcJ4oT3Cxs0GhosvrzjXvRJ6tZxE5vdCoJDOVjcEfFvSrOKpX4UUADoxYmQL
         zmfhhOY+NBft6HReOGejQidA9J3qyfaHqjZOmdQbECU3BZAQtBaoZzwuwWg7RPRtKyJA
         TpnE1QsbklGsORFSLz3iTaHws7FrqVG4PJ5cCdA3SXuZ4p614VVnLQqhBSFGoE8dYU1q
         Toyw==
X-Gm-Message-State: AOAM531+N693msdV3qOhdHyF/Eiq5FJXrybAek8DG+5wS05yPlA4XoOj
        LrQO6T+oOIOCbNXCD3OCZaQ=
X-Google-Smtp-Source: ABdhPJwccJQrHgJR2ikrn49yxMc2mqxvzj3OlykWGkGbmpKhb8VMRiYVDMUoYBUehSYVX1+F9NObfg==
X-Received: by 2002:a37:a306:: with SMTP id m6mr50442291qke.7.1594399965681;
        Fri, 10 Jul 2020 09:52:45 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:94b4:214e:fabf:bc82? ([2601:282:803:7700:94b4:214e:fabf:bc82])
        by smtp.googlemail.com with ESMTPSA id a185sm7804517qkg.3.2020.07.10.09.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 09:52:45 -0700 (PDT)
Subject: Re: [PATCHv6 bpf-next 0/3] xdp: add a new helper for dev map
 multicast support
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <7c80ca4b-4c7d-0322-9483-f6f0465d6370@iogearbox.net>
 <20200710073652.GC2531@dhcp-12-153.nay.redhat.com>
 <9a04393c-f924-5aaf-4644-d7f33350004f@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0c97f21a-03d8-6c9f-2071-b0c4b87c4955@gmail.com>
Date:   Fri, 10 Jul 2020 10:52:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9a04393c-f924-5aaf-4644-d7f33350004f@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 9:02 AM, Daniel Borkmann wrote:
> Right, but what about the other direction where one device forwards to a
> bond,
> presumably eth1 + eth2 are in the include map and shared also between other
> ifaces? Given the logic for the bond mode is on bond0, so one layer
> higher, how
> do you determine which of eth1 + eth2 to send to in the BPF prog? Daemon
> listening
> for link events via arp or mii monitor and then update include map?
> Ideally would
> be nice to have some sort of a bond0 pass-through for the XDP buffer so
> it ends
> up eventually at one of the two through the native logic, e.g. what do
> you do when
> it's configured in xor mode or when slave dev is selected via hash or
> some other
> user logic (e.g. via team driver); how would this be modeled via
> inclusion map? I
> guess the issue can be regarded independently to this set, but given you
> mention
> explicitly bond here as a use case for the exclusion map, I was
> wondering how you
> solve the inclusion one for bond devices for your data plane?

bond driver does not support xdp_xmit, and I do not believe there is a
good ROI for adapting it to handle xdp buffers.

For round robin and active-backup modes it is straightforward to adapt
the new ndo_get_xmit_slave to work with ebpf. That is not the case for
any of them that use a hash on the skb. e.g., for L3+L4 hashing I found
it easier to replicate the algorithm in bpf than trying to adapt the
bond code to work with XDP buffers. I put that in the category of 'XDP
is advanced networking that requires unraveling the generic for a
specific deployment.' In short, for bonds and Tx the bpf program needs
to pick the slave device.
