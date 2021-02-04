Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7318C30E983
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhBDBiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBDBiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 20:38:07 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBDFC061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 17:37:27 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id h6so2110484oie.5
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 17:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=39A9Boqpl+Q5qPNytwKZXYAQVcXFAhqxO5/2wT5npug=;
        b=mod0Don/QV9FTi/EJbgWnJ0gQMIaaAjgFdaq7/FFT8PBXQK25y/Mxcbw8zGv0HBAju
         qAMlCH4EkZFYZqil7Jor2YuLPQrsvMAGXeG3HFuSx8ZCUnLcyfMTm+Zm+jzFRL+BuczU
         I0fKU2F/dBI8lJBGBL38DW0T5G//wfSoPV7klAoI4dPVa3/0h89/Wfqodxic65/lU6oa
         SsPrweW25ZC//g7uJe5qWkWK1hwS1L3zkpU90fy5k4jpvvLrPjTdNKZx2AUd8y/7GFMX
         14pNV0OL/47YqwrQUsk+bdQ2Mk9paqv9VJyaLE/KWXvOIScjsusYwEWMySmb4Wc1TSzW
         GhfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=39A9Boqpl+Q5qPNytwKZXYAQVcXFAhqxO5/2wT5npug=;
        b=VOhwH3I6GFAkXESebg/sDffotMHN8JkZtxguTb9Kt0d+U24aqVdTBG2uTuXzVlyjzV
         fuQSfjsujzEsd45zHgkChF7X96U+OLh16BjjSug9e2a2ct8m8uuvvs6N/o53nl9Cix3F
         H9dZp+1/lpyFsgUXChEV8jKwkH0PxFE6yMzDQjYgamOLNaf1XyMlycIUkHuvf4A8wXVm
         5XkSbAlgpYTw5FfwJwUah35qco60eS8VrBStmSE79hQbHbcS5SUJacSAvmrKrAtatAXL
         4cB4Wt6JXVH9QeHGFA0NN5WOcxuOkyr+kp2ZfRixEeu2Pwe3EWt+NobwUKEaQdgqNHFN
         VswQ==
X-Gm-Message-State: AOAM531ML4/4Qocyq72iV2l6zFlq6W0wDLV7aawz2bE1iFK5sKNwFyZE
        88J5d8ulO2IcCs0DD5udElQ=
X-Google-Smtp-Source: ABdhPJwkqnu6CPAUAxUy0ZLKytwwS1bcdhX4vQ7WglWWFz4vphsh9+ISO2BRaWsFJWa3wGHvDHtwTA==
X-Received: by 2002:aca:cc96:: with SMTP id c144mr3752003oig.10.1612402647014;
        Wed, 03 Feb 2021 17:37:27 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id 68sm803189otr.16.2021.02.03.17.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 17:37:25 -0800 (PST)
Subject: Re: [PATCH iproute2-next v3 1/5] Add kernel headers
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, mst@redhat.com, jasowang@redhat.com
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
 <20210202103518.3858-2-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <abc71731-012e-eaa4-0274-5347fc99c249@gmail.com>
Date:   Wed, 3 Feb 2021 18:37:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202103518.3858-2-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 3:35 AM, Parav Pandit wrote:
> Add kernel headers to commit from kernel tree [1].
>    79991caf5202c7 ("vdpa_sim_net: Add support for user supported devices")
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git branch: linux-next
> 

Thinking about this flow a bit more: If new features to
uapi/linux/vdpa.h are coming through Michael's tree which is not sent
via net-next, then I think this header needs to be managed like the rdma
uapi files. In that case it should be added to iproute2 as
vdpa/include/uapi/linux and you / vdpa dev's will be responsible for
managing updates. In general, this should not be a trend, but seems to
be needed since vdpa is more than just a networking tool.

