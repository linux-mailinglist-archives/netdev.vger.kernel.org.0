Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C12397EA0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFBCQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:16:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhFBCQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 22:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622600108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cle+/CWEjt+Ggeb0RHpQ+aAs+qfHNk8GUbIdw+15kXg=;
        b=YSKgRbdWguVx12SQf35gaGbXhTXgq0UuWgay/WF6abphoJmMZkjDwlKB53966bZ6J2qjNs
        EDK/ZF968cDDyvkiIZoR/rWNm1XqNBv/lvfde2rvv44N58YVs4A2Nq3mMUln6NPXAbDHlU
        ToZmlHgyoN0Fz5PnEPHOX+9VmabXeTI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-TJTwGZLzNPmWaVl52XEpIQ-1; Tue, 01 Jun 2021 22:15:07 -0400
X-MC-Unique: TJTwGZLzNPmWaVl52XEpIQ-1
Received: by mail-pf1-f200.google.com with SMTP id f19-20020a056a002393b02902d8b0956281so627504pfc.19
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 19:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Cle+/CWEjt+Ggeb0RHpQ+aAs+qfHNk8GUbIdw+15kXg=;
        b=TnoKYgUeayukdLlPmx/8RwcJpZAYbENyEtgvXqu3IqzkRr9mMt6c6Zsf9WkMMUFDhO
         1PCb494VO/csO4/t715FphxySZbQvYHzxrFohuy9iHuVxjXqhlXya1YQ4fW4GSEmyG22
         howjck/xgE/d8IrwziKqloPd/Zuyzh7isa3gaiQVqOIfYJbvnuR0/QdCNPHpbfRnzYs8
         pffSxrUr5vilAMlJX/hIVl2aba9quAnWMFL12pWQzExBW2e1jyigBvPI0N0afeCQjlgk
         Ys5Gz88O1b+Yj3E3IfzG/Fr6j7FFN7wVUYkYo/Cly2qfjAzOUSV062WAXb2KbCJmPWMB
         lWjg==
X-Gm-Message-State: AOAM531KvO3rtt6p6i9S/NbEnMlhVtPFLItFD4Hq+MkVjUN3odqtJYQN
        AdUTUdGT+QBg75bB+PM40zYOrqgr3pb4ah+mJC8TTZyTSOMEq0PWxdZCPW6jm2yw6UMuVZNn1Yu
        ZA/df7cows9o1PioA
X-Received: by 2002:a17:90a:a08c:: with SMTP id r12mr2883168pjp.204.1622600106065;
        Tue, 01 Jun 2021 19:15:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykGnr2O1DetdkzyvT3UnCkBGf69svfeCgS6uB7/1SFywbpMZIzEMp+JZbR6AtEywCmSjue0w==
X-Received: by 2002:a17:90a:a08c:: with SMTP id r12mr2883149pjp.204.1622600105909;
        Tue, 01 Jun 2021 19:15:05 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l201sm5847594pfd.183.2021.06.01.19.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 19:15:05 -0700 (PDT)
Subject: Re: [PATCH V2 0/4]
To:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com
References: <20210602021043.39201-1-jasowang@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3a1f66f8-12af-3853-49a9-3bd27062a3bf@redhat.com>
Date:   Wed, 2 Jun 2021 10:15:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602021043.39201-1-jasowang@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/2 ÉÏÎç10:10, Jason Wang Ð´µÀ:
> *** BLURB HERE ***


Missing blurb...

Will resend a new version.

Thanks


>
> Eli Cohen (1):
>    virtio/vdpa: clear the virtqueue state during probe
>
> Jason Wang (3):
>    vdpa: support packed virtqueue for set/get_vq_state()
>    virtio-pci library: introduce vp_modern_get_driver_features()
>    vp_vdpa: allow set vq state to initial state after reset
>
>   drivers/vdpa/ifcvf/ifcvf_main.c        |  4 +--
>   drivers/vdpa/mlx5/net/mlx5_vnet.c      |  8 ++---
>   drivers/vdpa/vdpa_sim/vdpa_sim.c       |  4 +--
>   drivers/vdpa/virtio_pci/vp_vdpa.c      | 42 ++++++++++++++++++++++++--
>   drivers/vhost/vdpa.c                   |  4 +--
>   drivers/virtio/virtio_pci_modern_dev.c | 21 +++++++++++++
>   drivers/virtio/virtio_vdpa.c           | 15 +++++++++
>   include/linux/vdpa.h                   | 25 +++++++++++++--
>   include/linux/virtio_pci_modern.h      |  1 +
>   9 files changed, 109 insertions(+), 15 deletions(-)
>

