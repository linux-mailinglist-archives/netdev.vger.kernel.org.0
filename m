Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07904FF37
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfD3SAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:00:50 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40932 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfD3SAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 14:00:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so7084345plr.7
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 11:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ol30xF3sF32FHb22ABUVGco08QKe2Wr3Kzo1kkjgDLw=;
        b=s9W0b+eb8os3sHM4984Pnmy2E++GGe0Br7qmTk148uhg3AGt9QieKTeGzAJgA+BFvt
         y3F9uH5dGp8o4hGH6NCqTUvByK9/tpB4oxRXLiVglAvQUWs9Souw87Xb/XW3NI/aJDrI
         Ef7P2vzn7zgweTEXulpfeSDkopVtLh36UoxCupBTHcbBbaITTfSlhs+phB0+IHn5KRxA
         LQAECESR4ETbhsisNfQUd/kUqcaGAF4R0Dlw3DSLl4Ix6Rwl2BWpJ3IeGmeRw94HKWyN
         JOA02xU6y15F4m09ZTKZjuYCuMgyYBCTsBTfs6Ba9e0khnZwqlpy2HicE6rE7OOPRIdR
         KmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ol30xF3sF32FHb22ABUVGco08QKe2Wr3Kzo1kkjgDLw=;
        b=VOTDhrwXdhsm0ECF8Fjz08HbEneW/qanYoCrC37Qw8S5Qu2ftC4zF+qI/oiz/RvLI2
         CMeIija1qjrqTVlIUn/gGlGz4VS66yHR57xCzcnEidH01cRAaaODxKms6UQeNpcGaFAB
         s+Cd2PMcvggTioOe/7PdGMMdVCMsKLdXijoAr8X+Zw4c+fa+bbM1zJh6+/9tLS4v9wy5
         cPJycMnwsK7d9sQ1nT6UjLYhGhbdDvh5RDkFLf6E9IJNjbUATtDXXl1yaUOb1BjPWrxh
         52RLyK62um6P/rrvkZEv9ZJjJlsWEhvqldI/AjTAcOJcFDghp8nf0N5klfc0d0YiXB4Z
         aRsw==
X-Gm-Message-State: APjAAAWISb/bCNqgy/yC+CG88kh91ziQLQWktGGzhnb+ylu72cim4eKQ
        n/Swx0Dns+45xbYyCL647upbpJ27
X-Google-Smtp-Source: APXvYqxVDx/W/57zTCZVpvFFRR/pBb3t6sdMLENo+QYocUt1Yd8e5zQc1fmj3Rhgwbv2iaWu7HAt4Q==
X-Received: by 2002:a17:902:2aa7:: with SMTP id j36mr8906817plb.38.1556647249325;
        Tue, 30 Apr 2019 11:00:49 -0700 (PDT)
Received: from [172.27.227.169] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id c1sm42107809pgk.44.2019.04.30.11.00.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 11:00:48 -0700 (PDT)
Subject: Re: [PATCH net] selftests: fib_rule_tests: Fix icmp proto with ipv6
To:     Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190429173009.8396-1-dsahern@kernel.org>
 <20190430023740.GJ18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dac5b0ed-fa7e-1723-0067-6c607825ec31@gmail.com>
Date:   Tue, 30 Apr 2019 12:00:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190430023740.GJ18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/19 8:37 PM, Hangbin Liu wrote:
> An other issue is The IPv4 rule 'from iif' check test failed while IPv6
> passed. I haven't found out the reason yet.
> 
> # ip -netns testns rule add from 192.51.100.3 iif dummy0 table 100
> # ip -netns testns route get 192.51.100.2 from 192.51.100.3 iif dummy0
> RTNETLINK answers: No route to host
> 
>     TEST: rule4 check: from 192.51.100.3 iif dummy0           [FAIL]
> 
> # ip -netns testns -6 rule add from 2001:db8:1::3 iif dummy0 table 100
> # ip -netns testns -6 route get 2001:db8:1::2 from 2001:db8:1::3 iif dummy0
> 2001:db8:1::2 via 2001:db8:1::2 dev dummy0 table 100 metric 1024 iif dummy0 pref medium
> 
>     TEST: rule6 check: from 2001:db8:1::3 iif dummy0          [ OK ]

use perf to look at the fib lookup parameters:
  perf record -e fib:* -- ip -netns testns route get 192.51.100.2 from
192.51.100.3 iif dummy0
  perf script
