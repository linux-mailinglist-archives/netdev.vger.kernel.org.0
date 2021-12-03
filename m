Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E7E467BE2
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353162AbhLCRAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhLCRAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:00:21 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67763C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 08:56:57 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso4113574otr.2
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 08:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AJr6Qe8CmBog6fB3TwA4tpkEoCiIknifXdVOwalv0Bc=;
        b=OhNb9hAXEFm2e3Pxw4XHiAx7MWclXGGkzrZzqvYL5vZyyw/qNDDf+xBQAYS5gNM5Dr
         1/C48dUw8hqrhP338+zra70ygAD/iGCLaCDhZRVjNUNUr5k9vCSzT0Uriido/tDcJHIV
         HWwHbOdVziSn/jW8gu0qMRnQykQvQvJAlylVIZRocPO4yJxjRKs1Rrn3S9rn58b3mrTz
         q6mzyQL0BPH2GuP0G9WuQ0cj3XxWAZhl0k+1gKMyCbRr26PguhYsaor4oMXogSPYQrfi
         o+VDUD8uLo/h7S2FCjuH4HuSo4PFCbBxXj884jr4oNwEbkBX81onD8tt5ove3txL3bmD
         G4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AJr6Qe8CmBog6fB3TwA4tpkEoCiIknifXdVOwalv0Bc=;
        b=1ig25yfZK3AxnJzp19i35k+LLHkExBHCV8msP+U8d21YwPw0AHd18DuOBZIck5NPwU
         mfb5Z3rf5mQ5xeUukz2+Sf/dQMN/ox5DWsImzscPzoT/FOev58SEdjccup00K5cIj7v5
         LM/429hY0SvJ8p5JUQrPSIgocvR0OnjgsajGBoRFbPJoMlrJK98FMRDW7F8A8xOKYYoY
         SwtVamGusMuOhJdgUoI5Y1g3gwAs19v7jg4R7fAmocXw8tP1rAazWplXKL7IB7Ag071Y
         nHOd6CqJ17LVNrNtvknVn7HirKRvqc33+49tRRk72L8BhmLcF2xywRx+TRDu8lTbrpRU
         E92w==
X-Gm-Message-State: AOAM5323j2bK4f6D2NmADfaj+aFCWeyZ8SQG7xhNd155MJNUboJOHJNV
        V+WZnYT81rKx/V+FCTCgqNjjDa0q5vw=
X-Google-Smtp-Source: ABdhPJyyNyVp+OanpDa2j57rmTai20OUB4w6oTfC93/56KQzNMqP4MdZ6hdhPhMqXf58ql3BraITZg==
X-Received: by 2002:a9d:7758:: with SMTP id t24mr17437788otl.264.1638550616832;
        Fri, 03 Dec 2021 08:56:56 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id i3sm668960ooq.39.2021.12.03.08.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 08:56:56 -0800 (PST)
Message-ID: <7472fe36-b0a9-d731-8c2f-20be0411b96c@gmail.com>
Date:   Fri, 3 Dec 2021 09:56:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [iproute2-next 0/4] vdpa tool to query and set config layout
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com
References: <20211202042239.2454-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211202042239.2454-1-parav@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 9:22 PM, Parav Pandit wrote:
> This series implements querying and setting of the mac address and mtu
> device config fields of the vdpa device of type net.
> 
> An example of query and set as below.
> 
> $ vdpa dev add name bar mgmtdev vdpasim_net mac 00:11:22:33:44:55 mtu 9000
> 
> $ vdpa dev config show
> bar: mac 00:11:22:33:44:55 link up link_announce false mtu 9000
> 
> $ vdpa dev config show -jp
> {
>     "config": {
>         "bar": {
>             "mac": "00:11:22:33:44:55",
>             "link ": "up",
>             "link_announce ": false,
>             "mtu": 1500,
>         }
>     }
> }
> 
> patch summary:
> patch-1 updates the kernel headers
> patch-2 implements the query command
> patch-3 implements setting the mac address of vdpa dev config space
> patch-4 implements setting the mtu of vdpa dev config space
> 
> 
> Parav Pandit (4):
>   vdpa: Update kernel headers
>   vdpa: Enable user to query vdpa device config layout
>   vdpa: Enable user to set mac address of vdpa device
>   vdpa: Enable user to set mtu of the vdpa device
> 
>  include/uapi/linux/virtio_net.h |  81 +++++++++++++
>  vdpa/include/uapi/linux/vdpa.h  |   7 ++
>  vdpa/vdpa.c                     | 198 ++++++++++++++++++++++++++++++--
>  3 files changed, 277 insertions(+), 9 deletions(-)
>  create mode 100644 include/uapi/linux/virtio_net.h
> 

please update man page(s)
