Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F7C12510E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLRSzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:55:20 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:53815 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727255AbfLRSzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:55:17 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576695316; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=H3k0TPYtr5f5YuIIb2+dV7Ko+XjaKzZP+uTzbyM4JSM=;
 b=JA8oD7ZzZzrZpCB3Iol5LVfhMQMHIb+QY45HvmEXyD+8nQpVGUUq3x2zZr+pqExzA8fknKXh
 71+aBgjwkmhtlSz6dEU43SzDqqquuKOTEfUUZjt57MeVi/Rc047wY478l57K0MFJ06D0IUDA
 niXKey9YNJZJXY0ZM702URWxAkA=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa7610.7f7a973f1308-smtp-out-n03;
 Wed, 18 Dec 2019 18:55:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 44265C447A2; Wed, 18 Dec 2019 18:55:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8BB57C433CB;
        Wed, 18 Dec 2019 18:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8BB57C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [Patch v2 1/4] b43legacy: Fix -Wcast-function-type
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191126175529.10909-2-tranmanphong@gmail.com>
References: <20191126175529.10909-2-tranmanphong@gmail.com>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     Larry.Finger@lwfinger.net, jakub.kicinski@netronome.com,
        tranmanphong@gmail.com, Wright.Feng@cypress.com,
        arend.vanspriel@broadcom.com, davem@davemloft.net,
        emmanuel.grumbach@intel.com, franky.lin@broadcom.com,
        johannes.berg@intel.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org,
        p.figiel@camlintechnologies.com,
        pieter-paul.giesberts@broadcom.com, pkshih@realtek.com,
        rafal@milecki.pl, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, yhchuang@realtek.com,
        yuehaibing@huawei.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218185512.44265C447A2@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 18:55:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phong Tran <tranmanphong@gmail.com> wrote:

> correct usage prototype of callback in tasklet_init().
> Report by https://github.com/KSPP/linux/issues/20
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

4 patches applied to wireless-drivers-next.git, thanks.

475eec112e42 b43legacy: Fix -Wcast-function-type
ebd77feb27e9 ipw2x00: Fix -Wcast-function-type
da5e57e8a6a3 iwlegacy: Fix -Wcast-function-type
cb775c88da5d rtlwifi: rtl_pci: Fix -Wcast-function-type

-- 
https://patchwork.kernel.org/patch/11262921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
