Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77FC3C83AD
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 13:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbhGNLWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 07:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhGNLWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 07:22:21 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7B1C06175F;
        Wed, 14 Jul 2021 04:19:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id dj21so2684908edb.0;
        Wed, 14 Jul 2021 04:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=t9BiriwpOcNEknMm/iM0jLz5+veRh3lTn49M6YjFIAg=;
        b=hlIl5a1YaVJjTVmyVNJnn1PWoxiuSvlzAUJuzged3kbs3f0MnU3O6thtTUDVgDi92h
         a6lVeKJkqp820ALDwGpl0U4ZoxAMjMn+acN9pcaGjCoFS1XYuXtgTSIiCcsOc/c7MsP8
         SV7Ic6lu7fje6N2E7q3i3Gdu7cHTbVqzUHZLBHfD0bbPc+hF+ZjxM+XZGWfRuzu9go1z
         z5rtou2E5Z9P1+P+XLCjbPmePtW3jjmWFaqHG8cW+A6CPjQ0Vuh7TsCvNw/S1tFCMBK5
         /BTyNdrp012ROvh3zA1ftXagejr6fJjP4/LUtc1mqDEBgzXR03Il/kL+LBMq1e71S5df
         9iLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t9BiriwpOcNEknMm/iM0jLz5+veRh3lTn49M6YjFIAg=;
        b=t7cme94IFJwjHHgXpu0THyNluAff06f/cEkgCn9x73zRQxSbQ7+TQiST9rtv2hQjBR
         MaEcBeM4b1tIgIK5YYQBWeodWDOIcH1Wx66BNNo0Epk4CLorR5LdD2bKvYG7brSABJsV
         958RFGiADhcdkjf2VzwOTB7ahwlW1S24vw344DmltTSdD0yDgixhFkV46fpF0ojeRxEg
         9tFdnqJMsZpiGjCkBwc7PPG17Ps91OC7E0oJu11IDBnqSiG1g8gjnBpprjZ2sFHvoXgU
         8aqBblBw/tW5gggLU9cEvjK2KPO++qAtG3AZrhNgcFo7lj66sacN/dIBxgr7V7nszwYs
         8IrQ==
X-Gm-Message-State: AOAM533OAwsToo0zagXhXFKU0Pp/5Td99PpBsR5Fh0eW3RKd5RkFw5/X
        l2F0ot9TDiLxWY4Abo6tx60=
X-Google-Smtp-Source: ABdhPJyStSekdjayeUViGApOVQNa7pYq8yu4/35Q8QcMoWOA1JNSFYmBgCv5OylZFSiL/p6MZ/P2KA==
X-Received: by 2002:a05:6402:35d4:: with SMTP id z20mr13349613edc.138.1626261567652;
        Wed, 14 Jul 2021 04:19:27 -0700 (PDT)
Received: from [192.168.0.108] ([77.127.114.213])
        by smtp.gmail.com with ESMTPSA id v16sm137541edc.52.2021.07.14.04.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 04:19:27 -0700 (PDT)
Subject: Re: [PATCH v3 14/14] net/mlx4: Use irq_update_affinity_hint
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, nilal@redhat.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com, chandrakanth.patil@broadcom.com
References: <20210713211502.464259-1-nitesh@redhat.com>
 <20210713211502.464259-15-nitesh@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <c2d794bf-20b4-95fa-dfba-e85cf6b74bd4@gmail.com>
Date:   Wed, 14 Jul 2021 14:19:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713211502.464259-15-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2021 12:15 AM, Nitesh Narayan Lal wrote:
> The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> that is consumed by the userspace to distribute the interrupts. However,
> under the hood irq_set_affinity_hint() also applies the provided cpumask
> (if not NULL) as the affinity for the given interrupt which is an
> undocumented side effect.
> 
> To remove this side effect irq_set_affinity_hint() has been marked
> as deprecated and new interfaces have been introduced. Hence, replace the
> irq_set_affinity_hint() with the new interface irq_update_affinity_hint()
> that only updates the affinity_hint pointer.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> ---

Thanks for you patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Tariq
