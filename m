Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487642C8BCD
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387854AbgK3Ryg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:54:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbgK3Ryb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:54:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606758785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XZHdMrptq2/rYXjufX3+GIBx1xnGVoh3uBEQ7r4wKDM=;
        b=E3ILZUTwwinvQZ7+YTUqQbAYEHuWm2OmnznwRmHQK8xQBBtupL5SNd+i9j9E+KamHGtkWn
        CFRwsKxA+W3RHiqHzi31NEPjrFODObN0W1DXOdrRnRW3YaUtgThWkg5OqV3JRncBsPlUp0
        tPfWjwF7uAlU9AW0YnHiaNrh5ZoaZOc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-E0i_N9UvNVKd6revBs7twg-1; Mon, 30 Nov 2020 12:53:03 -0500
X-MC-Unique: E0i_N9UvNVKd6revBs7twg-1
Received: by mail-ej1-f72.google.com with SMTP id f12so6105498ejk.2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XZHdMrptq2/rYXjufX3+GIBx1xnGVoh3uBEQ7r4wKDM=;
        b=pwiRjfR20+SRJjD8gcRFJnegVPo9BFc/LgNhDnNw8LuLNTAyPgHW4YjS+bdgrxsCO1
         S1YF9m7s5sce3HHOTCKNkiTPLuqgUkjB6Xli3RB+T5raov356OkNCbMU9MCL27UtHdvx
         ri8bappNUn+2tyYF+CL87FTW4ntwc5D3e5jFzYB4pw2UmEO5GXmY+YFMVM7dEXYYyCa4
         6yp0C8vDu1IL/NYkpZmk2yW1tVArDOUH5MZ3vjA3v5M3PDSJlzYmK0Ur6RZlyVub+rD8
         s57ZvEPDRLlG9mGKeXclvNoUPA8o9V6WpF43J1jReC6/1ghAbRnxKhg+a+LoSbUhZg01
         PnIw==
X-Gm-Message-State: AOAM530j1oei6554RNwXGx9shJBg80HAvqQ5uOIMQJlmSXx+SN6iKDvc
        VqWbjlDeYduxAmWR9gRvA8DFU86UONdmAhTmy2K33q/KX0KEcfoK8H+j+lWTf2jbqagNWPUsoJu
        ZvtEUW3REO1JQ8pVXojg5gVprPiCNm04UJBH0eQozyh1AIvY0YekXTIKscYR21pLU+NmP
X-Received: by 2002:aa7:d2c9:: with SMTP id k9mr18165161edr.74.1606758781796;
        Mon, 30 Nov 2020 09:53:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr0C3ztJydvyz+oFfxr6BS9zKoQLZ9ul0+KLwEWxb/tzWQGQh/4ALcMPa0sNYIu2m1iyoA+g==
X-Received: by 2002:aa7:d2c9:: with SMTP id k9mr18165131edr.74.1606758781630;
        Mon, 30 Nov 2020 09:53:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k17sm8657435ejh.103.2020.11.30.09.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 09:53:00 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
Date:   Mon, 30 Nov 2020 18:52:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130173832.GR643756@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/20 18:38, Sasha Levin wrote:
>> I am not aware of any public CI being done _at all_ done on 
>> vhost-scsi, by CKI or everyone else.  So autoselection should be done 
>> only on subsystems that have very high coverage in CI.
> 
> Where can I find a testsuite for virtio/vhost? I see one for KVM, but
> where is the one that the maintainers of virtio/vhost run on patches
> that come in?

I don't know of any, especially for vhost-scsi.  MikeC?

Paolo

