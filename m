Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1BB3D888B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhG1HH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:07:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:57951 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhG1HH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:07:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627456075; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=RcOzkuQJajbXsCttSZMhnwTZaSzx9XzoFmVS1+N7np0=; b=uNRyw8+l/XnAOloZc2IuMBSrrGnNUt8TGwa3vfHvx6ZTuW+dYLBfCuTQiwdHDZwCN13eFQAC
 8qwibQ6bE7d0lsCatFXiL1lhWtWk4lI7EGDeaxifOoTBcGJyizjRja/RCzDwG7cGGY38atr8
 O/7tc14wOUQZ+72QmwCK/mPRvaU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6101023138fa9bfe9c37a55b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 28 Jul 2021 07:07:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 09F3FC43460; Wed, 28 Jul 2021 07:07:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CB4B5C433F1;
        Wed, 28 Jul 2021 07:07:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CB4B5C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, Jouni Malinen <j@w1.fi>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next v3 04/31] hostap: use ndo_siocdevprivate
References: <20210727134517.1384504-1-arnd@kernel.org>
        <20210727134517.1384504-5-arnd@kernel.org>
Date:   Wed, 28 Jul 2021 10:07:22 +0300
In-Reply-To: <20210727134517.1384504-5-arnd@kernel.org> (Arnd Bergmann's
        message of "Tue, 27 Jul 2021 15:44:50 +0200")
Message-ID: <8735ryhq6t.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding linux-wireless list)

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> hostap has a combination of iwpriv ioctls that do not work at
> all, and two SIOCDEVPRIVATE commands that work natively but
> lack a compat conversion handler.
>
> For the moment, move them over to the new ndo_siocdevprivate
> interface and return an error for compat mode.
>
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
