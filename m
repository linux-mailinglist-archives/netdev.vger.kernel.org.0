Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED77CFE17
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfJHPt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:49:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfJHPt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:49:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9864F61110; Tue,  8 Oct 2019 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570549796;
        bh=h3VL4ZBPrnT897PQsUIyI6anbgxW0GUUyodhS8+7YPI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Tcez90tDP4y04s5zhd9xb/f7RNp45PgAY2zrZZadV5t8uHqw6bdvj8hC1ubpNsmbn
         75WCtv6mgh/+OFsV8WtSn09J2NHPh37SP5C9au694oMzqXLfQpVxfVIPiqpDfbP+tz
         YlHhU8UOLBJamY5k7aw61Fs6MgVkPekSXROK0wHk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D18D602DC;
        Tue,  8 Oct 2019 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570549796;
        bh=h3VL4ZBPrnT897PQsUIyI6anbgxW0GUUyodhS8+7YPI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lMOdN6k2Odv3QIiy+N47mS6ScNn1pjGxCRVK4qsM4t/vSnhr5ksNIJINqIkM0hZLv
         P2deuwTuv1fbdY0RCItnttszJPXeHhwr8zxLwDoB+NAqQWi2dPowepGt1TJQQOyNsp
         kelq4DekPrCjG4cKx2iVRTk2nV5djMDfNwQdIWuk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D18D602DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rt2x00: remove input-polldev.h header
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191002215052.GA116229@dtor-ws>
References: <20191002215052.GA116229@dtor-ws>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191008154956.9864F61110@smtp.codeaurora.org>
Date:   Tue,  8 Oct 2019 15:49:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> The driver does not use input subsystem so we do not need this header,
> and it is being removed, so stop pulling it in.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Patch applied to wireless-drivers.git, thanks.

98d22b01f9f6 rt2x00: remove input-polldev.h header

-- 
https://patchwork.kernel.org/patch/11171877/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

