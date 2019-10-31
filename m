Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC3FEAB82
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfJaIW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:22:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:22:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0B9506079C; Thu, 31 Oct 2019 08:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572510148;
        bh=mK/qr+pAqWbeEa/KmON0Sjp6iPq1B+08/pCe+A/U6CA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PlKO4AqK0yMN53gxRGW+RAURQzuPA+dNLLoWXj5XhR+sh1Apg7jh1DoRkf5Ty1CHh
         pMs0grL20Tq85Xy8kCNfugyPmnOpjPE49cI6UwL9uM4UUEMw11qoez2zowIKeAMTP5
         moCV5leTHzgCJ3oFUpRnAGNEitRpCeHdqpIwxNjI=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B2B960610;
        Thu, 31 Oct 2019 08:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572510147;
        bh=mK/qr+pAqWbeEa/KmON0Sjp6iPq1B+08/pCe+A/U6CA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PZx0ylsPlDp3sasihMi1mWJg1XQlxgXL71a/fnnlefZs3YZODFfvEhHTjPYoJqDS7
         5L2D9/o2qYypoZ3FCV6O5Sc5OohwhI8wD2ybfPQGvEVcoIvoBw5J6hOx+w48odyu+D
         Vfh6XevjHLiVL9kKv9eMmrwOaHpc22bc9Aucz6gg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B2B960610
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath5k: eeprom.c: Remove unneeded variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191028192310.GA27452@saurav>
References: <20191028192310.GA27452@saurav>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@kernel.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031082228.0B9506079C@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:22:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> wrote:

> Remove unneeded ret variable from ath5k_eeprom_read_spur_chans()
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d77ef82c72ed ath5k: eeprom: Remove unneeded variable

-- 
https://patchwork.kernel.org/patch/11216311/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

