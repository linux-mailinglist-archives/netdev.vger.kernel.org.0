Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027DE25E3E4
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgIDWwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgIDWwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 18:52:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFD1C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 15:52:04 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s10so1826185plp.1
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 15:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=QJAARNZSRgCFp8S7SQdAEcoKgi6MBByb7fTId/lru+I=;
        b=gAFxDxwtY7c0lVAY6nxUC4V0vUx7xLSx46RtB9FfzIl0he96ABcWDG8S1GgHwTcm6O
         XfkcEMJQjkd0gqB5gTkjyVPQiZ1Rtbc/NM9qK07IDufs4HAfyvYH8TumUek7KomWxGSG
         VBFjs1vxxpsEFyHJp3WB/9tidoCEvpf2r5MGiS9PTzwtSeAxve0ljMjbmb5eTE3FCqCk
         zS/SZ/B3LePivwNz2pC/oalWveAOUji8sFSXcwmhJAArOuERORM7AfHqDXXI1Wjs1hTs
         ffdLlgfa6DgTLGtJmYzS3cxFQ49Op5Tf9eVCzPqY8VqQEkR+pRdT01lFsTz7+xl4AUjS
         VtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=QJAARNZSRgCFp8S7SQdAEcoKgi6MBByb7fTId/lru+I=;
        b=UbfOYp/LBjWwpL6/AdYWdjsVlENMYT9V0ecexU4XLanqLJBKsKhNowriEeLy5+SUhe
         yOfG9RUQHKFoUk7O+JOt9EoA0JV+UX0HyfRqNuvU0StccIdygKMHMOP/YHymgMJuEsd+
         zJ5+5+CdgdPhIfGiDI2LAFvf94zHa7O7kT+XQfHE3L90unAi3e1IQ+Z9MPrKQKVv+nii
         8Pd0wbfiU19mnNog0VDTnQ6gPL75OAmZOb3DsPkGPxdtFl7oW4U1jT3ArDA3a9J2I6v/
         5JlBUBPJqRaBuTffzMb526XR68jUH01ucQHL4VQ2P6lVZR5XuDBZkXpa2bX0aR44dx+t
         gZdQ==
X-Gm-Message-State: AOAM530C1pJmuwBaNtwd4BZWOVqX6Gwxe3Hg59gPunYrJRz9qhSimVFV
        fX0PPxdYOJTOED0tqBsSL4dmrw==
X-Google-Smtp-Source: ABdhPJzaDGZbdm2e1DUWVHKsrtinJHECHE7KJSVpxbuWDT+86G3SF0FhS7ro6Lt+GXUaVLWIjQ8GdA==
X-Received: by 2002:a17:90b:1256:: with SMTP id gx22mr10409720pjb.47.1599259923269;
        Fri, 04 Sep 2020 15:52:03 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id q18sm7777331pfn.106.2020.09.04.15.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 15:52:02 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 0/2] ionic: add devlink dev flash support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200904000534.58052-1-snelson@pensando.io>
 <20200904080130.53a66f32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f6c0abae-a5ca-2bbb-35da-5b5480c1ebe7@pensando.io>
 <20200904154722.280d44e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <63a922ba-cbc1-c22b-2f22-cbe2b1c2edde@pensando.io>
Date:   Fri, 4 Sep 2020 15:52:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200904154722.280d44e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/20 3:47 PM, Jakub Kicinski wrote:
> On Fri, 4 Sep 2020 11:20:11 -0700 Shannon Nelson wrote:
>> It's probably related to this discussion:
>> https://lore.kernel.org/linux-sparse/ecdd10cb-0022-8f8a-ec36-9d51b3ae85ee@pensando.io/
>>
>> I thought we'd worked out our struct alignment issues, but I'll see if I
>> can carve out some time to take another look at that.
> Cool, could perhaps be something with union handling in sprase I see
> that there were some changes in sparse.git recently regarding unions -
> maybe it's fixed already.

Probably not fixed for ionic, yet.  I just pulled down the latest(?) 
sparse 0.6.2 and see the same issues.  I can't get to it right now, but 
thanks for letting me know about it.

sln

