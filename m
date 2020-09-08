Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D12261EBF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbgIHTzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730626AbgIHPhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:37:36 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246C7C08E819
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:29:07 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so17246234ioj.7
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WZ151TnKrtt/rCr3mhU4JlGN1BohyYMDOe1EdD2fXaA=;
        b=XAeRGlg/v/rUn7RQzxRXqgeWQc3Qcg7haMs6ruGXlcqupqFSxhO+JvsKMdoeQ2bFZi
         cIWSLwX2bAil1mjf6E+ymsd3wtjdxMKaA7KFaW/uE2k1tbf3zrzY71FR+lZzx0DiMGB8
         V+LiOrhn+2/Hfzv1APJdX1ZmxlDMHJpz1a0zQw3v9McqUqhI+hT3d9lsdr31F6WKIU//
         kLnsc8y7BwjTLe5qFviABlU5ogM2i5c67XRACmf2B6NEeHHB2jljaa4m5mysegabZU1J
         7/mDY2Gy9i3xz2I/G323v7DPdB0MJTqD/qUgI9Yr98/rVFmOT5dE1yQbLsjAN2IT4cCa
         UcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WZ151TnKrtt/rCr3mhU4JlGN1BohyYMDOe1EdD2fXaA=;
        b=iob8BGj/xAZCP1k85/3ApxP4hru1OwLsj3Y4OWXj/w8rnlJqZpyhLJGEqnQ1HQZlWD
         f7GpAh5oIWJ1JLr8htGG7LXZ2/qmJz6dApc77At4x55STLcE345lEcJ/bFSuwUECReBk
         za2BDrRptETuI1InHMhnN6GZ2cz1Y+TpaeLXqU4w4F4G1Ac8ORVGMLEtVMN1OalRgL+S
         GUxGCN6MN/v0xq2a4UWRQYbhE0/NCYzjDlVRcL5zAQDs7MrsTTFLx6PvuibBk2w8YNyJ
         UXLJ8i9DcTdrnavQ6j0Y43ORdrOYAAX18RqfavQ4htdLoriYm50t51XRDIXjVoTjRbLz
         GKCw==
X-Gm-Message-State: AOAM533CGXe1vJ7a8hQeovVVSghp2L4pibKej0fopu4qzrTAWROE6v83
        FAxdmy8FrMSVLdo9RPfXbDI=
X-Google-Smtp-Source: ABdhPJxviAh8ljedNip5OjJtbvsgVd5JE9nlJuW4TL3HWFph1MxNZLo7akYF1TPs5/oKWgGCiz22Yg==
X-Received: by 2002:a05:6638:611:: with SMTP id g17mr24104981jar.40.1599575346499;
        Tue, 08 Sep 2020 07:29:06 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id i144sm8510617ioa.55.2020.09.08.07.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:29:05 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 01/22] nexthop: Remove unused function
 declaration from header file
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5d8fefc9-0b33-3f72-5bc2-796dbd2b2431@gmail.com>
Date:   Tue, 8 Sep 2020 08:29:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Not used or implemented anywhere.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/nexthop.h | 3 ---
>  1 file changed, 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


