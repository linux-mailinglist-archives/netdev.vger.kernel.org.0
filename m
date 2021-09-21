Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D0B4135E2
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhIUPLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:11:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:28201 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233895AbhIUPLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 11:11:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632237009; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=RE3NuWcxFmHpZ009ctLHnSwnb6JLqP07uvXyBMNf1CM=;
 b=fmWZwzu65NNlZqFQr6kLsgxE5X2U/cIZQBb+VwWqoS2x8zmExY7WLG9AU7ydLAcwDiVwhryV
 zfg1eLMNpj0bTjwt0MojYuHoQu4Q3HWI7c6s3fCyxOZH4UPv/j4iDVWjJC2oBgeY9Z3WAIrB
 TYm5Ts3kBtXpAlQj8Oy/u4SgH5c=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6149f5caec62f57c9a238233 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 15:10:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B84E3C43616; Tue, 21 Sep 2021 15:10:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B0D24C4338F;
        Tue, 21 Sep 2021 15:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B0D24C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] zd1211rw: remove duplicate USB device ID
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210917092108.19497-1-krzysztof.kozlowski@canonical.com>
References: <20210917092108.19497-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210921151001.B84E3C43616@smtp.codeaurora.org>
Date:   Tue, 21 Sep 2021 15:10:01 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:

> The device 0x07b8,0x6001 is already on the list as zd1211 chip. Wiki
> https://wireless.wiki.kernel.org/en/users/Drivers/zd1211rw/devices
> confirms it is also zd1211, not the zd1211b.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

3 patches applied to wireless-drivers-next.git, thanks.

e142bd910f53 zd1211rw: remove duplicate USB device ID
b7cca318d7ca ar5512: remove duplicate USB device ID
60fe1f8dcd3c rt2x00: remove duplicate USB device ID

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210917092108.19497-1-krzysztof.kozlowski@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

