Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5035842E688
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhJOCas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbhJOCaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 22:30:46 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61D1C061570;
        Thu, 14 Oct 2021 19:28:40 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id z69so2960956iof.9;
        Thu, 14 Oct 2021 19:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0e1HBUaxFCPBzntJ5MWjd68G9EfhVqfMZtQ+DomJjEA=;
        b=e4GK33cac0Le1WJlwnc9CKRV3wMTxI5PSb1dlek07/ZB8f3jX8DXT85rf82GqNkcEb
         kxUQVq14y6anaVVhdPN4KDTQ3YqYDfrs+M20ZdbOcNYv6bZhhqcHOxwBDFcMpP+gV7Iz
         1Ur6eCggMKtmMNWKjpKeaMsfdUn9L1VqLlFlD3QrxtfKKvIjUjI4P0voGhvy3j394x0L
         auPWsYXA0cuLLa65EhiwogOw79/7isigvVbErxB8d0qPen5ISw5eGY5x1tYrQaj+tFRw
         7VjsI7uoVsF5jQHowW1u/ywR2ahP0qyZ6W76q4us7IeX7Zb+ADI2zjkFKDdZfhgjbnaa
         koVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0e1HBUaxFCPBzntJ5MWjd68G9EfhVqfMZtQ+DomJjEA=;
        b=zJ3jDFHVpwC2wd8O/8QDKlrFKye3EnIZzRb4oz6dgAk+07ncwbejcdJrQHWXHsJFdA
         7eeYHJiKbWflf/AtaTxNodrkskIrisFwCRgVudWsjRASuZ7Aro8EwLm3ZUu0euwCsMsT
         2EjFVA6t7XvnAA3dZ0ArOpd2W3RtLjrVA9hdHNu11lKFmXIKqXo2W+BeZqG2wMuwyYCB
         OJ+YzYeK6iuObbys5K/KL6lXs2+4XoNh6bAODfrZIrzXOvlN1lcb1G+eS/Bew0DCQnRP
         Dnoon1gp1WHiUuc1HAeSwkOF5QgqdZ0RwAvACsxY0VYPxg48RCbs6Ryyrfr7PhsTkz6+
         NEIA==
X-Gm-Message-State: AOAM533dn5aqaoOIYh4ALMVWHGlegqyd8IsrK8zqAKGarDPVpug7fDA/
        On0FgAwES0UWIHCOOM39K1FEGLWOc8VFiA==
X-Google-Smtp-Source: ABdhPJyFOISKR4m77IrCK9xciAhkKbum3AmES3dO85GC4RGntG3lMoFxSblFfDxdvJwj0/QJ6s7pMw==
X-Received: by 2002:a5d:83c7:: with SMTP id u7mr1930837ior.80.1634264920427;
        Thu, 14 Oct 2021 19:28:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id p19sm2266191iov.3.2021.10.14.19.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 19:28:39 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 0/3] Optional counter statistics support
To:     Mark Zhang <markzhang@nvidia.com>, jgg@nvidia.com,
        dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        aharonl@nvidia.com, netao@nvidia.com, leonro@nvidia.com
References: <20211014075358.239708-1-markzhang@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <82b34add-ef1e-dc51-3a1c-5fd7777e59ed@gmail.com>
Date:   Thu, 14 Oct 2021 20:28:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211014075358.239708-1-markzhang@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 1:53 AM, Mark Zhang wrote:
> Change Log:
> v1:
>  * Add a new nldev command to get the counter status;
>  * Some cosmetic changes.
> v0: https://lore.kernel.org/all/20210922093038.141905-1-markzhang@nvidia.com/
> 
> ----------------------------------------------------------------------
> Hi,
> 
> This is supplementary part of kernel series [1], which provides an
> extension to the rdma statistics tool that allows to set or list
> optional counters dynamically, using netlink.
> 
> Thanks
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg106283.html
> 

this has been committed now?

