Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833E146E763
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhLILUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236469AbhLILUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 06:20:12 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7C2C0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 03:16:38 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso6283728wms.2
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 03:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pacGefIGW+G9AzlfvO9hZ+EiOedwRZitmNJe1fUz1LM=;
        b=tOWFCOG/3tWr1zE8FjwYlzlNW61hxVHpqWTkCS0NIRysMRS0kW/loMudB+2rQ9hzbL
         QVb1uMNGy383aC/D/00EDMLG8MHdfmWC0Fi0KNxtBM5BySxO7c6v2iiiobFXk0UkOzl4
         aRtPNjo/98cmWGactOeBXRgv/TbyapEQP+Xez2sT/9hX0QEPBtb3Y2UfLYIX6c72BsBT
         NKENRFIwjrsrsIk78NlKxxP1vEpCpQIJzZThlgwF4angzhhRrAOoanVp88M1up0AByY1
         kx2EiOJNF6dCyEXFwvfCA2qZb4/6v4KqNPlpcWvePfdJn5Hz2ggPgpaapcYMFnQBdZR8
         8aJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pacGefIGW+G9AzlfvO9hZ+EiOedwRZitmNJe1fUz1LM=;
        b=aV+nTEUQb95mJwLGBp/il4hgeDgfFJROvSmym6KkRoCawHgX5L4BbjnptV8nf3xuHK
         /4xn2kWwLJLoJ6jhNkQbbhKZUm6sFns8nYCnywNMmYGq7lryZ1pcDUd2WZAgE6pZxgaH
         rORHlI1sqHnCaTLxzEfskvuzwQtyqzM5oB2+8sswosQ103hpTlY3hMVvvqgoAq7U1pS4
         wRj5H+Efe5ftjil+exlMrsXt7zzjjLucifbXGG3FOqVRenmZKOjmuj2FD8rGE9FpbRsK
         1Pn/TKZljQcs96zcgAQhUXglLxsncoURNrQ8VSZQpT2wyFwyGvCqQzm1Dc+OHPrHNuhc
         7QEw==
X-Gm-Message-State: AOAM530T6mtmxoB3vmJNI+POeuifZ60ZPwIyrkWkr6PqFyBmUymacXEQ
        yIDRVPrY93W2JRIj+pObEdbvtw==
X-Google-Smtp-Source: ABdhPJwTtlqJdlIFGyNPRMwM91rfy2PxEuS77WcuyDEclHjvmqTCYz1aojS6Q1xvzdUFcAH9Ew6VLQ==
X-Received: by 2002:a05:600c:4fcd:: with SMTP id o13mr6125182wmq.175.1639048597526;
        Thu, 09 Dec 2021 03:16:37 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g5sm6742140wri.45.2021.12.09.03.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 03:16:37 -0800 (PST)
Date:   Thu, 9 Dec 2021 12:16:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shay Drory <shayd@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v4 4/7] devlink: Add new "event_eq_size" generic
 device param
Message-ID: <YbHllFKtzFNlRjZ6@nanopsycho>
References: <20211209100929.28115-1-shayd@nvidia.com>
 <20211209100929.28115-5-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209100929.28115-5-shayd@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 09, 2021 at 11:09:26AM CET, shayd@nvidia.com wrote:
>Add new device generic parameter to determine the size of the
>asynchronous control events EQ.
>
>For example, to reduce event EQ size to 64, execute:
>$ devlink dev param set pci/0000:06:00.0 \
>              name event_eq_size value 64 cmode driverinit
>$ devlink dev reload pci/0000:06:00.0
>
>Signed-off-by: Shay Drory <shayd@nvidia.com>
>Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
