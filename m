Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE28AEB9B
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 15:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfIJNcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 09:32:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfIJNcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 09:32:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2DAE3602F2; Tue, 10 Sep 2019 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568122332;
        bh=vQPgNw5a7gU0FduUPKVc7pHyoB4RAkWfX8HhQ2BonBY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Kuy79+OsiVZi69+uo8aTQy6XYrve8opGsQxOGUI1M2SeGG9WJsxx1Hx/VrD/D7Ffg
         Mh/CAlGN8fig8/sky/UO88/xsgUnCi4yYq1IGQgvapB/748K7HIPyaH/VMlTn5vuWC
         qstsYV9bVyyq3iaidfihKzfP8ifCd+lqc7wQ7eFI=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 421EF602BC;
        Tue, 10 Sep 2019 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568122331;
        bh=vQPgNw5a7gU0FduUPKVc7pHyoB4RAkWfX8HhQ2BonBY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nYJ/FPZVw/skDA6fn9S/lZGMJvbw9+aRH3ncbVxul5PV/jnTLGL27uM82xIB8kQpj
         J2OLOTtObzZYslP9fEgyPC8JledNL/vcqSmFedf846VXmVKm7d9CYjcO0Je8Etd7/p
         lSFf9+kqCoTEYGOQlvEuVYIs+EJ/c00ZxM5H9v/Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 421EF602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: release allocated buffer if timed out
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190906185931.19288-1-navid.emamdoost@gmail.com>
References: <20190906185931.19288-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) emamd001@umn.edu,
        smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)emamd001@umn.edu
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190910133212.2DAE3602F2@smtp.codeaurora.org>
Date:   Tue, 10 Sep 2019 13:32:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In ath9k_wmi_cmd, the allocated network buffer needs to be released
> if timeout happens. Otherwise memory will be leaked.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

728c1e2a05e4 ath9k: release allocated buffer if timed out

-- 
https://patchwork.kernel.org/patch/11135843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

