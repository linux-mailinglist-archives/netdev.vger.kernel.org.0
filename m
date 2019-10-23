Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970B6E17FC
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404490AbfJWKbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:31:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36998 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404361AbfJWKbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:31:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0BFBD60930; Wed, 23 Oct 2019 10:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571826671;
        bh=A7PH/myWbf3inKtiwdNO1H56o0VQY99LFEVNO9VJcYI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=b+PMNTWdS5DOqqkGKvYp2t6oxZ/dXXyLkHo+IRWyH6WilDLax4HfBK98xeHRMFgtg
         cYk6tvk/ySvQaVsGZytvVz0+gqXcb3k8cbQjTSZ4sncD+2/4EvfpBZHgsZeDW838JR
         /vz1oSxkWXLwxAR4eNoBv5hyMlGCfmmTu4hNA9kE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7EFF460159;
        Wed, 23 Oct 2019 10:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571826670;
        bh=A7PH/myWbf3inKtiwdNO1H56o0VQY99LFEVNO9VJcYI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BdJTj+l9l+3+2vg6/W+RoAoS/4bkEnbl6+SPdTIPVduhbF/kVckJ5z3dpvZufKzZ/
         hjA9FNNQu2BA/aDtUDILqOJlfjrjyf2rjh8lYdvkeQhRcl8DwuHO0blNuT1I6CTF3M
         ygIHGL8X0YhJ6oUgfiPr5StwpPtoOJv/VA+DLaPE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7EFF460159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: Fix potential overflow on P2P code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191018114321.13131-1-labbott@redhat.com>
References: <20191018114321.13131-1-labbott@redhat.com>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Laura Abbott <labbott@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Waisman <nico@semmle.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191023103111.0BFBD60930@smtp.codeaurora.org>
Date:   Wed, 23 Oct 2019 10:31:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Laura Abbott <labbott@redhat.com> wrote:

> Nicolas Waisman noticed that even though noa_len is checked for
> a compatible length it's still possible to overrun the buffers
> of p2pinfo since there's no check on the upper bound of noa_num.
> Bound noa_num against P2P_MAX_NOA_NUM.
> 
> Reported-by: Nicolas Waisman <nico@semmle.com>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers.git, thanks.

8c55dedb795b rtlwifi: Fix potential overflow on P2P code

-- 
https://patchwork.kernel.org/patch/11198315/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

