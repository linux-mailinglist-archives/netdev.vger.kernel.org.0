Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0004929CAEE
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832058AbgJ0VIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:08:21 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54920 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502171AbgJ0VIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:08:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id w23so2674149wmi.4;
        Tue, 27 Oct 2020 14:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=cWYcgar89VbgMBiXIooRPzFGEhxdKRleH7SL0eqjWvgFLt65pm8yPjwJsZio1JxZSQ
         50Ugo2q2eupeaP0IXsMBKIPS+eMVoZvSb/ATyMTbtin2FUuZYneq7TT+uixn6Hmhj3y/
         CMV4komX7V8SehIKPRtENSYvLudLE9ag93oi/g/f+mM+vZwrtuI6D17DcXqXUKHOT9vW
         Q3ZzbuPfd5acqQ98bmlbGg7mJkpwrZqSy9DktbCtyy+PInDBcuDYWoBld4QbRXct9CNJ
         a0gVBsccvJsASZ759IkIboIAKHGGRJ8NoHfC37v/IQvj6QJFgfeTVc5NGr7ySTrQZH2c
         yg3A==
X-Gm-Message-State: AOAM533Nuk1RX72QzVdjnQoGPOBVmSNJNBNtGw7d62+yYraszpIpqloE
        mNburAUWSFyzjxqhK9Ee4g8=
X-Google-Smtp-Source: ABdhPJxnlO6ffp5qWoU5jOtD133cQ5prG7Y2H4oyC2WTpcqYd3cQ2KUgy7rtjGlgdBJXSp8U9aC7qA==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr4896067wmb.51.1603832899088;
        Tue, 27 Oct 2020 14:08:19 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:8235:3100:f389:bca1? ([2601:647:4802:9070:8235:3100:f389:bca1])
        by smtp.gmail.com with ESMTPSA id y201sm3336956wmd.27.2020.10.27.14.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 14:08:18 -0700 (PDT)
Subject: Re: [PATCH rdma v2] RDMA: Add rdma_connect_locked()
To:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chao Leng <lengchao@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
References: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <73296987-3f3e-7d39-b131-f93621d01851@grimberg.me>
Date:   Tue, 27 Oct 2020 14:08:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
