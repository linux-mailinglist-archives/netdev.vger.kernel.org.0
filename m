Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9B272DFB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfGXLoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:44:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfGXLoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:44:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3839860867; Wed, 24 Jul 2019 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968683;
        bh=WI7OaJbzQRsGararuSzJi7gI7JPxnUOnrorpDxfrFkE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KXCF/Bzhfi4lPF5yE4ZqI8iiO77/W3AIX+NujPjM2sX53hHq2z0iDttyyJ79cuA27
         t5r7TBhSN1Z+ciySeB5KiI2YaZER8e24N/O1m4CwRL/umPz0v4na8N4x6OZxY7oShT
         P7HK3pVgVAyk0Ti6esCyNUiy/XdKpEnF4NQZ/NyM=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 55CA3619C9;
        Wed, 24 Jul 2019 11:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968682;
        bh=WI7OaJbzQRsGararuSzJi7gI7JPxnUOnrorpDxfrFkE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XXAQBvA7djWIlFOdpwpGwntAYQCH9VxiZVn0L+L3A02K1o2DAPS8t51q8KMLiYrWg
         bcSSxBow0pa/rnqXLBiPdugF/kiBxKuttCAsa73Et45+WpMPCGGWm1wNIW1msoCLEn
         1xphQvUE4agBk28XEzTMPTImNy6rjlbgBUeCAOsU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 55CA3619C9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: remove redundant assignment to variable ret
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190705081734.15292-1-colin.king@canonical.com>
References: <20190705081734.15292-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114443.3839860867@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:44:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never
> read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

4c8a46851019 libertas: remove redundant assignment to variable ret

-- 
https://patchwork.kernel.org/patch/11032181/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

