Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC85E4286C9
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhJKG05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:26:57 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:13885 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbhJKG0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 02:26:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633933490; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=h7IfVo+dSWcnAR0NKGiUy+LkFKcRh55dCDpcuLc57fY=;
 b=OVhA2JXMjBnMEouqd3mxQ1ZTbhscISBl8CYZh36j49oe0FFfrHdRjz12bokkvuKb5bPDK2QT
 MMpb1b45cbwphbzvpW/L//D79vyBCi86vWfcc3UhC9A5BlrDId9g3n5uie/Ubknz9xC1DTzw
 Mvl1g/92g/ifq+qd9PBotFVQLtE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6163d889f3e5b80f1f0f56eb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Oct 2021 06:24:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4F401C43460; Mon, 11 Oct 2021 06:24:09 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5D369C4338F;
        Mon, 11 Oct 2021 06:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5D369C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath11k: Remove redundant assignment to variable
 fw_size
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211006105529.1011239-1-colin.king@canonical.com>
References: <20211006105529.1011239-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163393344268.20318.10512441412282046693.kvalo@codeaurora.org>
Date:   Mon, 11 Oct 2021 06:24:09 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> Variable fw_size is being assigned a value that is never read and
> being re-assigned a new value in the next statement. The assignment
> is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 336e7b53c82f ("ath11k: clean up BDF download functions")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4f50bdfb4e5f ath11k: Remove redundant assignment to variable fw_size

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211006105529.1011239-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

