Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0083287E5B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgJHV4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:56:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37923 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJHV4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:56:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id n18so8197285wrs.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=M9rBEMSv2ZjvB7gx6UR84UveSp27URa2Fewhi2ZeZqrZJ/RBh4zs8+f4i3DZgW4Fhl
         +UjnOfwkJBddTvon2Nfygx2qpJBCHkHZaw0bmsH4jiv7SOuW/ozGqCvVpD2kYLKZtwRP
         gQoBqIgf4D/eIs4SKnFZxAqSzXwPPitwxdQitcCYM7JRzmO87kuLyAyYVrhdghiqK3Zn
         ZNF2ayCyTL1uQpNaBxMi6EA1OVkSWApQYL3q3bBhXzlDOtLX0npBz+gmuNMvq9OG8kDl
         y0hlUaoBf2rz5TfDsVkA8stTVw/TJUgZNozsXMQ694ilNYA3MLoD4+SUBgbU4FITLKh/
         yzpg==
X-Gm-Message-State: AOAM5317cIAVPE5n6qq/ZUz02VpwACorSQtQI7hv4uOQb3PMKYo4FpmP
        W+dY6kB5kH24jhIJHtiAXLk+57b4l6o=
X-Google-Smtp-Source: ABdhPJxV23Xx1Sw0KsKJOJQcfKGm5MeAAZ3Hw9JrRC+P7TtyrfjTw36NwoAFLqaVC2u426ijeIiB5w==
X-Received: by 2002:adf:fd47:: with SMTP id h7mr5539700wrs.245.1602194200500;
        Thu, 08 Oct 2020 14:56:40 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id q10sm9166602wrp.83.2020.10.08.14.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 14:56:40 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 04/10] net/tls: expose get_netdev_for_sock
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-5-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <c7f5fa38-7629-1bd6-63eb-c463daae0ef9@grimberg.me>
Date:   Thu, 8 Oct 2020 14:56:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930162010.21610-5-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
