Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE36CFE3A
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfJHP4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:56:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJHP4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:56:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1FDAF61A39; Tue,  8 Oct 2019 15:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570550205;
        bh=L02AIM1GDP5tyCdGCD4NsXNAC9LOxToRmZrIOu+Kfu4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eFBJapDyOcG98E4JlTFj2ucszzQQHNTzISpqVgQCvSJpzhbreSb5FZB/skJ51z9eT
         OgqexAsOczd0e7VLxkVvlC0sK59lXZVIoIIOxGkOXTvHc7POCE2Xf+ZDA7k0nIW2MS
         J9sneRvcCoOY/8a0XPcz3ANJgElFWmBLKo0KI+6Q=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C468960BE8;
        Tue,  8 Oct 2019 15:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570550203;
        bh=L02AIM1GDP5tyCdGCD4NsXNAC9LOxToRmZrIOu+Kfu4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=V6kEAXsMzJLpIptKk8+/llAq38z07bU9/OGHNCA/Rvm6CLOGq6N1LzXb+aZs+qKPp
         YlktqtQD136KHoY59UN4/9na7esCdnqwrUH/iLCIlnowRLH4w6RPf3YBRI3nhR5SnV
         VJxoO5O5ZsGJ4m/+aXNphrlMWM1zE3XgXI/Fza0A=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C468960BE8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH 1/2] Revert "rsi: fix potential null dereference in rsi_probe()"
References: <20191004144422.13003-1-johan@kernel.org>
        <87a7aes2oh.fsf@codeaurora.org>
Date:   Tue, 08 Oct 2019 18:56:37 +0300
In-Reply-To: <87a7aes2oh.fsf@codeaurora.org> (Kalle Valo's message of "Sun, 06
        Oct 2019 11:23:10 +0300")
Message-ID: <87pnj7grii.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Johan Hovold <johan@kernel.org> writes:
>
>> This reverts commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0.
>>
>> USB core will never call a USB-driver probe function with a NULL
>> device-id pointer.
>>
>> Reverting before removing the existing checks in order to document this
>> and prevent the offending commit from being "autoselected" for stable.
>>
>> Signed-off-by: Johan Hovold <johan@kernel.org>
>
> I'll queue these two to v5.4.

Actually I'll take that back. Commit f170d44bc4ec is in -next so I have
to also queue these to -next.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
