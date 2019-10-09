Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204FBD0998
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbfJIIYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:24:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56998 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJIIYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:24:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7B18A61A81; Wed,  9 Oct 2019 08:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609445;
        bh=gk+Iu3xI3mpVS78D5WgnLWyU9HVaeDM2lRyYaVDJTak=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZmLP9UMQn8H42q9iRFGBKy9XCPOjknjcn7beaP7LxwUuuCLrVPHT0LypyGjkXh64w
         XfsSdFkzI6V+qYVNdr7RygMgluvYKAh0iHNFUlq0JYQYJW9v39kndlnGNMHfBZ1iix
         rgXdByohYBO3TLNeTdOVZKD7A5X+eTq6QfvzMDV8=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BEADE60AD1;
        Wed,  9 Oct 2019 08:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609444;
        bh=gk+Iu3xI3mpVS78D5WgnLWyU9HVaeDM2lRyYaVDJTak=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KNXveYciZj7X5Zel1mmXX5dfsFwHj2PDoaOwfT49Bo/zQXv2NHTwpaZsMpJMtfHuU
         Yj1XG6auay5q8enHbq/i4ZSMUy+NoAyaXuWo8Yf9QEnW06fFnqgMDh2IJA4PRmbrP6
         AOou5NilrSGAxXkVDsohp3W8z1ySzFP/ntkDTouo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BEADE60AD1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] Revert "rsi: fix potential null dereference in
 rsi_probe()"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191004144422.13003-1-johan@kernel.org>
References: <20191004144422.13003-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Johan Hovold <johan@kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082405.7B18A61A81@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:24:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> wrote:

> This reverts commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0.
> 
> USB core will never call a USB-driver probe function with a NULL
> device-id pointer.
> 
> Reverting before removing the existing checks in order to document this
> and prevent the offending commit from being "autoselected" for stable.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>

2 patches applied to wireless-drivers-next.git, thanks.

c5dcf8f0e850 Revert "rsi: fix potential null dereference in rsi_probe()"
39e50f5ce26c rsi: drop bogus device-id checks from probe

-- 
https://patchwork.kernel.org/patch/11174711/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

