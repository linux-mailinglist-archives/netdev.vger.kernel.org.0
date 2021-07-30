Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3E43DB4BD
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237977AbhG3HzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:55:05 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31201 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237886AbhG3HzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 03:55:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627631700; h=Content-Type: MIME-Version: Message-ID: Date:
 References: In-Reply-To: Subject: Cc: To: From: Sender;
 bh=OBKYoTKsmSrm6ziAPZqraNbNVhRFMPPbFTILQJX3yXk=; b=r2eiFImEXZGfAozU3Wl1hbWKONQHryGXWmhuJ+XU4VTCDIV1CMNCntloXTubQIkb8JvTdAn1
 Bj9dzKrCwiaRGe6X3N+UnTApoOL65lQpeDbvxhRpsBXDU7mQlXZSprVFy1wRT/TArLBc1kst
 6kLI3edRGaDQESRIc5iB5Fw8OoU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6103b03438fa9bfe9c3cdb2a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 30 Jul 2021 07:54:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3E509C4338A; Fri, 30 Jul 2021 07:54:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E0F2C433F1;
        Fri, 30 Jul 2021 07:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E0F2C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtl8xxxu: Fix the handling of TX A-MPDU aggregation
In-Reply-To: <CABTNMG0KurxtzXfExS-OE-UopoimCzbJTLj5q7a2_6HU8u0k0A@mail.gmail.com>
        (Chris Chiu's message of "Fri, 30 Jul 2021 11:25:31 +0800")
References: <20210630160151.28227-1-chris.chiu@canonical.com>
        <CABTNMG1FJYP4O021mWgVU0ZJZJmBTvm-x3sM0_dHCfa0LbOYDA@mail.gmail.com>
        <CABTNMG0KurxtzXfExS-OE-UopoimCzbJTLj5q7a2_6HU8u0k0A@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 30 Jul 2021 10:54:19 +0300
Message-ID: <877dh8fd90.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chris.chiu@canonical.com> writes:

> Any comments for this patch? Thanks 

Please don't send HTML mails, our lists drop those.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
