Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A9E4561CF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhKRRy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbhKRRyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 12:54:52 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A880CC06173E
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:51:51 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id h16-20020a9d7990000000b0055c7ae44dd2so12284092otm.10
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=RBOfaOoswQNWiOVx55y+ID4QS96kw6YYNcKV3cWtbss=;
        b=J8UKIkWoEzBSTYZ+tSb1mCbQmr/f9DBSImGHfYIDn2AJQ1CVAw+6vMxvUmEYAFjoxS
         V9hRH0M/u1nq7l2ekb0G5+2bccJ//hEupRUkG3a83At0NqLvRa370kU7l3/WOD8Rq53k
         2W6ahNndEvLEvwAMWbnZi2I0Ir8zke+5eN3XcFOTdm+c+w0E7eLJmkvA08f4OX5j5P/8
         CmHMHbWmTFblbk+PhJEB7yTC9I7y8GhZ/R15ksHSLmUrGKYQeQooBJiLgk70uq0o9sIW
         eXZnWwBinpYqUTtLYR8twRVOqoyStRt/KfoOwHGaLKbu52DkBck9un/6HMelsOcf0FwX
         dTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RBOfaOoswQNWiOVx55y+ID4QS96kw6YYNcKV3cWtbss=;
        b=oscGD9b3habRKHh2oAH1/kwxKMFgqOpzZ1QfaV6asY+Ky1ftQxRTsGDVTkNDQWwJ0t
         DyM5wBpJQwhZLimXYpYjDDr++cMR+nidEQz1aLI5UMGPI5D0V3ipIYmH2vyHentYVIHM
         XVd++jVBZfgCM8W9LsGNjIKj4ZBXQopij6TSLy9150I+u66PZ7MeQpqWUyJOFV+oH2hk
         s/P7FGa/rrMrNo5/LD0wg8yLb46A0uAiBMSCwz1LVB+NrWFOvx1lIBacG4VEYts7obQS
         riKS7cSYQkLKhiafNTV3+fKh1IYcw39FrB2dbSnIQa5188/WHufaGKb8fMUSWC9zYAUO
         I2fg==
X-Gm-Message-State: AOAM531KAblOy6yTS45vtGROkSllMN67RcYS7AscTykR+7F3I+O3HJQd
        rHG7PRrxJGArcFs4OZ8pU9k=
X-Google-Smtp-Source: ABdhPJyw+aO0LYUv3ygkNpwp1FGmbNRJTPkcJkLp4JOOf/9S8ERJhhtpV3S4dSxFHN9vVp+Z/Gg+PA==
X-Received: by 2002:a05:6830:201a:: with SMTP id e26mr18011456otp.130.1637257910975;
        Thu, 18 Nov 2021 09:51:50 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id x17sm85569oot.30.2021.11.18.09.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 09:51:50 -0800 (PST)
Message-ID: <448357b6-1cae-ac16-2a10-f11231fc5bb5@gmail.com>
Date:   Thu, 18 Nov 2021 10:51:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next iproute2] vdpa: Remove duplicate vdpa UAPI header
 file
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
References: <20211106064152.313417-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211106064152.313417-1-parav@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/21 12:41 AM, Parav Pandit wrote:
> vdpa header file is already present in the tree at
> vdpa/include/uapi/linux/vdpa.h and used by vdpa/vdpa.c.
> 
> As we discussed in thread [1] vdpa header comes from a different
> tree, similar to rdma subsystem. Hence remove the duplicate vdpa
> UAPI header file.
> 
> [1] https://www.spinics.net/lists/netdev/msg748458.html
> 
> Fixes: b5a6ed9cc9fc ("uapi: add missing virtio related headers")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
>  include/uapi/linux/vdpa.h | 40 ---------------------------------------
>  1 file changed, 40 deletions(-)
>  delete mode 100644 include/uapi/linux/vdpa.h
> 

applied to iproute2-next.

