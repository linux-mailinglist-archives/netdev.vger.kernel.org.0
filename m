Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB66F2A69FF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbgKDQjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:39:20 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:49492 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgKDQjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 11:39:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604507959; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=9g6+PXG13MEnsnoHHUbWgt0A55tQ4uzH4x5CgIksaFs=; b=RRiSJd0oicBBHz7qAKY73lEzCr8sICv2MGxEasplrgYc8TEZDIxL4JZumWRc13KzExMPmwFB
 +O3Bd+R+QbPeoAuVIImx6ggaSzcDldNuKP8X5jcp02VTJYWUEx/vS71GZp4GVNnd9LYmNjZx
 +mxsqnaLqr7xf01EU+Vo7ZbFyNA=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fa2d92567cc51536a262063 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 04 Nov 2020 16:39:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BA601C433C9; Wed,  4 Nov 2020 16:39:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F387C433C8;
        Wed,  4 Nov 2020 16:38:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5F387C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Allen Pais <apais@linux.microsoft.com>
Cc:     Allen Pais <allen.lkml@gmail.com>, ryder.lee@mediatek.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi83@gmail.com,
        kuba@kernel.org, davem@davemloft.net, nbd@nbd.name
Subject: Re: [PATCH v2 0/3] wireless: convert tasklets to use new
References: <20201007103309.363737-1-allen.lkml@gmail.com>
        <c3d71677-a428-f215-2ba8-4dd277a69fb6@linux.microsoft.com>
Date:   Wed, 04 Nov 2020 18:38:56 +0200
In-Reply-To: <c3d71677-a428-f215-2ba8-4dd277a69fb6@linux.microsoft.com> (Allen
        Pais's message of "Tue, 3 Nov 2020 13:05:23 +0530")
Message-ID: <87blgdqdpb.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allen Pais <apais@linux.microsoft.com> writes:

>>
>> This series converts the remaining drivers to use new
>> tasklet_setup() API.
>>
>> The patches are based on wireless-drivers-next (c2568c8c9e63)
>
>  Is this series queue? I haven't seen any email. This is the last
> series as part of the tasklet conversion effort.

They are queued in linux-wireless patchwork, see the link below. I have
lots of patches pending but hopefully I'll tackle most of them soon.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
