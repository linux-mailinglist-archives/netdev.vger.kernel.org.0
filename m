Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F07CCF69
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfJFIXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 04:23:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfJFIXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 04:23:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6995A60907; Sun,  6 Oct 2019 08:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570350194;
        bh=sWOp4hj2K3mnGFtivA3C/9TKLdym8WLDeEHuJcCi3CA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fgEGxilU7PZDSgh/iA1d/qyLSAkD53WQLaZY+TabRbvIoi3JHVngruJdw7QRDXQWE
         kZDYzJpcB/TZ2xAgnxdWirgkjB34RhpBFNvyN8RndeSxG4TnnwRkl8Q3An+kXzmxJA
         nnCcd3/qF0YypaZNKEMjCFRu+l8ndqyxQslzT+Yc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (37-33-18-250.bb.dnainternet.fi [37.33.18.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4553F601E7;
        Sun,  6 Oct 2019 08:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570350194;
        bh=sWOp4hj2K3mnGFtivA3C/9TKLdym8WLDeEHuJcCi3CA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fgEGxilU7PZDSgh/iA1d/qyLSAkD53WQLaZY+TabRbvIoi3JHVngruJdw7QRDXQWE
         kZDYzJpcB/TZ2xAgnxdWirgkjB34RhpBFNvyN8RndeSxG4TnnwRkl8Q3An+kXzmxJA
         nnCcd3/qF0YypaZNKEMjCFRu+l8ndqyxQslzT+Yc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4553F601E7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH 1/2] Revert "rsi: fix potential null dereference in rsi_probe()"
References: <20191004144422.13003-1-johan@kernel.org>
Date:   Sun, 06 Oct 2019 11:23:10 +0300
In-Reply-To: <20191004144422.13003-1-johan@kernel.org> (Johan Hovold's message
        of "Fri, 4 Oct 2019 16:44:21 +0200")
Message-ID: <87a7aes2oh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> This reverts commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0.
>
> USB core will never call a USB-driver probe function with a NULL
> device-id pointer.
>
> Reverting before removing the existing checks in order to document this
> and prevent the offending commit from being "autoselected" for stable.
>
> Signed-off-by: Johan Hovold <johan@kernel.org>

I'll queue these two to v5.4.

-- 
Kalle Valo
