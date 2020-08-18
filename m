Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A124850C
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgHRMra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:47:30 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:60070 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726651AbgHRMr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 08:47:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597754845; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=a6R/W9KIgN7qN5oZwCr+qCvDmiMJowTZkS8J5dJiKGI=;
 b=p9pnlgL/NAkFMzLJkiwV/APIi+0Do+D7Bjlc9LPqBiJ2cYrbcaeNKQ9+SyF0QwvG/luVAaMN
 idUC52PW1BPIc/r3IX7ci6ScxE0sc0qe647h2Cdc05VfHU1DX/oYaM96+dtSPCg8J8H5ZHcq
 GNy6/NIdvgC72tNkylF9DSF84t8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f3bcdd72f4952907dbeb60f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 Aug 2020 12:47:19
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6533FC4339C; Tue, 18 Aug 2020 12:47:19 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6F36EC433C6;
        Tue, 18 Aug 2020 12:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6F36EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] brcm80211: fix possible memleak in
 brcmf_proto_msgbuf_attach
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1595237765-66238-1-git-send-email-wangyufen@huawei.com>
References: <1595237765-66238-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brcm80211-dev-list@cypress.com>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <franky.lin@broadcom.com>, <wright.feng@cypress.com>,
        Wang Yufen <wangyufen@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200818124719.6533FC4339C@smtp.codeaurora.org>
Date:   Tue, 18 Aug 2020 12:47:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen <wangyufen@huawei.com> wrote:

> When brcmf_proto_msgbuf_attach fail and msgbuf->txflow_wq != NULL,
> we should destroy the workqueue.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

6c151410d5b5 brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

-- 
https://patchwork.kernel.org/patch/11673291/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

