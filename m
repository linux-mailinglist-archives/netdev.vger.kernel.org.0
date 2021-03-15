Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBA233AD4B
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCOIXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:23:55 -0400
Received: from m42-2.mailgun.net ([69.72.42.2]:30285 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhCOIXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 04:23:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615796631; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=egW71XUo1KXjfG19RKKEjftCPONENS0wYUPLTYAUT6o=;
 b=M+Dug7OSpeVPwnhkdrQvWcCD9GHH6KU+2bqhMm6Ji3wabEqyM0FTSseGa2EPiX23pWDl4VKn
 x3IdrMPRQrpF6B+jZiPNvNj8hHZKbWuGJDx1eTQgD/afTdOAF0ByOJClU764dSrb70znuDSM
 8DWoChIvS+NWSnZzE7qyRdqiiQA=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 604f198d5d70193f885a1638 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 08:23:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF50BC433ED; Mon, 15 Mar 2021 08:23:41 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3250BC433C6;
        Mon, 15 Mar 2021 08:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3250BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw88: remove unnecessary variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210223075438.13676-1-samirweng1979@163.com>
References: <20210223075438.13676-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     tony0620emma@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        inux-kernel@vger.kernel.org, wengjianfeng <wengjianfeng@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210315082341.AF50BC433ED@smtp.codeaurora.org>
Date:   Mon, 15 Mar 2021 08:23:41 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samirweng1979 <samirweng1979@163.com> wrote:

> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> The variable ret is defined at the beginning and initialized
> to 0 until the function returns ret, and the variable ret is
> not reassigned.Therefore, we do not need to define the variable
> ret, just return 0 directly at the end of the function.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Patch applied to wireless-drivers-next.git, thanks.

4a7ea94377c9 rtw88: remove unnecessary variable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210223075438.13676-1-samirweng1979@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

