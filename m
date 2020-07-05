Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2CB214D40
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgGEO4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 10:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgGEO4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 10:56:22 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A5EC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 07:56:22 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id a14so16171719qvq.6
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 07:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ki/wzrPTKSEKd71oxUksunAOvtvzgpjlmr2JP+xiF/8=;
        b=XTjpeP21IK0nHSVgxhCagpN0wLL0ZLklYPXAkNf4ZhfnJr+kZIY7jBG0MLY7VQaEEu
         Sr6DTD8zIFH1dquzI6tei7zkU0EbehA5RAz/2iNl+u9CeNBAI1/Q+zq5ZYyNz0IH8Jdo
         0lAWG202TEc6womg+LxPYjNA+Ph1Pn//CyENtOJcShCdeRjcFl8Knyxr/oJ8sa40nRzD
         rKhPes9SWfaq3brhNjYR+o2zsV4a85w+XZP+z7Z2K38QKD5D61b6S506GLlkkq8n6O9j
         yXJIQXg9SIjSH7YLX3eWCNl6Vr1SwK67QKTusjP9rspxBDBZnc0iVAg3VJhDVLHrM3RL
         Ew8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ki/wzrPTKSEKd71oxUksunAOvtvzgpjlmr2JP+xiF/8=;
        b=F0ZwC9o0ZxfiDFtlbKyN3C5aNnKNp70M/uzN+LZwdp5z4V324DZrM4ynKAVeyjPssr
         XES1HUK9t5a2hmcCyWWHE1zvtWqc4TbT7vQ3FOJlunk7/rW7GkGNVaUGf610P2kYbA5Y
         W1BxNXsDMnkjs9QmdrIfKfkrTcLJksg6ofPj6ROvU6NZ3aE+CulhljzWHT/xVM/hhtJI
         ZXZ70X/IkpVZW6IqAnhcSiJQJSbIhj3P8a/sucDEGL+CYiVW55H/7gqpk0EyK13xXYkt
         xiHa6m9T0qNFXx6ZdWnWdNxggz+oILOtJkXyPxToNU70JFZaOXyoZsI4hHRdrTmJU41M
         DvFg==
X-Gm-Message-State: AOAM5336mDOnhDiIDDfgApkGY4s2JnFldIV9ndGmxU2Aj5PGHL1koW4T
        AeK9RJdC1GjcpHT2S62DgMpCttQf
X-Google-Smtp-Source: ABdhPJyl6ix8EuRMVip/MnG0CMT7LRy7hvm9xtxhXZCdL6XR/IWD9GhdY0TYsctWn7+QQYm8SNNlkA==
X-Received: by 2002:a0c:b520:: with SMTP id d32mr43086931qve.6.1593960980908;
        Sun, 05 Jul 2020 07:56:20 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id y16sm15604474qkb.116.2020.07.05.07.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 07:56:20 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/4] devlink: Support get,set mac address of
 a port function
To:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org
References: <20200623104425.2324-1-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ac7f838-c04b-f753-2d0a-62de6a06cf9b@gmail.com>
Date:   Sun, 5 Jul 2020 08:56:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200623104425.2324-1-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 4:44 AM, Parav Pandit wrote:
> Currently ip link set dev <pfndev> vf <vf_num> <param> <value> has
> few below limitations.
> 
> 1. Command is limited to set VF parameters only.
> It cannot set the default MAC address for the PCI PF.
> 
> 2. It can be set only on system where PCI SR-IOV is supported.
> In smartnic based system, eswitch of a NIC resides on a different
> embedded cpu which has the VF and PF representors for the SR-IOV
> support on a host system in which this smartnic is plugged-in.
> 
> 3. It cannot setup the function attributes of sub-function described
> in detail in comprehensive RFC [1] and [2].
> 
> This series covers the first small part to let user query and set MAC
> address (hardware address) of a PCI PF/VF which is represented by
> devlink port.
> 
> Patch summary:
> Patch-1 Sync kernel header
> Patch-2 Move devlink port code at start to reuse
> Patch-3 Extends port dump command to query additional port function
> attribute(s)
> Patch-4 Enables user to set port function hardware address
> 
> [1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
> [2] https://marc.info/?l=linux-netdev&m=158555928517777&w=2
> 
> Parav Pandit (4):
>   Update kernel headers
>   devlink: Move devlink port code at start to reuse
>   devlink: Support querying hardware address of port function
>   devlink: Support setting port function hardware address
> 
>  devlink/devlink.c            | 378 ++++++++++++++++++++++++-----------
>  include/uapi/linux/devlink.h |  12 ++
>  2 files changed, 269 insertions(+), 121 deletions(-)
> 

applied to iproute2-next. Thanks
