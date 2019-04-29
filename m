Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63489E529
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfD2Oqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 10:46:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36306 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbfD2Oqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 10:46:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D1D186028C; Mon, 29 Apr 2019 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549190;
        bh=TXlvK+53Z5f7AAMbyCS48iatA/iddrA8c1tdF+6cefU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=R0d7TFh+0WYBWSk9avXHa0LzZlLH0FBwZOzrJkUG2vaF1CryoF/PwOLtRLwuELCoH
         c2zxFEOPUrefK26fpfqQW7JpJGs9pOaiX5MKdy1Zjmh5ZwZBnFQMlOnXqDJs7QtEbG
         km/5qqvQzhZBE2JxWj40ijgnnQ4QZvAwXnVqg8zc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F8AB60134;
        Mon, 29 Apr 2019 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556549190;
        bh=TXlvK+53Z5f7AAMbyCS48iatA/iddrA8c1tdF+6cefU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=l6r95cqpXisbYCLJNfZkoe4mDjZdthulp9XKgShVCNuB2t4OQ6+nG8OXRU1YWFXlm
         yw53+DDxo4ROPWsUADA/ps6jau3v2UowG5n1XyJJAAshLUBOvK/9FEDh8Rl03EybyT
         xfHC1mBIXuzxbZn4mBYap/ZMs3aiIHvyg7MwhRoM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8F8AB60134
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] ath6kl: debug: Use struct_size() helper
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190403154835.GA20955@embeddedor>
References: <20190403154835.GA20955@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190429144630.D1D186028C@smtp.codeaurora.org>
Date:   Mon, 29 Apr 2019 14:46:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, change the following form:
> 
> sizeof(*tbl) + num_entries * sizeof(struct wmi_bss_roam_info)
> 
>  to :
> 
> struct_size(tbl, info, num_entries)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

df75786b9233 ath6kl: debug: Use struct_size() helper

-- 
https://patchwork.kernel.org/patch/10884039/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

