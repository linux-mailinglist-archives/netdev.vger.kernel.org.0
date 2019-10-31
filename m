Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CDAEAB5E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJaIKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:10:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:10:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC67960927; Thu, 31 Oct 2019 08:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509453;
        bh=R9a6NR3iic6qgOQYqHn6WkolVQpxamcIauDJvCJETFM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Lcngf0gf9g3rjV5XH2/y+eg2nBUMtriTRHTdUi0IEW2fxOtvjoK1KhMRP3xbmixrN
         4incWqzdPw/KQwlXqWWzSIo+r7VQxG72neifdM7Y58mq3Da5O0PdE6QfyN86OG/zDs
         extaDTNJWtFf244PX0Ji6c30bNRCBPyEnyufweNo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8314360540;
        Thu, 31 Oct 2019 08:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509453;
        bh=R9a6NR3iic6qgOQYqHn6WkolVQpxamcIauDJvCJETFM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hRQQ+qSITwh1W+k4EdLFooP54FHyVM7qCdTNe4WZ7Oc7vo9YyyI5QSM8y7m49/wQX
         F17nPZ7P9oJl7D8iMCtMpKITmrDzAcAVuqiozxBcck85Hz5YxVAdn5UV1WGVdUfLvv
         IAhyNuMYVf8S5U9qJgl9m4JKUxAHg5bygNZzF2qk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8314360540
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs
 fops
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1572422924-58878-1-git-send-email-zhongjiang@huawei.com>
References: <1572422924-58878-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <kubakici@wp.pl>, <davem@davemloft.net>, <matthias.bgg@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031081053.DC67960927@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:10:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> It is more clear to use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs file
> operation rather than DEFINE_SIMPLE_ATTRIBUTE.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

086ddf860650 mt7601u: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs fops

-- 
https://patchwork.kernel.org/patch/11219173/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

