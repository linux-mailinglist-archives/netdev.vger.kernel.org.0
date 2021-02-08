Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67E23130BC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhBHLYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:24:52 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:19933 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233131AbhBHLVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:21:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612783263; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=e8JVt610v7rkS0CWjmrki8Ua+zSTQvfnd2+Ays9O6sk=;
 b=Mo1E4cjI6RaLT8wiKQ3GV3GYsWKI1pln/+ZpXtTin0HTjLc5qlmdKALZMFZKFxJL46PtohJY
 2B0YUM/xF/ZbVQAis+E58nNJ7/wDeuEmUkqct18bhwytqqtt0tKnutWJgsoZ6Po0N/+l4CTx
 T/tELA5w2JuA9T8Fpj9OPOVYFEM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60211e7d830f898bac3c8c6d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 11:20:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B1E31C43467; Mon,  8 Feb 2021 11:20:29 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 72F37C433CA;
        Mon,  8 Feb 2021 11:20:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 72F37C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rt2x00: remove duplicate word and fix typo in comment
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210204005119.18060-1-samirweng1979@163.com>
References: <20210204005119.18060-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     stf_xl@wp.pl, rdunlap@infradead.org, helmut.schaa@googlemail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210208112029.B1E31C43467@smtp.codeaurora.org>
Date:   Mon,  8 Feb 2021 11:20:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

samirweng1979 <samirweng1979@163.com> wrote:

> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> remove duplicate word 'we' in comment
> change 'then' to 'than' in comment
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Patch applied to wireless-drivers-next.git, thanks.

cc1546d6850c rt2x00: remove duplicate word and fix typo in comment

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210204005119.18060-1-samirweng1979@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

