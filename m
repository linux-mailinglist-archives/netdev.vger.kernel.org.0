Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBA7BAF2C
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392155AbfIWIS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:18:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388933AbfIWISZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 04:18:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 60C7C613A3; Mon, 23 Sep 2019 08:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569226704;
        bh=hCFtq0Hduj+GSZ4QJISxD796u8FCyLei2WkNAVrpMZc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cBup4q5nlsK9uo5aOpuwogB2xActlTkOW7MafFpYxiexUjzHHk36AR3cPQU1/IXVJ
         C1N252F9b8tdeYv71+pTaZLmzhlVEQS8Zx19bcCS+REWXTnsr/Kga55WuEZ5P3Dy2D
         p7XDJmFbR+mg5MHkvOvo/Rx0L5ozyb1i2leGy3rw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8DC44613A3;
        Mon, 23 Sep 2019 08:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569226702;
        bh=hCFtq0Hduj+GSZ4QJISxD796u8FCyLei2WkNAVrpMZc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=fbuXb4R/xelTzedmuzN6takNHv6R6KN5wJ7grdno6N81GPaBNd3Wb5U7efETa3aJ4
         ZpzYJNvXC+Tp/X6l9ir8MEe0VGyw7yHGe8LQgM8073URl6of5Xg2KSz2SFeDWNFmNY
         gJfh/lxqWlIvbxcqmi+1/qSU+09ckXryWJx0bCYc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8DC44613A3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] net: ath: fix missing checks for bmi reads and writes
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190315051903.10664-1-kjlu@umn.edu>
References: <20190315051903.10664-1-kjlu@umn.edu>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     kjlu@umn.edu, pakki001@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190923081824.60C7C613A3@smtp.codeaurora.org>
Date:   Mon, 23 Sep 2019 08:18:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kangjie Lu <kjlu@umn.edu> wrote:

> ath10k_bmi_write32 and ath10k_bmi_read32 can fail. The fix
> checks their statuses to avoid potential undefined behaviors.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

8da96730331d ath10k: fix missing checks for bmi reads and writes

-- 
https://patchwork.kernel.org/patch/10854069/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

