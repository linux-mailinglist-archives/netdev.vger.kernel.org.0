Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AB7441C7B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhKAOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:21:26 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:33662 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhKAOVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:21:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635776332; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qYmFgf5ucD4zcEhg7qIGyKjrg+6uL6LqCjm6lIDN7zI=;
 b=TmR44buvOwZ0qy8UwVzZWlVI/pCYlYRkgf9LEVJDUip0tSgxkoHX65Otcib2lJYQTiDtJczh
 NGPMQf1gELWDvd++FvPuiysnXJhzJq7kk/edgmGQrja1erKyyDwp2OQ1KiVcrlwxvfsrumHM
 HPtU2LICfHRqGTsEjiSw/cl3E/0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 617ff74baeb2390556240ea3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Nov 2021 14:18:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8DD07C43618; Mon,  1 Nov 2021 14:18:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B182CC4338F;
        Mon,  1 Nov 2021 14:18:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B182CC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] wcn36xx: add debug prints for sw_scan
 start/complete
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211027170306.555535-2-benl@squareup.com>
References: <20211027170306.555535-2-benl@squareup.com>
To:     Benjamin Li <benl@squareup.com>
Cc:     Joseph Gates <jgates@squareup.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163577632563.7461.17354156589296346576.kvalo@codeaurora.org>
Date:   Mon,  1 Nov 2021 14:18:51 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> wrote:

> Add some MAC debug prints for more easily demarcating a software scan
> when parsing logs.
> 
> Signed-off-by: Benjamin Li <benl@squareup.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

df008741dd62 wcn36xx: add debug prints for sw_scan start/complete
f02e1cc2a846 wcn36xx: implement flush op to speed up connected scan
8f1ba8b0ee26 wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211027170306.555535-2-benl@squareup.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

