Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D653772DE2
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbfGXLm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:42:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfGXLm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:42:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E28B6030E; Wed, 24 Jul 2019 11:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968547;
        bh=Uj6bHH9J1QBhVoLHfDFia5OvNywCdSUTIRC08X6jefU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DX7bo1lZwNatRYRHjUO529lJ29AuBu/3NiLFe1JhzYY0P6LqymAiPZ5bCNET6Y5HD
         5kOt18cUO5fC+QEbHOxNaId/+zb/V0XDFFxLTYNBrR8xHA2NueeuVChIg+heiQcqtk
         l4t2YifZPJXuSrqLn2HTyk6T3IxCrEHoh8tA7JUs=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC6BE6030E;
        Wed, 24 Jul 2019 11:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968547;
        bh=Uj6bHH9J1QBhVoLHfDFia5OvNywCdSUTIRC08X6jefU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=aE0JQf/iJq3ixyzmik3CFhTROh2ewK3iUh9EZMoPzPfpK2neS6GPjZfrHftH2eAvr
         W3bq6hpuLa4pr23urhGwzOC5tRKsHdq+6hvqGFYd05IxEmEokoMI/o4pfFzUZ5d9Gl
         zHoSPFmqXnaxgqVNP/GLNWwt1MGHjZ2Bdq+3SySM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC6BE6030E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: return explicit error values
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1561645802-1279-1-git-send-email-info@metux.net>
References: <1561645802-1279-1-git-send-email-info@metux.net>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        siva8118@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114227.6E28B6030E@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:42:27 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

231e83fdcd03 rsi: return explicit error values

-- 
https://patchwork.kernel.org/patch/11019801/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

