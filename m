Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1BE83170
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731163AbfHFMfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:35:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfHFMfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:35:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EA78E6090E; Tue,  6 Aug 2019 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094950;
        bh=NZDwtrQI4U0ABkUADvCTivKQDmwAGr82qO/iVNbsfxM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PYsiIF5t9J5zaxrAV+TgXRtor9lk2/uVbTugLiXURIR3iAigZkSRPNOQ0Xhxrj1yF
         QK+BurzZ84xHDconNI4B3+NF898m/7IC/6/SXem27fgg2Bqbtx0BdB8mVpJ37EZwyQ
         TAm/qCFkaqTLGh6YnZUMqzOdhkriTFlNmR2ljxxY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB2B56090E;
        Tue,  6 Aug 2019 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094948;
        bh=NZDwtrQI4U0ABkUADvCTivKQDmwAGr82qO/iVNbsfxM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=XIRSpFrtyrkt1YScYWkoXYydse7nqZ+gBnOvX7Id2f9juOLnmFeFr/tzH1PURrJyQ
         p3Clla8U6EAAeFOq8YK1N/HjS6iejAMQJM2Nz1wFOufmZ+YJMHJHZWSPKXRcCwx5iD
         PUU5EDFETNy8UexZBeActnB04Gkl3dH1BbfnbWT0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB2B56090E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: null check the allocation
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724141736.29994-1-navid.emamdoost@gmail.com>
References: <20190724141736.29994-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123549.EA78E6090E@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:35:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> devm_kzalloc may fail and return NULL. So the null check is needed.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

b95c732234fa mt7601u: null check the allocation

-- 
https://patchwork.kernel.org/patch/11057013/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

