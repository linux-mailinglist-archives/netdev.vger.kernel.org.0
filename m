Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACD3CBC27
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388872AbfJDNrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:47:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388438AbfJDNrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 09:47:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D517619F4; Fri,  4 Oct 2019 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196856;
        bh=YTbkcIOSoT6sfkliDWftlO8oLXWgzNqKOEziTUyn0HU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jNOBjg77Md9jO1ArgJgRIulK23TEMZaqZ/JV6WLuLYPcAFqvLwYV/wrUhKsdbZa4+
         w5LGElS3knZUK4dg6HW4O6t6a/0zSuO2ftehftqW3qQTHvWkSwaLXZ9pn86g47c82J
         HQLKAoo1QS7TwMt4KXNd4OicHVBiI7ipjxfJor+Q=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28C4A6081C;
        Fri,  4 Oct 2019 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196855;
        bh=YTbkcIOSoT6sfkliDWftlO8oLXWgzNqKOEziTUyn0HU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ESd3wgaBuhMt7Vw0LAcQG80pZLg82sIGccWfnpkFvmJvHKErgvVz/Gwg7OXZMo5M+
         2QkIUoWqLvWjT5dvTYuD+71vcJusxAhvcD6cEp3WP/XQEpGC9Nr0KI1Jot1RNOuFy3
         7JvVAlt3hoq+UDbGBByU5Qq4YWhuDrZol0TMOWzM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28C4A6081C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: fix potential null dereference in rsi_probe()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191002171811.23993-1-efremov@linux.com>
References: <20191002171811.23993-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-wireless@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191004134736.2D517619F4@smtp.codeaurora.org>
Date:   Fri,  4 Oct 2019 13:47:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis Efremov <efremov@linux.com> wrote:

> The id pointer can be NULL in rsi_probe(). It is checked everywhere except
> for the else branch in the idProduct condition. The patch adds NULL check
> before the id dereference in the rsi_dbg() call.
> 
> Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Denis Efremov <efremov@linux.com>

Patch applied to wireless-drivers-next.git, thanks.

f170d44bc4ec rsi: fix potential null dereference in rsi_probe()

-- 
https://patchwork.kernel.org/patch/11171695/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

