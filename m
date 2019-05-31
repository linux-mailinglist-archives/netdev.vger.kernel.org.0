Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12ECD316D1
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfEaV4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:56:51 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:37575 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaV4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:56:51 -0400
Received: by mail-pf1-f176.google.com with SMTP id a23so6983371pff.4
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 14:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=K7MccxGmrnrUOQtr8WV0zp6LniZ5cfE2NQ4OOImEppQ=;
        b=G2SuW4XKqDweQacZW/odPz6sld9niLfG1JOHOWENbC8NYXkZRvdZkl9LCjMl/x+PWF
         QyoIlfQ03e9aEoY8Vd+rsRe23H6bNiHDcPXeaXsK98kOJUpYLL/cQyI54lixQoCvXyV/
         Bqi8TCE03TVcZ3Fr3P/Ql6U5Yp1oxf1Je4GySkQ6x3vqopaPCAyb/K1setRaXNwTCRC/
         k/Ad0rLCb5UBqanEiAXhC3EZJjq+THb7Kv1/vwA9+3ItT9EkQLeGneaU30h5FzgaRK1m
         kqKv9PHKWqAM/bbv7RyDV++vJz9sej8tNI/mSMFKwqjD5pjB3Vb8f5PaO8A7i1+kkHQN
         dg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K7MccxGmrnrUOQtr8WV0zp6LniZ5cfE2NQ4OOImEppQ=;
        b=B8CQRr0QeyfllTYk8tR7JMUXuZSFGnnk/q+QbHt79V4NGCUJh5LsLrDaThf6smZd7O
         RqpwiVcelWINEWOmBtBWF5O+nOydoyjJkwR1AwJEArAfTdy3tkoUelaURXS2piGj8dKc
         vHDjZeRhLp5ofSKMJkrQ2OBCkVTMWcdEcEx2lOOYPX9/vdXFX3qkZ4vFOJQtatNqbsar
         yNubFLpEBRdctBQiSKiat5O8JkpjtC3d5d7b+cHAQjU/MbP6FKpQvN65ym/DZY2aN53o
         qKR4N4deA0sbYNXdS7+ObtTRGpcMxXJE43w0z7PdDnSHuoYDJdQhfGfGfDpPJR1be4r3
         CWdQ==
X-Gm-Message-State: APjAAAXaGKPed0jlTpS2RCjPDr9cq4C9sMI7OTH1alpH0x9YNic3BIC9
        DhFjJRcpK7awXxL9YEQvDHCfKFkF2GY=
X-Google-Smtp-Source: APXvYqyKiufzYlFEpTAVCtI0qlyZSlWdN1yZFPUGI/iQseTn2oc4IW9CSRhvCLZuE5EKwjfVmzUzww==
X-Received: by 2002:a65:430a:: with SMTP id j10mr11640492pgq.133.1559339810103;
        Fri, 31 May 2019 14:56:50 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j64sm17741960pfb.126.2019.05.31.14.56.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 14:56:49 -0700 (PDT)
Subject: Re: support for popping multiple MPLS labels with iproute2?
To:     Alan Maguire <alan.maguire@oracle.com>, netdev@vger.kernel.org
References: <alpine.LRH.2.20.1905311313080.9247@dhcp-10-175-206-186.vpn.oracle.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b1455c03-d98c-c08b-a6f3-330d9f36d8be@gmail.com>
Date:   Fri, 31 May 2019 15:56:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.20.1905311313080.9247@dhcp-10-175-206-186.vpn.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 6:24 AM, Alan Maguire wrote:
> I was wondering if there is a way to pop multiple MPLS labels at
> once for local delivery using iproute2?
> 
> Adding multiple labels for encapsulation is supported via
> label1/label2/... syntax, but I can't find a way to do the same
> for popping multiple labels for local delivery.
> 
> For example if I run
> 
> # ip route add 192.168.1.0/24 encap mpls 100/200 via inet 192.168.1.101 \
>    dev mytun mtu 1450
> 
> ...I'm looking for the equivalent command to pop both labels on the
> target system for local delivery; something like
> 
> # ip -f mpls route add 100/200 dev lo
> 
> ...but that gets rejected as only a single label is expected.
> 

as I recall the kernel driver only pops one and does a look for it.

Try:

ip -f mpls route add 100 dev lo
ip -f mpls route add 200 dev lo
