Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AC555A65
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfFYVzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:55:50 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:43898 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFYVzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:55:50 -0400
Received: by mail-ot1-f46.google.com with SMTP id i8so400701oth.10;
        Tue, 25 Jun 2019 14:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=mZGUWqsr3PWSUd/ie6dJbZzBcf2R4V05dg0GZFlgfltkdZ3QK8lx9oiGh0ohHRCOVt
         NqqfRiArGrTeCpmHLyY1hcxON2YcQJiFSjCFU315ZF+E2RILsEZNI5KvAcoC+1ESjTaP
         F1bGiTVXuQD12TRHhQZV8FHlWvaPXpf0ke447yypNr0P0Y1k7ecLSjqTlPABhfVe8Crg
         FZycBW7XuLEIQ7M3uBwum8YDm+hSFO2wyGZhIReoyS+M1xLGzI7B0qItRcnjaqcXqedg
         oDKN6D76B6knqEYycHc6gDsDQSjG7bb2wycxUeN0z1OX/TM1nqwci7Zv1uUkNxzW9B53
         cxAg==
X-Gm-Message-State: APjAAAXkd69vwkxq3MHtfH0+3epUSPq68wvtGVco8rhpr1Fy8eNycQIm
        EfxKMzblJfniG6IOWi8LRPT68Kmc
X-Google-Smtp-Source: APXvYqwXcn3MzeexU5TGPleWFhZB1lrmbHAvdK/IFZbG3UPwjlmBX3dn7FgFTT2FwLqRKbptbi02tw==
X-Received: by 2002:a05:6830:15d7:: with SMTP id j23mr524922otr.176.1561499749498;
        Tue, 25 Jun 2019 14:55:49 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id b188sm2240104oia.57.2019.06.25.14.55.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:55:49 -0700 (PDT)
Subject: Re: [for-next V2 04/10] linux/dim: Rename net_dim_sample() to
 net_dim_update_sample()
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-5-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <840a9f78-4f89-75c7-58af-9e0349277b1c@grimberg.me>
Date:   Tue, 25 Jun 2019 14:55:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-5-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
