Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CBB274EF6
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 04:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgIWCVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 22:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgIWCVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 22:21:07 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C13DC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 19:21:07 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id y5so17571110otg.5
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 19:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0YaUejpHR2wGA+ABo0HG1BDqDbyVDb6TKBpKQS549C4=;
        b=AB++5Ppa/SwILeN4WcxU4/hyaRyFhYOx8c1VstjJKgwMqOk4pEBTHpYmDXqzA4Onm7
         ckU0J52P0kOJ2LMspHQ65T4i+zmrocgxfi53xTONCX5zDbzOZk9bglmMhIZGXcKU5xA/
         F+JsVNAaCNcIUh1FxyBXoto7DxbiiGQI7DbphImOJBE3EO3lyg0EgfMloG9al5c3C1NU
         VylUBpAU4q3shLw59bdIG4rcVlQ+3LxOevPQcjsi0Dl9XFpEtAE3E3MmiKv5eHA4gsCb
         q5Dr45sBPRUmV/4u1+ZESmg6lT0KvD/JgjGAtQq1n5NFdpYWe9TAlilx849YkoTEJAZO
         aPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YaUejpHR2wGA+ABo0HG1BDqDbyVDb6TKBpKQS549C4=;
        b=jz5AIzKuk4qMCHH+PIE7INx5L4hy998sWGd0DbNcaUDSVWYQFPXgh01ViJPFyr3Hi6
         UwZrUAbVNXVzyr3B4YW9Xh2I3NqMAcrDZGDWHpXyG9C6aPcPrFIGLiOQ6P8c9+OK9MOo
         DuLk0sONH322+nJkuGUHctYQIMP/FyF67kXU6q3ha2O+Ux8RHNUwNlH5pE75DF4Ao6/T
         gXPI4QfMMNQVK1NBJurSEToTMGUzq3eEaySSOh0lB1n4qslB9OAIKNPwD2UCDLlJINTD
         LFic33gd2rLMWGrNDbBPy9rbNsRcfeDK0gytpu/qfMkt7CHsfgmpQyI1Mz7dknJ9kYzo
         6AHQ==
X-Gm-Message-State: AOAM530oY4GFywLnDT0im+74/uO/JhUciGNq4doBV8rTCUtetwFGqlHU
        VI5BTq581/d8kVIukylep4EgnpLJWRf0Vw==
X-Google-Smtp-Source: ABdhPJyTCfWVpwUGFbSbOLwdxcF1Kkew449eYofVEYsmje25gP4WBMD3kCx1SbnE1jqESGNVaZnl8w==
X-Received: by 2002:a9d:61d5:: with SMTP id h21mr4930033otk.187.1600827666851;
        Tue, 22 Sep 2020 19:21:06 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9c91:44fa:d629:96cc])
        by smtp.googlemail.com with ESMTPSA id p8sm8735656oot.29.2020.09.22.19.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 19:21:05 -0700 (PDT)
Subject: Re: [PATCH iproute2-next RESEND 0/3] devlink show controller and
 external info
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@kernel.org
References: <20200918080300.35132-1-parav@nvidia.com>
 <20200918101649.60086-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3855dfec-bd03-0965-4d70-a14268a5ed27@gmail.com>
Date:   Tue, 22 Sep 2020 20:21:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918101649.60086-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 4:16 AM, Parav Pandit wrote:
> For certain devlink port flavours controller number and optionally external attributes are reported by the kernel.
> 
> (a) controller number indicates that a given port belong to which local or external controller.
> (b) external port attribute indicates that if a given port is for external or local controller.
> 
> This short series shows this attributes to user.
> 
> Patch summary:
> Patch-1 updates the kernel header
> Patch-2 shows external attribute
> Patch-3 show controller number
> 
> Parav Pandit (3):
>   devlink: Update kernel headers
>   devlink: Show external port attribute
>   devlink: Show controller number of a devlink port
> 
>  devlink/devlink.c            | 9 +++++++++
>  include/uapi/linux/devlink.h | 4 ++++
>  2 files changed, 13 insertions(+)
> 

applied to iproute2-next

