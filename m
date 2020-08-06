Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AD223DFF6
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbgHFRzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgHFQ2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:28:51 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A82C002146;
        Thu,  6 Aug 2020 09:27:14 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 2so41360884qkf.10;
        Thu, 06 Aug 2020 09:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=225Ec0jRi2rAkWfglvmB14+Xf1LKuW7KGiY8EdguzPY=;
        b=gCn6dHyyEFOLso4hE2aDVTi8b0kiyhxz8nA2XSaJIXeoE6rVRgBiscAdsxsnI3WRUE
         KcUSEcVt4bm4xzu3GXLEwyrGKte8Axr+quDfcNUO3IBUQOwiyMABPj3u5WJl8t3BXaYl
         JzREWGGAlr3cz/1PVS2HOxoTvjJnILxTewac1S0zOSxmPI5z8iBm18OofZIufsh/gQEo
         imKv8pmp8su5Tza5u8hS++MWlC2HXBBpV4wRMvTY+3KhZXVVZjcq/L+Y1Gqb9oCUQa84
         dvbPOgyAU5u1ZFi13egxlSEOz4pvyl9d0lCIH6otgnRk4PqYIjtNZPPrTMW1ADpGneXd
         QLJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=225Ec0jRi2rAkWfglvmB14+Xf1LKuW7KGiY8EdguzPY=;
        b=dteynfkMBHVniA2WbF0E41oKD0gh223h90M0t2g4nY07ntVGTVrYL85ddrT2T0bOyB
         YliyBhzzXUAtNStVRv2eI/9PpcoTxqKGbtEPUgzHfcU1CtdWlbYZLUEGQhmGAt77obfO
         VEx9ONEj2EEt2N7hP42wMAOzriSSe11xmG6Fxbkk7Ilxy48M8TE4gSrgBeTGgBiPZ6kJ
         ylnmOCkYPMvdR0iruYx7VgA/Ri85qsLrwVEDs1CuzXo4XXXS1PHvt13SmrkVMn0drUEf
         MfXYnm5xMgA49d+xYhTiC5rWJbm5NZBpBw7rniV+zjbDyOj9M9E6joK67zpO3jEJkQNL
         EqDA==
X-Gm-Message-State: AOAM531LN/cmskacD1khPn6OiZAwX9r15GPxH10ZUayWihH4TgcENCmZ
        ZP6Yw8KT4hulwntcg/1Hyc71BSrE
X-Google-Smtp-Source: ABdhPJywwDUyEWOTJnzS8mTGAzMp0JNB0OzHvugpIl013ZNxAihGlVDlV6rMjCjkt7Bcu9dTLxS1sQ==
X-Received: by 2002:a37:714:: with SMTP id 20mr9698368qkh.367.1596731233528;
        Thu, 06 Aug 2020 09:27:13 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:7c83:3cd:b611:a456? ([2601:282:803:7700:7c83:3cd:b611:a456])
        by smtp.googlemail.com with ESMTPSA id v14sm5077731qto.81.2020.08.06.09.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 09:27:12 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/3] Global per-type support for QP counters
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Ido Kalir <idok@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200804084909.604846-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f571ff0c-6bd4-3192-1c88-7957d94a5a45@gmail.com>
Date:   Thu, 6 Aug 2020 10:27:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200804084909.604846-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/20 2:49 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
>  * Update first patch to latest rdma_netlink.h file.
>  * Drop RFC, the kernel part was accepted.
> https://lore.kernel.org/linux-rdma/20200726112011.75905-1-leon@kernel.org
> 

applied to iproute2-next

