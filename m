Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB11541D0C2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345479AbhI3A5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346064AbhI3A5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:57:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B74C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:55:39 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l8so15723320edw.2
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 17:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6BeD0XWXb76UspkMKo6gDtITs/4SMFi3FD7snzTaIaM=;
        b=VsUzgtyDzVnV9KdaMUDzqWTb6TQU5oOq4Kt2WM8WYv+6ntpxQIljvmKURhHQajqiwJ
         P59CHmFOsHVgr5AEDaogA5gIiC3gZo3VlIekbsTA4BCNM24w0z7U+E7CFzytx2MLm3+N
         EjAHvgNxQJaGlgC7rGvhAXX85EE/WA9FS8ljnSSXYZY+pAW+kkDAXbEX47cCgI7aEXuM
         08X6uheo73EEsMLG63nxlMXFzjCaVF4BYgKWn4fIgQYZWrgLe8tZFsILqcPm4OGazk+1
         17/qgGpLWULpd3vfSnHOeuAJrYOrrU+nGqZVoXEH3tvvbsYlpzJg3eFTjBVL2i3EKD+o
         xSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6BeD0XWXb76UspkMKo6gDtITs/4SMFi3FD7snzTaIaM=;
        b=4IeiadKfLO/GKh59FZnvh3H0EF5/acN1N5tuG/hObIDwV2ATj7jCYd32zhI6YAzUcO
         3FDhqCofgcQr5FCWgR2O1Qm9E+01CRwWT2tLk7IpP2CHYs8cmun5bDr+jBYcODHBUC9r
         e0G63SxKUGeTNfuMwUkUh0qku69gjWObj1dP1raHpY0raCMqW8LhgWN0pQ7f1FkGZ7bL
         pTJenHsic7ZtR/3diKuxJ4Taac+Kxm5MIkBrWG/WgTzFAdu0cFx66hCP5r603KVBCbkM
         KdKUkabJrcqEwZ1ljPzmCUqsFN8X0q/DgFu2jV94Mq4vM3lT0Pq2sJB9/yLQxvK1MhXQ
         vmEg==
X-Gm-Message-State: AOAM531BkVOhNymN9qt4vViVBSHPlkjC+s7rH/VLwKxmbPMfKfVhN9TT
        DhIO/hj/ajF2FyDId6cru7k=
X-Google-Smtp-Source: ABdhPJwnuo20Qmpo/7TcFunYFfmY39Td5Stk+eQL6yJwbjSMnLewq9lf+Xr5GVFl+g9ng2gZ8AYXgg==
X-Received: by 2002:a50:9d04:: with SMTP id v4mr3490237ede.399.1632963337796;
        Wed, 29 Sep 2021 17:55:37 -0700 (PDT)
Received: from [80.5.213.92] (cpc108963-cmbg20-2-0-cust347.5-4.cable.virginm.net. [80.5.213.92])
        by smtp.gmail.com with ESMTPSA id k21sm647396ejj.55.2021.09.29.17.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 17:55:37 -0700 (PDT)
From:   Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
To:     Jian Shen <shenjian15@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linuxarm@openeuler.org
References: <20210929155334.12454-1-shenjian15@huawei.com>
Message-ID: <ca0ffcae-a82b-f81f-7702-410650e4677c@gmail.com>
Date:   Thu, 30 Sep 2021 01:55:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2021 16:50, Jian Shen wrote:
> This patchset try to solve it by change the prototype of
> netdev_features_t from u64 to bitmap. With this change,
> it's necessary to introduce a set of bitmap operation helpers
> for netdev features. Meanwhile, the functions which use
> netdev_features_t as return value are also need to be changed,
> return the result as an output parameter.

This might be a terrible idea, but could you not do something like
    typedef struct {
        DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
    } netdev_features_t;
 thereby allowing functions to carry on returning it directly?
The compiler would still likely turn it into an output parameter
 at an ABI level (at least once NETDEV_FEATURE_COUNT goes above
 64), but the amount of code churn might be significantly reduced.
Another advantage is that, whereas bitwise ops (&, |, ^) on a
 pointer (such as unsigned long *) are legal (meaning something
 like "if (features & NETIF_F_GSO_MASK)" may still compile, at
 best with a warning, despite having nonsensical semantics), they
 aren't possible on a struct; so there's less risk of unpatched
 code (perhaps merged in from another subsystem, or in out-of-tree
 modules) silently breaking — instead, any mix of new and old code
 will be caught at build time.

WDYT?
-ed
