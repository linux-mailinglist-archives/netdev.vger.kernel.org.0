Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7194272DC8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGXLjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:39:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41894 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfGXLjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:39:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A1A056021C; Wed, 24 Jul 2019 11:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968375;
        bh=ofgYBmGSUa5nhgpLRPQsiG2fQFZbyQOHphQJgkKsWzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=U5GPeLH3QHhWqZhwFEOorsu5kqNdfCt45XgSlD51/ypDZ08unp441lAEnqX977YQa
         OTp6LAEA6mSOculcl2W2tHgsGMHogpkSz7hZIWujyHR3E9HKu5kJ4+6H38K76iZTzL
         tbeju8WfQPzbc+n6EAXDuJNfNSbBMZYVZ+N/OHgE=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5B7066021C;
        Wed, 24 Jul 2019 11:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968374;
        bh=ofgYBmGSUa5nhgpLRPQsiG2fQFZbyQOHphQJgkKsWzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ocFHY2l9ASxrEVZKU6AhtBZpqSNWQ9Wk++XwCtu+42WAOtZFRaPvJHBTdSywlL0o5
         IJvDsCG3XI5Jm9LrTZDjiLzKzC+jut9gksRBcFnfEqS67VlB//JReTxBjvGQuEVO4M
         YsWr6dIPJY2rzblPlcH4cWn14BUIwNinq9v9iZWs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5B7066021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] marvell wireless: cleanup -- make error values consistent
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724095015.GA6592@amd>
References: <20190724095015.GA6592@amd>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxinming820@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724113935.A1A056021C@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:39:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> Surrounding code uses -ERRNO as a result, so don't pass plain -1.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>

The title prefix should be "mwifiex:", I'll fix that.

-- 
https://patchwork.kernel.org/patch/11056525/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

