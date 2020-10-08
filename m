Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0453287EF7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 01:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgJHXFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 19:05:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50280 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgJHXFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 19:05:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id 13so8019708wmf.0
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 16:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dB20HVoUg946vxWKworaTCw4p2EkZ/5MfYI2isxQJwk=;
        b=Lhk3zA9SVZqs0F+/sYqU3C3nc5hdKSshoqNPL094g9B9Sxzb0VlCWnTj3A0kWu//P6
         EEqaijVaEyr4bWtmHcJMS5zaGl9e/up8SY1YfaCo3fUxeBeoXC0ukK2kgmDvnuRwvdZy
         qhTehIpUIhgjyhwwya3mNXuqVnQHYQUnBouae2H0arCD3yM74c7ai+Rp2TGAJB4f4kKS
         WTxi0a9Sh+Ed12atEStiD+sJnxVOhtYR/vRDzruC01eLGN7p26p+6GBuxVNGz4kn4C1I
         LK03AUSGzq8YcYriGirje3WzfjsAgVK6HKQNowkVt37kGnR0N0RAzrsjI6lqJb9tPzLI
         NUBA==
X-Gm-Message-State: AOAM530YZT/Q4SQYZxt0kJOowRkl4bfyOvvzq/sX9M+Uv+geUm5nt45x
        3B+cpUA18Rwv4kIRT/lFloo=
X-Google-Smtp-Source: ABdhPJxjKwf6S8u3irrDfOz65cWcm+G1mYwsrii+c86Y9kKVV7M7ZASZWXK7rvskf7M2lD2fWgbXLw==
X-Received: by 2002:a1c:4c13:: with SMTP id z19mr10087258wmf.121.1602198348995;
        Thu, 08 Oct 2020 16:05:48 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id j101sm10006355wrj.9.2020.10.08.16.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 16:05:48 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 01/10] iov_iter: Skip copy in
 memcpy_to_page if src==dst
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-2-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <3820c19e-0fea-9345-0e0e-692119f7aa84@grimberg.me>
Date:   Thu, 8 Oct 2020 16:05:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930162010.21610-2-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You probably want Al to have a look at this..
