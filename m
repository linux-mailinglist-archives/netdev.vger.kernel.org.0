Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EDE10319A
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfKTCc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:32:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:45040 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfKTCc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 21:32:27 -0500
Received: by mail-pj1-f68.google.com with SMTP id w8so3488776pjh.11;
        Tue, 19 Nov 2019 18:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eeg3sT+P3LFpazmClnKxmGh7AYX/9gGP6xERpJtMYeE=;
        b=TR7i4r4zD/PWJZNd0XwlsyYVwobCePE6PN9NOygPUjwReSKXJiaNkcDKjF2hDLUHMe
         jMIUqvoPUR0AlMv9shmk0ZKJcDBvfUEt5OzKXvhw9KYtHpvfLBETl93zDgElAC+Y65Wa
         pQEA8ewkoqDBfKbuJ9t6WzD3kik7D+JY7ztAAcK46tCuVdPVkjBurXiMKn0PNOPzyP7i
         bvz1xMrUInA/Le7mrsrlmbcQmIXqbXsVY+5qzD6NeweWGYU1fPPEbw3qtR0KzZ8+BbRk
         ukdHWXVfyJMypUwGxCpt9tWdtCWMZ5wdPIeQo4GjLvgMsLmeo/HRQKpLmTOydBucmHZC
         4L4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eeg3sT+P3LFpazmClnKxmGh7AYX/9gGP6xERpJtMYeE=;
        b=XwGoxHsRSXuMKDlysbG8OOOB5K4TrQPFTLEEIVEkOyDgiA9ELiHzNG71CzLoVsEiy2
         uB1lKfV288DDmws6bLkth0hH4dXZ24jAagJ1dIeetPuPFaY0jZppi4tAV2vV5bvXjMLu
         0Pf74nO8KplvUMKzDSlQ10Qh4FPhXTIiJVnga/BrR4dcfdA7KEq6J0sZs0xfeV1BhV+B
         EAomsqnzJUowiEYLkmP2VDaAFrCq1KnF/gNYnYt2m251A1bRVhYO68L9OKqLQmhkeWWx
         UIOOfkKtGqx6ce9ioYHTUoGkREX3dxuWAa0v+zV1xG2rV3lUgTuwi5mFzfINjnnoid3q
         jbPA==
X-Gm-Message-State: APjAAAVZjTyTBPwCx60MYgLvX5X+026cGKWzBKDyVLoMJOxL1myZXxXD
        wayL99ZiG85xnssAfu27xFM=
X-Google-Smtp-Source: APXvYqy5rSy2vtYNz7ndg+Q8xCMAdMM/wZLkaLvRaAku/AovfRb0MPLOn4aQtDrj8JU9ru44wx5OKg==
X-Received: by 2002:a17:902:5a04:: with SMTP id q4mr480767pli.34.1574217146265;
        Tue, 19 Nov 2019 18:32:26 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3071:8113:4ecc:7f4c])
        by smtp.googlemail.com with ESMTPSA id v24sm26555586pfn.53.2019.11.19.18.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 18:32:25 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] ip link: Add support to get SR-IOV VF
 node GUID and port GUID
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Danit Goldberg <danitg@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
References: <20191118074912.51040-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <02ee1ef9-8f8f-ac36-5137-aad97dfbf94e@gmail.com>
Date:   Tue, 19 Nov 2019 19:32:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191118074912.51040-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 12:49 AM, Leon Romanovsky wrote:
> From: Danit Goldberg <danitg@mellanox.com>
> 
> Extend iplink to show VF GUIDs (IFLA_VF_IB_NODE_GUID, IFLA_VF_IB_PORT_GUID),
> giving the ability for user-space application to print GUID values.
> This ability is added to the one of setting new node GUID and port GUID values.
> 
> Suitable ip link command:
> - ip link show <device>
> 
> For example:
> - ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
> - ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
> - ip link show ib4
> ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAULT group default qlen 256
> link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
> spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off
> 
> Signed-off-by: Danit Goldberg <danitg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

applied to iproute2-next. Thanks
