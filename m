Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDF6488CBC
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiAIV5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:57:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54386 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiAIV5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:57:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3759B80E33
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 21:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F595C36AE3;
        Sun,  9 Jan 2022 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641765431;
        bh=bxEkkY/tH3OUF6VwT/s/tVA7Ya2ohE2GEO8USn/dIZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QA22J2XuVXNJn0/7z6TkJvSoziBGNwILejOLISyLsQIaNZhJ89wuzC8LWK8An+x93
         01VkT+g66SQJgyMCPh03L3CsvOCdZwSUukJvPD6Vc3XshPoby9cG6QeF9aafmi03/m
         jVZE3PngxVB2miIB/QHyt3zDeIXOFuziDkz55mqyB1Ov80kxvfh09BIipVQhKae594
         kQHCFgkW/5DjHPw0QpIWA/h5b8tnolqO4DK87CNoKOpJW/88bMeYiH7BSV2v79j94z
         XhZmi4MrecYD5gABGgq8NbFK//+SfvRY9ou/2oBA8M5HrsS4q65uyb1UIBFi5Z3Xxp
         o+jxUgF4Jfw1Q==
Date:   Sun, 9 Jan 2022 13:57:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 2/4] bnxt_en: improve VF error messages when PF
 is unavailable
Message-ID: <20220109135710.02c3ebf9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1641692328-11477-3-git-send-email-michael.chan@broadcom.com>
References: <1641692328-11477-1-git-send-email-michael.chan@broadcom.com>
        <1641692328-11477-3-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  8 Jan 2022 20:38:46 -0500 Michael Chan wrote:
> +	if (test_and_clear_bit(BNXT_STATE_L2_FILTER_RETRY, &bp->state))
> +		netdev_notice(bp->dev, "Retry of L2 filter configuration successful.\n");
> +
>  

double new line
