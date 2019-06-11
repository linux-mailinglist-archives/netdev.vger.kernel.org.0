Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C15F41699
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406984AbfFKVG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:06:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36933 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406853AbfFKVG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:06:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so7364276pfa.4
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 14:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zKyfkNq3wE5u00Q1E2PQiuHw3A1X7oi/SvDr0L2DI/w=;
        b=EKBScxcOebxvnN8OXr/+rbQj9DJ3+/WRrZRvtIZhgP1yO+hx4fW/hyCMUvtE2pJoko
         pwWwCL0k6L1wXczLyUYGdlD6TgLDdZN07MxbCziXG1tdseNfqbVZfVfB6kG/JPmUlbQZ
         cBGJbZTFxL4Fr3LLt9L8N6PtNiZZ0gRDyqZ7d4UpdgvyHyac+cDpLOfbyA5rOrPZy3Ye
         OI+fVoDcb7GlRbiGR4gF1HqXvOyhjps7NrYrkFj8J3nSsS0ZfVvfX4gW6azA5z4j66rJ
         gQGZp5PG7+OuvhidFDifolt/WohK7uOZXIwnTneu1m1AwWGtMaxFAWV2jCfRdUmZJDK1
         +x+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zKyfkNq3wE5u00Q1E2PQiuHw3A1X7oi/SvDr0L2DI/w=;
        b=F3+8+S1T1QCLZT6NxmUWbYWRor+GJnwEN0p4n0hntVLxs4wNXn5Lf2sZ/KvmPeD9aQ
         6sFl6Km2TblupnObGIUroGGtE2ZjrOhhJchlqAIsJEmtB/rNvHd61rdt9jeVOIi9uGqG
         y5hMuO/+Roo7AAixxyIqXICbtge8rKg/7qjo2h4ZEShP/HiWFxxR3rogloxQQz5I5t20
         4eva7IFeuPHyJCeDlrnJ+uIJ0exVOG825dhfQlIaz5bEmEhgu8YXDCDffdl8CbPFacOB
         PKpbI9NeBXX0WIYVhfN/48HlOJrRB+KGbK/LqXCz0E6kq5CBfvKBgcTwoVKWnk7K4Bxg
         TPLw==
X-Gm-Message-State: APjAAAXfduoPz3bDD4mqFJh+fVdrDEqPjMonX4xUvozCNntlAj0j3dwq
        IxqPw+twAUW72km/vlJ64yoM9dP5ReU=
X-Google-Smtp-Source: APXvYqwVFzJZ5UhbHQ9JDaPeE0W7jywP9GOJX/8DnGxh2ugSNkD2fdSn9ChcNkIeQRwEOqgPbsTuVw==
X-Received: by 2002:a63:10d:: with SMTP id 13mr21674976pgb.176.1560287186107;
        Tue, 11 Jun 2019 14:06:26 -0700 (PDT)
Received: from [172.27.227.165] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 85sm18276421pgb.52.2019.06.11.14.06.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 14:06:25 -0700 (PDT)
Subject: Re: [PATCH net v2] vrf: Increment Icmp6InMsgs on the original netdev
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190610143250.18796-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4516de89-6da1-ea54-f890-4e92d652b716@gmail.com>
Date:   Tue, 11 Jun 2019 15:06:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190610143250.18796-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/19 8:32 AM, Stephen Suryaputra wrote:
> Get the ingress interface and increment ICMP counters based on that
> instead of skb->dev when the the dev is a VRF device.
> 
> This is a follow up on the following message:
> https://www.spinics.net/lists/netdev/msg560268.html
> 
> v2: Avoid changing skb->dev since it has unintended effect for local
>     delivery (David Ahern).
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  include/net/addrconf.h | 16 ++++++++++++++++
>  net/ipv6/icmp.c        | 17 +++++++++++------
>  net/ipv6/reassembly.c  |  4 ++--
>  3 files changed, 29 insertions(+), 8 deletions(-)

Reviewed-by: David Ahern <dsahern@gmail.com>
