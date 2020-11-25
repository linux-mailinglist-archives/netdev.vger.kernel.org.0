Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C200B2C38B5
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 06:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgKYFdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 00:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgKYFdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 00:33:45 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0564C0613D4;
        Tue, 24 Nov 2020 21:33:44 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id n129so950155iod.5;
        Tue, 24 Nov 2020 21:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=svoJVyCbm10G4yWjRR8mYumT4yNa6/H8Nu/0nS86H3A=;
        b=qZL4HVK4RRtaEmNnYWpTRT/lFgKyYyV+4Tv0cTuIdvY3lkACIMbhRyCoXkmJdCM4Aw
         4ky3mMY+bZu/Zy4hEplBZUSfB9oPDj+MFwGCfPj4/xLtEXjO268dYTmGOUKDI08bQlX+
         9KPVu+gi8vPNMs+zWS1Kbb/NVjiOiFCQ2G+m+ryLs24knzf0SRUBEVxdNloO6NyCYwI4
         g/V98NFzzcSxlnNT9RbC3ZAmfYIHearChMgXl/2qtj7p7GtrKElEy8Gy+cD3hUQUDPJC
         J1+0Eaj9skbtF2HsHnvab7v9a0pZ/WdWs72bzM9NYBDYun3OWHX/sJaQY8uaRtEUlSLq
         6E0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=svoJVyCbm10G4yWjRR8mYumT4yNa6/H8Nu/0nS86H3A=;
        b=Rz1n/cq2VNxj7SgS7j+ywrg7tqGUIRIkEtBHsniuEB9ns814tdJWS3yM44GazgRPxs
         NZqEvk0e335phIuZ8lOrpQahLsI2C1uhUk6Frg0BMp3I6QZdZd+jXRIM6ptnITS4zX/j
         mi5ZQUaegXdoeXjthCca5ex+/L28RYtT6NRq+o738Kcp4w7GcmsxAcEwpqgF1wVtXZmV
         PhS+OVOTROuU4hB0yK50awCOEA5k1+YCgqUYxyDEQBaOC85OH/7ZnTR3qsN+OxwqV7fq
         rNn6Pv1k89QxDqGDZri82HCYaLzpUe1d5RqElQoJPOvOkK+dGTXplHVxChz/C3Sb+1SX
         eQEg==
X-Gm-Message-State: AOAM532SijGkuvAxw0FQexPqfBwku0YbNuRAgb/KHMmm1CplQ7FS2jg3
        yGAg7bZrr7ter+0dGiD9U/0=
X-Google-Smtp-Source: ABdhPJyeyOVIaFL4rcp/HGdfBA7bX6d84r+ccgxYnYgmwzkpLD86d0uOkLuAaYRje2xBa51GSm6Vsg==
X-Received: by 2002:a5d:8986:: with SMTP id m6mr1465528iol.30.1606282424307;
        Tue, 24 Nov 2020 21:33:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:b920:c7b8:6a02:a6c0])
        by smtp.googlemail.com with ESMTPSA id w9sm565597ilq.43.2020.11.24.21.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 21:33:43 -0800 (PST)
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
To:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201117184954.GV917484@nvidia.com>
 <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
 <29c4d7854faaea6db33136a448a8d2f53d0cfd72.camel@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e6de69c-c979-1f22-067d-24342cfbff52@gmail.com>
Date:   Tue, 24 Nov 2020 22:33:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <29c4d7854faaea6db33136a448a8d2f53d0cfd72.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 10:57 PM, Saeed Mahameed wrote:
> 
> We are not slicing up any queues, from our HW and FW perspective SF ==
> VF literally, a full blown HW slice (Function), with isolated control
> and data plane of its own, this is very different from VMDq and more
> generic and secure. an SF device is exactly like a VF, doesn't steal or
> share any HW resources or control/data path with others. SF is
> basically SRIOV done right.

What does that mean with respect to mac filtering and ntuple rules?

Also, Tx is fairly easy to imagine, but how does hardware know how to
direct packets for the Rx path? As an example, consider 2 VMs or
containers with the same destination ip both using subfunction devices.
How does the nic know how to direct the ingress flows to the right
queues for the subfunction?


