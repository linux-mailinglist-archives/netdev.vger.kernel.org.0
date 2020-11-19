Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B992B8AA5
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 05:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgKSEfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 23:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgKSEfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 23:35:32 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C020C0613D4;
        Wed, 18 Nov 2020 20:35:32 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id j12so4597174iow.0;
        Wed, 18 Nov 2020 20:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cVsR2quJnsJh+AZ/fHBAqJdiKNZhmEryAkSy84ESfYE=;
        b=Hre9ljp4NcINEFWTL1obJ9nwSVt+2QmfWXrhYBjiDxuyG/0GZLHE5fAskDMUNf8J8p
         qhMYwhfuVNrNEtezZlam3GWan7R6fMBL0mSw418dyGVRfx2RTpziNDqOic4j9uAz6YCa
         /CkRmnuxfH7AbjZfUq0gaRaJRjbBqKXu6TUXKyGXw/2ilRezCTTSUKhh4jvpsw4vw7RH
         0pqJHVQC97R1Pme0TeAZZh9ynr64OHat9dKkVOuduV88H24ZWv0rsuBVDziJHbafSbpl
         blrxLTZrrfHcVgkqeWhErcylZRGNTE+Xk8YKc6Ez0IQanDrFIx26nkBkDRKoKVYhtPa/
         WhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cVsR2quJnsJh+AZ/fHBAqJdiKNZhmEryAkSy84ESfYE=;
        b=nH5KdTjaK/FWli4xOce5fAacs9XHUDhx57ollslefTg68r5Uu5D6ZQM5YLyO6cQHk4
         4Hy72XJ8LItl/An8ozCaG6pwEQytlU30WJrTiV+MyUmd/ucD3o+n9cRe1G0qy4wjnHnW
         j1Allg/H7Ml+G28d8J3bj4b/tspoA1/NrI4mFD3UyhqljBn+RMS86KBcPiDjz8u6xDMi
         0GZVq9WOsUhbHdZAQXq9CbzIT7c63qOJPCkmCSRGAf/hONzNDW7J3I5wnBOgot7Kq5YU
         x7QKkd3mSF60TQ51sRrJdW9HxoUF+sShO9sGd2+LGZsXBUmGv42BMciaQpuUrPYG8NSA
         tfJA==
X-Gm-Message-State: AOAM532ePTYJPvbnOAuc2cI8X+MvDzXi5TzIJzS5IwiKwI473Z5gSpYV
        PBkN/Qkza1QDVuRtosp6NJY=
X-Google-Smtp-Source: ABdhPJwP7VpEdnuTh8hKpo49Kt3NeFBD3eIapwfLtN/CcBYq0EF0iMII9IPw8g0SVLZh3UlrveskKA==
X-Received: by 2002:a02:cc84:: with SMTP id s4mr12498897jap.126.1605760531433;
        Wed, 18 Nov 2020 20:35:31 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:70e6:174c:7aed:1d19])
        by smtp.googlemail.com with ESMTPSA id d23sm17610408ill.56.2020.11.18.20.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 20:35:30 -0800 (PST)
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
To:     Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com>
Date:   Wed, 18 Nov 2020 21:35:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 7:14 PM, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
>> On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
>>
>>>> Just to refresh all our memory, we discussed and settled on the flow
>>>> in [2]; RFC [1] followed this discussion.
>>>>
>>>> vdpa tool of [3] can add one or more vdpa device(s) on top of already
>>>> spawned PF, VF, SF device.  
>>>
>>> Nack for the networking part of that. It'd basically be VMDq.  
>>
>> What are you NAK'ing? 
> 
> Spawning multiple netdevs from one device by slicing up its queues.

Why do you object to that? Slicing up h/w resources for virtual what
ever has been common practice for a long time.


