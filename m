Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC6F72E1E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfGXLtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:49:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfGXLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:49:09 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7B2AC60588; Wed, 24 Jul 2019 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968948;
        bh=42X7y5jJNRiCroR9vcblJwiwKYId8aMdP1NkVM2G/cM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JsE/PZjj9TT6KMcugkuWN6Nr8E417u6Fbi6WoOdVmjvjmukRM2UZAhsuNftLoS26X
         UJGwi4TxWK7YNaDJ7lJkmFT5nZ5GcOxrEYwbzdOuECTOYCiTlQ2XusKlS/WG7uhIxv
         jE5O/mROSYw+0E7ofq1IesYuYJLn6XL1AK6FHVz0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B27D26044E;
        Wed, 24 Jul 2019 11:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968946;
        bh=42X7y5jJNRiCroR9vcblJwiwKYId8aMdP1NkVM2G/cM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=V4goodYFjZUkBLLOfZJnbzqps9+Gv5bQrb3NHB0izq8zXvcrYQ8MPqzowV6xYho/V
         cz2lb44YHCgoXnIbwMHfGlea8l2lHRNzEaFCE4d937M/1m/qRZI7FTgqrC4xwB9M6H
         PjIqNclMdJdc4hCuz6afAyPAxPGwGZugbcd1JTFM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B27D26044E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: Add missing sentinel at end of if_usb.c fw_table
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190710133138.GA31901@ip-172-31-14-16>
References: <20190710133138.GA31901@ip-172-31-14-16>
To:     Kevin Easton <kevin@guarana.org>
Cc:     linux-wireless@vger.kernel.org, andreyknvl@google.com,
        davem@davemloft.net, libertas-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        syzbot <syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114908.7B2AC60588@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:49:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin Easton <kevin@guarana.org> wrote:

> This sentinel tells the firmware loading process when to stop.
> 
> Reported-and-tested-by: syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
> Signed-off-by: Kevin Easton <kevin@guarana.org>

Patch applied to wireless-drivers-next.git, thanks.

764f3f1ecffc libertas: Add missing sentinel at end of if_usb.c fw_table

-- 
https://patchwork.kernel.org/patch/11038493/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

