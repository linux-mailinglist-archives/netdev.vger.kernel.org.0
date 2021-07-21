Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079123D12EB
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbhGUPOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239870AbhGUPOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:14:39 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADA2C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:55:15 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 70so2310348pgh.2
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AamAJMWACPXm/uhBeW58E0AsjcEWEr3w6J2GnzViHiA=;
        b=WB+2PJIakQlOTm9wjhPJzp8hB1utuhxsTJnRUMf3O02ShM1OHfun//a3DiSuax3Ula
         y4jLEgCZDspibyRcz8Th1U2MJ3praLixVFT3CM4gtQE/e5b8bl8hrd4KzY0JR5fbbiao
         0MwRgc2g4gI+XmaGHpSK/NPbd/JKN1h9ADnL5X+HCuWjgLqXeTAxs0KApxmL15Fb0+8H
         RvdwmFJ9C8EG3ArJTTI1w7+woXXHwzHhIF4f1pPVvft5JNmh8EcjR/4W1r+E/81yZ29j
         2+RkCgA+gGmn316uEu+XzZyUNU5pDxltDh7tiuBGz6IohNXsfw/RBhIkRmfnF1qCITCA
         k3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AamAJMWACPXm/uhBeW58E0AsjcEWEr3w6J2GnzViHiA=;
        b=N3YNDs/+FxxZ2OOv3yXh4gI0H5hnDDxL1isNJ+gP1M9e+U7FewbQphHx498Wion39i
         eJjm+QpfkGRx1nRNiVqOb23zJeMntdj7fVFde6MxkBrWL48qALJv7ikvbEgDdlRTzCH3
         HAOrCWkpWZWvKzuB/Rgt3nf4lf1rC2yqiBvUrhx4p3UiC1LsqG7tAruhKoLVkiojvjDv
         WCZOZK9N7sd5CCiTZWV2q/FXNhpq/C5102QbmzNnFVj0VaVXNcrq7zRMwJK9ySKCsDNd
         Ag3aTM7/UOQDuql00wdgLPvn+9F2EysJfK4v+8X4bawPBNV+nBsE4m0knrmP+tczx5N2
         HQfg==
X-Gm-Message-State: AOAM531oqpIzHnuoDWA0sTRQDb7xY0U4M9qC+lnxYtiVQ+2cnGm4FNns
        5RAQiPjdogka7+6iiTGRctO9lWBIpzzqxw==
X-Google-Smtp-Source: ABdhPJwwQM3wb9won1K+8GVee0NEZPozhbd2UA018Tfv3tLtslZhN2u+D9aYesjxL2UPAAfxTRbfNQ==
X-Received: by 2002:a63:ef57:: with SMTP id c23mr36356785pgk.60.1626882914844;
        Wed, 21 Jul 2021 08:55:14 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id r10sm26922902pff.7.2021.07.21.08.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 08:55:14 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: drop useless check of PCI driver data
 validity
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, drivers@pensando.io,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <93b5b93f83fae371e53069fc27975e59de493a3b.1626861128.git.leonro@nvidia.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <bb9c5fdc-491a-03f6-2f67-083e375b8fc2@pensando.io>
Date:   Wed, 21 Jul 2021 08:55:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <93b5b93f83fae371e53069fc27975e59de493a3b.1626861128.git.leonro@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/21 2:54 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> The driver core will call to .remove callback only if .probe succeeded
> and it will ensure that driver data has pointer to struct ionic.
>
> There is no need to check it again.
>
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Thanks,

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> index e4a5416adc80..505f605fa40b 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
> @@ -373,9 +373,6 @@ static void ionic_remove(struct pci_dev *pdev)
>   {
>   	struct ionic *ionic = pci_get_drvdata(pdev);
>   
> -	if (!ionic)
> -		return;
> -
>   	del_timer_sync(&ionic->watchdog_timer);
>   
>   	if (ionic->lif) {

