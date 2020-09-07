Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F70A25F538
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgIGIaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:30:07 -0400
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:56484
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726971AbgIGIaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 04:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599467405;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=8o5pkbbwRSOnppHz4VSCmTzwH503Kp85jZQlaDj4Y44=;
        b=KcbctPC1C/d1jToY6xUZyNu1rt/NrQTO6WuESP1OETz5MsvTPLCli2axpyenYgb6
        zIvcYTfG0vXi866YoSvGqfGlFBY+WPL2ASNaGgty8kAVeF6qPQ0ncEg883RFjT6O6R9
        Iovfp+UfWCNWOre0WJ66bbe+cHuQfYqa1tjydxt8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599467405;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=8o5pkbbwRSOnppHz4VSCmTzwH503Kp85jZQlaDj4Y44=;
        b=IjLmgzULlvN26OpPRwi/Veyp3cho5f2k9/Q4JdBSz95rrniwV7F6+Lz7gOZAe/7I
        EKOmXvCkwZk6wxBEGkBcKca79SuLmj2S5PmvTLOsGvPOpQfXIQZbutBVNXAviJBqGLH
        dvaiteMad3/yTlhq+O8ETDmZjG+CyQPbeQqrrNJU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 780D9C4345E
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] mt7601u: Use fallthrough pseudo-keyword
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200901173603.GA2701@embeddedor>
References: <20200901173603.GA2701@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-ID: <0101017467afbeb3-7ebdc2a5-2cf5-4b51-b524-6577c593ecc7-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 08:30:05 +0000
X-SES-Outgoing: 2020.09.07-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> fall-through markings when it is the case.
> 
> [1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

1808191dca82 mt7601u: Use fallthrough pseudo-keyword

-- 
https://patchwork.kernel.org/patch/11749303/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

