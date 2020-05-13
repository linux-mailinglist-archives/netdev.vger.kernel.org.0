Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7691D19FA
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgEMPzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:55:23 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:53555 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729539AbgEMPzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:55:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589385322; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=zqNr7VfmY3S8iKilXp9gzEx8lUCpq3JPYp1lZP9vKiA=;
 b=LTKp3maJVZ+CeqeQfuqJRuqZm+Nn/uTVkIjZ4M0ROkc754St89PoCdaMOxd+YmEaewxNXD8i
 D2EY0EkUSNCc/ZpvekAa4Agswgq8Ip500cf5nl1PGmT/EIbQcU8EBNBFurT/WpiILevajrpY
 8rIPUJ+x6bnuTaqXeszbTc33ScE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ebc185d.7fe0ab504b90-smtp-out-n04;
 Wed, 13 May 2020 15:55:09 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1740BC433F2; Wed, 13 May 2020 15:55:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0889C433F2;
        Wed, 13 May 2020 15:55:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0889C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] rtl8187: Remove unused variable
 rtl8225z2_tx_power_ofdm
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200513011754.28432-1-chentao107@huawei.com>
References: <20200513011754.28432-1-chentao107@huawei.com>
To:     ChenTao <chentao107@huawei.com>
Cc:     <mark@fasheh.com>, <herton@canonical.com>,
        <htl10@users.sourceforge.net>, <Larry.Finger@lwfinger.net>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chentao107@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200513155509.1740BC433F2@smtp.codeaurora.org>
Date:   Wed, 13 May 2020 15:55:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ChenTao <chentao107@huawei.com> wrote:

> Fix the following warning:
> 
> drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c:609:17: warning:
> ‘rtl8225z2_tx_power_ofdm’ defined but not used
>  static const u8 rtl8225z2_tx_power_ofdm[] = {
> 
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: ChenTao <chentao107@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

b6ba5761faad rtl8187: Remove unused variable rtl8225z2_tx_power_ofdm

-- 
https://patchwork.kernel.org/patch/11544493/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
