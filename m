Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4270072DBC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfGXLgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:36:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfGXLgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:36:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C7D7A60364; Wed, 24 Jul 2019 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968197;
        bh=Ufe3beDRc5autfXs2AmNn6jFacIvLtRr7SRHOZm8Ag8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=D9EZULmSRU90YlnGibDqA8ttXc7JVsQ0xuZRj83+wGQtJSB0iyqY3qGEJbXU2WaP2
         5GRz5PceSxFvsBkl2+gqDzs0y1nlLNPkbD0fcz/SeNnB3UAcaL9KA5+ZFZPU69Kpvp
         WwWuHMLgZsQBlUQvbgrpeDi75vghW/ziQdC/ghAg=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3BD8F60314;
        Wed, 24 Jul 2019 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968197;
        bh=Ufe3beDRc5autfXs2AmNn6jFacIvLtRr7SRHOZm8Ag8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Rm5x9vsrKKPGcWIWbm6e0iHhGfoJH2zUUF3pKrcj1M1uYsHUsYrwI7NFYj9/GQmlG
         fOFJlqR3QN6tTOCFlD8+qlRA7RYxLBvgdXDuDq0Hpe53aoRnEiX1zlQ66w/UiHYkqZ
         PDgsEy1ZSOgWlAmGAsQ6kWPfmxhmyqrZpOk9Sj8E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3BD8F60314
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] drivers: net: wireless: rsi: return explicit error values
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1561645802-1279-1-git-send-email-info@metux.net>
References: <1561645802-1279-1-git-send-email-info@metux.net>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        siva8118@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724113637.C7D7A60364@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:36:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Enrico Weigelt, metux IT consult" <info@metux.net> wrote:

> From: Enrico Weigelt <info@metux.net>
> 
> Explicitly return constants instead of variable (and rely on
> it to be explicitly initialized), if the value is supposed
> to be fixed anyways. Align it with the rest of the driver,
> which does it the same way.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

I'll fix the title prefix to only have "rsi:", no need to have the full
directory path there.

-- 
https://patchwork.kernel.org/patch/11019801/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

