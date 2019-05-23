Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D76278F1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbfEWJNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:13:01 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWJNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:13:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2CF0A6115D; Thu, 23 May 2019 09:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558602779;
        bh=q49ufyb9ebUPhOVN6fU/Ag5XosVSb82NqkFcV9WMg1g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NhRHzdli7hO9dpG0JuTGVJ5sZBrSNKcg61KCUErvrNhQV2IMJXAHtYTfViVJJy+bI
         +EsOlkTSQ98Db9SqfNsGqB5PkqoMzpdwmeMZ2xO4Ko39pAAST3DjXCcJfXIRG+gAKR
         YK6xxYrofSZtJGHB9jcO0b1le8q5z/njgBH2Aj+0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E085260D35;
        Thu, 23 May 2019 09:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558602776;
        bh=q49ufyb9ebUPhOVN6fU/Ag5XosVSb82NqkFcV9WMg1g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CgKKopkPDPqEZ3tYfF6IoD7K+SCnW4/001TN5YTTHqtDJdhbhqCiq7KveTA6ywt6p
         kPMgbLUY4GXZ8gEfh02FIp+aDZ92+sLDm7ADqmyQFAJ01kXqQ02XuiZ0E4UulnJwiQ
         gdNklgpRmkpK+mNNX5doQFDe8ZQzrgT+V4KAxFxc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E085260D35
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Weitao Hou <houweitaoo@gmail.com>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        royluo@google.com, davem@davemloft.net, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix typos in code comments
References: <20190519030923.18343-1-houweitaoo@gmail.com>
Date:   Thu, 23 May 2019 12:12:51 +0300
In-Reply-To: <20190519030923.18343-1-houweitaoo@gmail.com> (Weitao Hou's
        message of "Sun, 19 May 2019 11:09:23 +0800")
Message-ID: <87a7fdedpo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Weitao Hou <houweitaoo@gmail.com> writes:

> fix lenght to length
>
> Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 2 +-

Please use correct prefix "mt76:":

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
