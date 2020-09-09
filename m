Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFB72628B5
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIIHaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:30:08 -0400
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:50466
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbgIIHaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599636607;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=jXXUptAJfgSYS6ebgreurAMtuKrLbZ+qmG2W4SgenfY=;
        b=lZ1FxVvzi9GCgVr4H7oNnOLoyEjLDyu8WFBLOBVZhoUE+qTT76ZXt6DdNMxKFnIi
        Wiss+JiC81iwDRftN/kk6mGxqLjWON4XslmBRz9M44ey+et+30qycxxjJ3RobYMRyof
        Lze6y1HZLg8T4IxaVpDlDQMMkS+X8T/zkjMusA4c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599636607;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=jXXUptAJfgSYS6ebgreurAMtuKrLbZ+qmG2W4SgenfY=;
        b=ayM2Mw8V+V/AvbirjCvlRYTXXHbuADK90v0aI4Qoe1RQVXPMO+mhL2u/WF1YhI0x
        KjvBACLT1p7cpUZmeP7q8d6oqKqEaZO1eaZjqaUaxBdjCdmvWbBUqv/V0RCHc4Q0aqh
        A/eIFC4SuBiQSBc7DYlT0HpUmNjkdyd21RUWjkgc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A1D1C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: prevent potential memory leak
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200906040424.22022-1-chiu@endlessm.com>
References: <20200906040424.22022-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Chiu <chiu@endlessm.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017471c58fb6-37aeeb66-9a11-4846-b395-eae69f2b466c-000000@us-west-2.amazonses.com>
Date:   Wed, 9 Sep 2020 07:30:06 +0000
X-SES-Outgoing: 2020.09.09-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessm.com> wrote:

> Free the skb if usb_submit_urb fails on rx_urb. And free the urb
> no matter usb_submit_urb succeeds or not in rtl8xxxu_submit_int_urb.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>

Patch applied to wireless-drivers-next.git, thanks.

86279456a4d4 rtl8xxxu: prevent potential memory leak

-- 
https://patchwork.kernel.org/patch/11759447/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

