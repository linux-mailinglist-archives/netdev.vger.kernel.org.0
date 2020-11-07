Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DBF2AA4B0
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgKGLfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:35:11 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:50969 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbgKGLfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:35:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604748910; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=tprYRfhJAGs+dRGMRvpWISe7Mh6nCJ9stashzLxk+jo=;
 b=jEL9xGwCj89MV+sD4lUz/vJ2i55Ni2nFK+JYQjRgg6Xv1Ob4PAAFSwIjvPkoiLNE5WatoHLM
 TJKwkHMETD6U3qIZK57XZekofMUEjCfWqglNx9nmv5BuQtMt0VnyEx0X7+Fkk6sHBATASrNZ
 kmGYEHE18cuSYNR05oCYS5x5GRs=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fa68662c6df09e2f220affc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:34:58
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A1CB0C43395; Sat,  7 Nov 2020 11:34:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 544D9C433C8;
        Sat,  7 Nov 2020 11:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 544D9C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wireless: remove unneeded break
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201020125841.26791-1-trix@redhat.com>
References: <20201020125841.26791-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, ath9k-devel@qca.qualcomm.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com, pkshih@realtek.com,
        lior2.cohen@intel.com, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, nathan.errera@intel.com,
        tova.mussai@intel.com, shaul.triebitz@intel.com, john@phrozen.org,
        Larry.Finger@lwfinger.net, christophe.jaillet@wanadoo.fr,
        zhengbin13@huawei.com, yanaijie@huawei.com, gustavoars@kernel.org,
        saurav.girepunje@gmail.com, joe@perches.com,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107113456.A1CB0C43395@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 11:34:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> A break is not needed if it is preceded by a return
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

3287953b0399 wireless: remove unneeded break

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201020125841.26791-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

