Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51484287E58
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgJHVv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:51:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33566 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgJHVv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:51:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id m6so8187454wrn.0
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iJXlEB+Px1Bh29uSjjaKgu7whRXUx1wvZLQkXigqHdE=;
        b=Tzon2cCb+2N//mm6sqfJAx+D9VdeZf3E4CMTkstAAUkX6pdz6eEXBibbrUBo2oYo+v
         Z/IMseitcIk1SOz59EQW5PM1ewvUX7pI3bjIRq3i4h+ywJ+dY5vk0PxWzJaAsb+GJeRa
         LwBb6qw+eI9Fxw9pB67UBVSIWXzkXOJmIY3qgoV69h7tGd7l61Q0NUbFXoKIRVxwK2oJ
         DsexsTsmYOyzj3Qj46kQKkpTFCoOfLdNBKFT2lgTaaxJ/09bYsg6/rLuWVRuzT2job4j
         hljVTqIwIEzE/DUJckJyi8FtvoliyUSmc3PgeHC/2fVdaPM/Ozjq+Hyz/o18+2QMB04H
         efFw==
X-Gm-Message-State: AOAM530ynhhVfHJqQwvBALQWFZrzQDv+6oaltib5HBj8ehN3c5uUffzD
        UQ5rmZbUBGZbkuhtAcL5jPs=
X-Google-Smtp-Source: ABdhPJwJ7oTNHeMtK2UwxXqxI2a25TbVKjna+8whwhBksIwUGhMPofkX7Eg64tfJMI/ghTWDj9AlZg==
X-Received: by 2002:adf:d84e:: with SMTP id k14mr11803304wrl.251.1602193916816;
        Thu, 08 Oct 2020 14:51:56 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id z6sm3872809wrs.2.2020.10.08.14.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 14:51:56 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 03/10] net: Introduce crc offload for tcp
 ddp ulp
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-4-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <904a5edf-3f50-5f6f-6bc6-3d1a1a664aa5@grimberg.me>
Date:   Thu, 8 Oct 2020 14:51:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930162010.21610-4-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> This commit itroduces support for CRC offload to direct data placement
               introduces
> ULP on the receive side. Both DDP and CRC share a common API to
> initialize the offload for a TCP socket. But otherwise, both can
> be executed independently.

 From the API it not clear that the offload engine does crc32c, do you
see this extended to other crc types in the future?

Other than this the patch looks good to me,
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
