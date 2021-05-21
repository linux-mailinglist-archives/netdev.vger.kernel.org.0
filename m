Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5718C38D110
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhEUWRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:17:34 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:52146 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhEUWQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 18:16:55 -0400
Received: by mail-wm1-f45.google.com with SMTP id u133so11853232wmg.1
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 15:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w+BCs0/fYIVtbt+M2LFvBfQJLxg/d+0gZQ+CgKy81c0=;
        b=AUXKfXGcl51PtGyuM5lIsQ3WN8cSiSq2gEcGYoHhSltS3pXj9RGXc+iSN89uJ3xQtC
         BMHuQPAfH2VnssA8ReLuq9de5d2emLtxJuxXUAxBRx5hkTE5arm5L3GCDNVzIzVrqDmW
         SBfaME6I8j64gG7xLHZQLnvLcSrNErVXKakv1y4+a5JooZqpMW1iqG0qRGYFPfCN7Q3f
         aoA0/r0m2EmLzzCkknI2EFv1lKWmmIVCTbo4cSLSLrHR6Z0p38wF/d3bepseqaA+x3qj
         +Mcr4KyrLwRsFKPV2ugp4UNoEWXnyUwwfjCeO02zJJh8qD7oHLALE1XmI0mTzcGUB9xT
         //rQ==
X-Gm-Message-State: AOAM532eO0uj2iRzy9axZDo4c5v+6z+h4TfDTi23drDPSCJvfZt24UFN
        frwvnKNVdQTyyZxP/HnQybI=
X-Google-Smtp-Source: ABdhPJxnEEk1A1pKneck8t0V0D4p7ycvKQwi0UA9grP02aA3lSh+SbHz4NecmT0KUa/P4uzaIXljbg==
X-Received: by 2002:a1c:dd08:: with SMTP id u8mr10869808wmg.62.1621635330755;
        Fri, 21 May 2021 15:15:30 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:66b2:1988:438b:4253? ([2601:647:4802:9070:66b2:1988:438b:4253])
        by smtp.gmail.com with ESMTPSA id e26sm740916wmh.39.2021.05.21.15.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 15:15:30 -0700 (PDT)
Subject: Re: [RFC PATCH v5 02/27] nvme-fabrics: Move NVMF_ALLOWED_OPTS and
 NVMF_REQUIRED_OPTS definitions
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, hch@lst.de, axboe@fb.com, kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-3-smalin@marvell.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <d3e57423-24ba-7402-9783-da9e24482376@grimberg.me>
Date:   Fri, 21 May 2021 15:15:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519111340.20613-3-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Arie Gershberg <agershberg@marvell.com>
> 
> Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
> to header file, so it can be used by the different HW devices.
> 
> NVMeTCP offload devices might have different limitations of the
> allowed options, for example, a device that does not support all the
> queue types. With tcp and rdma, only the nvme-tcp and nvme-rdma layers
> handle those attributes and the HW devices do not create any limitations
> for the allowed options.
> 
> An alternative design could be to add separate fields in nvme_tcp_ofld_ops
> such as max_hw_sectors and max_segments that we already have in this
> series.

Seems harmless...
Acked-by: Sagi Grimberg <sagi@grimberg.me>
