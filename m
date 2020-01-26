Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D04149CF6
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 22:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgAZVQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 16:16:58 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38659 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZVQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 16:16:57 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so3947023pfc.5
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 13:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YPVoU3w4GzDttSKJJQscixNzCxnKWSTDOB/1Ul1uvN0=;
        b=h/Q2U/hJ4BOoSFFa6juQ4Tn500DQCRlTj47Fc4qiQpaRjQsVALMN45NrKSEUQHIQ++
         4hIPcZPxczFGlxdmdT/i9KxzrYWJNWZOiqYDor0pLkTSpmsqC0WQz1BbSeSY/scbzkWM
         BmlbseeIk07NQbHBDGIWbPLAr6rwtyGp3/V3/OxjXBHKbxErgZ6kw1QBGUQT+Kno0J0z
         QZsU1P6AgXgfnoXLNZtB3UJ5L3BV58RWBtvZdj8UV3CBeiMl4TNMFf+5ImSdUZ27FK2z
         TZ8GN8zLvBWBaOIw69MBNEq9TMXjciiau1d4YtlZgDYk7biBMo3U846CuTfGmxGg4T5k
         Vw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YPVoU3w4GzDttSKJJQscixNzCxnKWSTDOB/1Ul1uvN0=;
        b=uIK4r4BSbROwsOzaWZoztCU3rCZlBwusgmwPL9xQX2UPPTevRE0WTMFFca/0aZwT9Y
         4uAe+CK2xpzAWJCTzX7ec7nXG0Nx0FJKVe47RJqeOiOXIGXt0ZnOdoF3W0j233q9uQcj
         7toblTQ/ZkZfxhVwE4dvk1Gq2Fo3sXARUIlDHI1riQkD0UTOQnziinlKi4si42dn9J9r
         iTNOMnYY7ltyuJqetlnNBDPd2GGs3RJkhrEFYM0WZoKMyvA2v0lZIFy1ViWdUe0coq5S
         RBK88CzYjB9Fl59UKZ5Zze+gEk0/cmgiyAn36zaMJUFD9/egGkBR+9nUP9dPw3EuGXPi
         O7PQ==
X-Gm-Message-State: APjAAAUKi++SatUBl2royJQfSwVHJtXZhJBCCVwP7ZZ7ScGp7uJCh3jk
        yMvLjG7B0n7lDCWwy8o85aHGrQ==
X-Google-Smtp-Source: APXvYqxMM4fiKn3ewHAo7ZomcUhfYldlvTddN/i3BmJQ+1VeTaCm57O3AkZ2OlqztoNEjQfLTsDyMw==
X-Received: by 2002:a63:34cc:: with SMTP id b195mr14812533pga.268.1580073417071;
        Sun, 26 Jan 2020 13:16:57 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id b4sm13278774pfd.18.2020.01.26.13.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 13:16:56 -0800 (PST)
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal> <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
Date:   Sun, 26 Jan 2020 13:17:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200126210850.GB3870@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 1:08 PM, Leon Romanovsky wrote:
> The long-standing policy in kernel that we don't really care about
> out-of-tree code.

That doesn't mean we need to be aggressively against out-of-tree code.  
One of the positive points about Linux and loadable modules has always 
been the flexibility that allows and encourages innovation, and helps 
enable more work and testing before a driver can become a fully-fledged 
part of the kernel.  This move actively discourages part of that 
flexibility and I think it is breaking part of the usefulness of modules.

sln

