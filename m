Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB21A6A18
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfICNjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:39:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50968 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfICNjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:39:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 955A7605A2; Tue,  3 Sep 2019 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517956;
        bh=lXs++/3yydA7yC4Q//rdvEKM9CLr5CMYHrSGb8D/kWQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Le+u1CI90neK1JZcG8D6nNa6UTo3qujD5UvgA9wef35h04AcF82JNaCaKpz1J8nzZ
         iWqje0MzY77DPcRlaYjzcWyPyUHkdj3f79/QaJUKfM69o77pWAe9N174GyruWj+vMg
         IvxIANulMQNjNdv2oeJTxK+x4bWzCkjBzRKrYP+M=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 797656025A;
        Tue,  3 Sep 2019 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567517956;
        bh=lXs++/3yydA7yC4Q//rdvEKM9CLr5CMYHrSGb8D/kWQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=P+il1b1ojRY8AM1WqEORW+/cXDd4Ui5tomcShZP1kdQmGYAuXXY3eO2f9K4dwV931
         W41t+tsU3K7a6/s2b95f+ts1siyWbTt2nEHR+gP7KfQ/WJQ4F6DPj/bIltz4ZR3XFP
         iwamevW3IA8PSu7fXMV+Gbve2Ycin76JMg7jG+ys=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 797656025A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCHv3] zd1211rw: remove false assertion from zd_mac_clear()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190813120412.6240-1-oneukum@suse.com>
References: <20190813120412.6240-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dsd@gentoo.org,
        kune@deine-taler.de, linux-wireless@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903133916.955A7605A2@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:39:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> wrote:

> The function is called before the lock which is asserted was ever used.
> Just remove it.
> 
> Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Patch applied to wireless-drivers-next.git, thanks.

7a2eb7367fde zd1211rw: remove false assertion from zd_mac_clear()

-- 
https://patchwork.kernel.org/patch/11092009/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

