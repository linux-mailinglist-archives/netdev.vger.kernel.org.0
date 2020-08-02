Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04132357F1
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHBPLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:11:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:61589 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgHBPLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 11:11:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596381113; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=d3a5n4iRdThXJWDctbyZ9DWtTKYv5w4Rf8p1Jxgt3ac=;
 b=qFPwicu+uNWwsssoRCYUr3Ei2tqNmh4a1/6iJpCKc10ZPEdOgWevwJ6Yp0IBduICi22lpN0U
 7FcMLP23EqojK3DCpYTWz1w2UDPht+CK0WWrVZeCP4Ljnq74Jfkk3l88tK4uTcmhH0D2Q+t7
 wkZG4fAsy/zyEu7t4EzAtzJvGZA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5f26d7b9eecfc978d39a079c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 15:11:53
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D54C9C433C9; Sun,  2 Aug 2020 15:11:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3DBEC433C9;
        Sun,  2 Aug 2020 15:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C3DBEC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt7601u: add missing release on skb in
 mt7601u_mcu_msg_send
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200718052630.11032-1-navid.emamdoost@gmail.com>
References: <20200718052630.11032-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802151151.D54C9C433C9@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 15:11:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:

> In the implementation of mt7601u_mcu_msg_send(), skb is supposed to be
> consumed on all execution paths. Release skb before returning if
> test_bit() fails.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> Acked-by: Jakub Kicinski <kubakici@wp.pl>

Patch applied to wireless-drivers-next.git, thanks.

880e21490be6 mt7601u: add missing release on skb in mt7601u_mcu_msg_send

-- 
https://patchwork.kernel.org/patch/11671657/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

