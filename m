Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB76E9081F
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfHPTPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:15:08 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:44741 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHPTPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:15:08 -0400
Received: by mail-pl1-f181.google.com with SMTP id t14so2802566plr.11
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 12:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BpRS07Q8R4qg1L/x2A0Q1Zvjt3F68iNQK3W7hCKUhxE=;
        b=Nhg9Vqj+sbum95Iqu6CjauW/79rCH2Y6pJ9/jSmSEN0nAuq9jU1kNh0C14XbVP++Sm
         FNKvaMWePXtZVhedU5iS4dMYpbPy1li6jXjc5aoIeEoy36WRMq33LHC4QVWZoOv9T1if
         3on+EU2T38OWYoG73toTcJSU1EwCBD93Y2WP585CeLxwukoVKLy8zLqvJvBCmjNJHncS
         Jl1bkgiUenmtHKCVw+N88pR4ItUMynBXXFWyuW3mjnrhE1b82Y/ER8C1V3rHDjh72toH
         MDkbZV5CzNzDyiav54P/cylSYlMAOqUbOYkYyqf0UijamIJP8rrF/2d4ZqsqaMu/9Qck
         S7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BpRS07Q8R4qg1L/x2A0Q1Zvjt3F68iNQK3W7hCKUhxE=;
        b=lzI5/V8r10x7/e4jibf8sXeaF9s5hBXtyNDLXU0yeTcx0x6A6f1zexH2yyfU1xlKGJ
         AixKDduOSHel6p1VkEpaE0QWjWN+FYj/vLVkzG+hX7wwknTY6AcHmSDCX96fPANZDTDn
         z7NIt22/qs4PJ93DpwvV3iTLX7sHb7pbX8bZix67cjyQsZ1Gs4JmLi+3Dgim1FESIwkW
         F62lN8GBzhmr7cAd/7toY0xGt7PLKhr452vhnGX7ghZG+Uf6g7QjkzIhS2ORyiBQci80
         O9AThmJ3CXBkLDBca/kf707EY5tywkE/ZhBiF4B3N94jVaLJcfQfcGPqHGzDUnFMcpL6
         mBQA==
X-Gm-Message-State: APjAAAVwNdRzNFhiI536TDjxtdXHpWsAEOac8jdfsW1mvsMy3RjyRQBd
        X9SSiVww1zoYJjIKwhmk6Angjda6
X-Google-Smtp-Source: APXvYqyYC9wIcbNqp3no8NTXlvl7j74JUO9ogV/kB0ISHUEdxTBm0JjVKXHccZIEHarxwTm4QXJBhQ==
X-Received: by 2002:a17:902:7c10:: with SMTP id x16mr4941992pll.31.1565982907405;
        Fri, 16 Aug 2019 12:15:07 -0700 (PDT)
Received: from [172.27.227.212] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id h129sm6345541pfb.110.2019.08.16.12.15.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:15:06 -0700 (PDT)
Subject: Re: IPv6 addr and route is gone after adding port to vrf (5.2.0+)
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a53ff58-9d5d-ac22-dd23-b4225682c944@gmail.com>
Date:   Fri, 16 Aug 2019 13:15:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 1:13 PM, Ben Greear wrote:
> I have a problem with a VETH port when setting up a somewhat complicated
> VRF setup. I am loosing the global IPv6 addr, and also the route,
> apparently
> when I add the veth device to a vrf.  From my script's output:

Either enslave the device before adding the address or enable the
retention of addresses:

sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
