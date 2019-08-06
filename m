Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D42F83164
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfHFMeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:34:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHFMeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:34:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C73566074F; Tue,  6 Aug 2019 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094858;
        bh=QsaLFNEdiPZF/qEZPEqWyzvCOr9IQNtzwO8avKhniBI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=o8jDBbLtRw0fq7AsK0azoyjXhijlgh63gFsrMxMMePSTuDmYXXOXznfS+/Rg1iNMB
         j9t64s7AuK3iwaxjA7md7kjUKHGXUrTi/jMuFD4L38AlZldzbblqkW8pgFaIQCCPBs
         nvmgXnftIs3g5QQVggtOPUBUyMOarc1XaCvJgAEs=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A066D6019D;
        Tue,  6 Aug 2019 12:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094858;
        bh=QsaLFNEdiPZF/qEZPEqWyzvCOr9IQNtzwO8avKhniBI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Og22Blc46ZZCt0SVnSe9eglwgCTlx59VVLCi0qAkrDpyiIzuHNfW3LEkS4pHH1wQJ
         w7ERv3L0a0rM+1DOl9FXI3ntahJjf3jNhLgicw8t4vzyAC3Mxmvgr/RkRh7m+seVqF
         yQz7QOW9D7xAjTbdnX0xl+Tzk8JGK3F1pQidd4FM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A066D6019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next 06/10] iwlegacy: Use dev_get_drvdata where
 possible
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724112730.13403-1-hslester96@gmail.com>
References: <20190724112730.13403-1-hslester96@gmail.com>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Stanislaw Gruszka <sgruszka@redhat.com>
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123418.C73566074F@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:34:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuhong Yuan <hslester96@gmail.com> wrote:

> Instead of using to_pci_dev + pci_get_drvdata,
> use dev_get_drvdata to make code simpler.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

4 patches applied to wireless-drivers-next.git, thanks.

a40c28700d98 iwlegacy: Use dev_get_drvdata where possible
ffa4d78cbc26 mwifiex: pcie: Use dev_get_drvdata
1f5f5ea72fc9 qtnfmac_pcie: Use dev_get_drvdata
e7338e031985 rtlwifi: rtl_pci: Use dev_get_drvdata

-- 
https://patchwork.kernel.org/patch/11056621/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

