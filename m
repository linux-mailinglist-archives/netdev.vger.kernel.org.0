Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52F6E2A4D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 08:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437721AbfJXGTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 02:19:09 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:41746 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403986AbfJXGTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 02:19:09 -0400
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 229A060D3F2;
        Thu, 24 Oct 2019 08:19:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1571897946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2cgaBnYz4a1qGwNBwfPw34bFfBPfd3lSFyIheuElHw8=;
        b=a+kth0dQSGJ06qGmQi3wuwsnIvf3oGvwfZZBpAsRtonnY+BTfdRjUctnQbO5skefNMoLTa
        Vv3yip+Jl1EisyvkAKmZDNf2mi6fIbV2XyOYcnb6A815qZeMOYdZVZ4McA5CGGSAN827Je
        4cLdcB77cKe1/ffbzD3reFFM09FnEuQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Oct 2019 08:19:06 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org, nbd@nbd.name,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH wireless-drivers 0/2] fix mt76x2e hangs on U7612E
 mini-pcie
In-Reply-To: <cover.1571868221.git.lorenzo@kernel.org>
References: <cover.1571868221.git.lorenzo@kernel.org>
Message-ID: <be773efbf97ddc4c79956ff03136b62e@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

On 24.10.2019 00:23, Lorenzo Bianconi wrote:
> Various mt76x2e issues have been reported on U7612E mini-pcie card [1].
> On U7612E-H1 PCIE_ASPM causes continuous mcu hangs and instability and
> so patch 1/2 disable it by default.
> Moreover mt76 does not properly unmap dma buffers for non-linear skbs.
> This issue may result in hw hangs if the system relies on IOMMU.
> Patch 2/2 fix the problem properly unmapping data fragments on
> non-linear skbs.
> 
> [1]:
> https://lore.kernel.org/netdev/deaafa7a3e9ea2111ebb5106430849c6@natalenko.name/
> 
> Lorenzo Bianconi (2):
>   mt76: mt76x2e: disable pcie_aspm by default
>   mt76: dma: fix buffer unmap with non-linear skbs
> 
>  drivers/net/wireless/mediatek/mt76/dma.c      | 10 ++--
>  drivers/net/wireless/mediatek/mt76/mmio.c     | 47 +++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
>  .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
>  4 files changed, 57 insertions(+), 3 deletions(-)

Feel free to add my

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>

and thanks for the submission.

-- 
   Oleksandr Natalenko (post-factum)
