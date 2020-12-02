Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272AE2CC6CD
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbgLBTio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:38:44 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:62312 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgLBTio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:38:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606937916; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=gnxvhxq0IsErSHIBkGSB2VThQNskx+qCESrEk9JokaQ=;
 b=xG8lo7akgSzEl+wnVruSezT7aSjG3/Zp/DGLwzjNCojcVHLOPz3GlIITTjvhJIscj+aMG59M
 hc/CjktMzqMt4G51ipzodf8iCjWCbS0Tof27oQf796/emtPxEVeo5/0XEqziHFi3XdVhq6Fj
 QGmPMcmYwpic6X1m0/ex8B0rlfg=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fc7ed15265512b1b2b401be (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 19:37:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BB21EC43468; Wed,  2 Dec 2020 19:37:56 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E8C6C43460;
        Wed,  2 Dec 2020 19:37:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E8C6C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] brcmfmac: expose firmware config files through modinfo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201124120018.31358-1-matthias.bgg@kernel.org>
References: <20201124120018.31358-1-matthias.bgg@kernel.org>
To:     matthias.bgg@kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, hdegoede@redhat.com,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Double Lo <double.lo@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Matthias Brugger <mbrugger@suse.com>, digetx@gmail.com,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Amar Shankar <amsr@cypress.com>, brcm80211-dev-list@cypress.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201202193756.BB21EC43468@smtp.codeaurora.org>
Date:   Wed,  2 Dec 2020 19:37:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

matthias.bgg@kernel.org wrote:

> From: Matthias Brugger <mbrugger@suse.com>
> 
> Apart from a firmware binary the chip needs a config file used by the
> FW. Add the config files to modinfo so that they can be read by
> userspace.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

75729e110e68 brcmfmac: expose firmware config files through modinfo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201124120018.31358-1-matthias.bgg@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

