Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC688317D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbfHFMhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:37:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfHFMhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:37:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2BCC36074F; Tue,  6 Aug 2019 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095050;
        bh=ULaXsCHdpXk/9ASUvzQpHo0ujEuhZwPiBEwFY5gmZTU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Hj0VxOaQfOqhu+gcWbihujoKC/gFmJ996B9OUJ1iQqdPuLLGbT5gYwp5p6eXazk2U
         0ebAPqu3Znb0lT8koRhgUSmHofiy4Dyn42o/JGxtFHSLKisTUSb8eVMwQEE1sz/gT7
         bbtr27AdtV1kDwqbAn8icUag6pmzgCOCp+M/JWIc=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A2076038E;
        Tue,  6 Aug 2019 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095049;
        bh=ULaXsCHdpXk/9ASUvzQpHo0ujEuhZwPiBEwFY5gmZTU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=jfU8EUTyw7PKu2rzMrymC91mJ/Y6iH473HclG5PrZfOakeVzh0zaNwW7oqo3XZM0i
         W3Ah4Y4kUSRqIUM8IGoRgi1ppB6Jjldy3dQjuocmppedvHokWeQzC0Z6Usc7DFF7/5
         SSIIiFPoQEshZy7rLv8Akyttr/lWeD5U7TWArlH4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A2076038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: remove redundant assignment to err
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190726100614.6924-1-colin.king@canonical.com>
References: <20190726100614.6924-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123730.2BCC36074F@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:37:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable err is initialized to a value that is never read and it
> is re-assigned later.  The initialization is redundant and can
> be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

937a194ae865 ipw2x00: remove redundant assignment to err

-- 
https://patchwork.kernel.org/patch/11060715/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

