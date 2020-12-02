Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3382CC540
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389510AbgLBSdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:33:19 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:10564 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389482AbgLBSdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:33:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606933973; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=oNng2v4v/VBaxZEkwCSCr4PYBI1vpA7tqU3kYllfEqI=;
 b=pXnF17xidyReU0prYSWX+2tCUVz60fejA/nBRnuDdHzfl6i3n/DsALA7M49kWlKm00BaPO2R
 cEyjhwz5aZb6Gg09qv0fQ9N0pnhS67dZzQZaNQtCaLG4XMz4jPTHZCY0Ghb9snU7retRDDA7
 G7ULu4OrdIWS04uWLZNB/aFWz+M=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fc7ddd5265512b1b279b555 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 18:32:53
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 50411C433C6; Wed,  2 Dec 2020 18:32:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EDFEFC43460;
        Wed,  2 Dec 2020 18:32:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EDFEFC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 2/2] ath10k: Constify static qmi structs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201122234031.33432-3-rikard.falkeborn@gmail.com>
References: <20201122234031.33432-3-rikard.falkeborn@gmail.com>
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201202183253.50411C433C6@smtp.codeaurora.org>
Date:   Wed,  2 Dec 2020 18:32:53 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rikard Falkeborn <rikard.falkeborn@gmail.com> wrote:

> qmi_msg_handler[] and ath10k_qmi_ops are only used as input arguments
> to qmi_handle_init() which accepts const pointers to both qmi_ops and
> qmi_msg_handler. Make them const to allow the compiler to put them in
> read-only memory.
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

ad37a46e8cb5 ath10k: Constify static qmi structs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201122234031.33432-3-rikard.falkeborn@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

