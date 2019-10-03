Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9027CC9815
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 08:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJCGIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 02:08:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40144 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfJCGIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 02:08:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2624B60ADE; Thu,  3 Oct 2019 06:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570082924;
        bh=uGREgluwGnQmyPQJNQ3hhcREMvX++/gCIiVR6ijCkh4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UoK7oynqzcHfBubtf5/kbzxj88xRSh4qGnyZkXLPNLggttNKHBtZdWX4T82yA5ovK
         rwveEearg7x8cMFmVigqgNb9COKUz371UukAETGsSRCajJpVFFQlgbBAi3X6j1Y1yy
         VMI9ncOTlQpxP/1XrgXsosAc6ihMVXxWPyxKq1lk=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC74F6115D;
        Thu,  3 Oct 2019 06:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570082923;
        bh=uGREgluwGnQmyPQJNQ3hhcREMvX++/gCIiVR6ijCkh4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mIOz8IySmOBokwgj2o6WhFomypKwpSZd08Qm3dnt1b36rl9s+nL8OgY7mvoj0iTLb
         xAkTnMkKhqlHz00x3Ynh3YOwzelvFaI3+9kSnPX2nwWwpYrSXAjnoeoGO1qjiRE7Ey
         I2gyuZil9f4JSwr1hgqDZNk5fKQSM/L//WUCgKyA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CC74F6115D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: remove input-polldev.h header
References: <20191002215052.GA116229@dtor-ws>
Date:   Thu, 03 Oct 2019 09:08:39 +0300
In-Reply-To: <20191002215052.GA116229@dtor-ws> (Dmitry Torokhov's message of
        "Wed, 2 Oct 2019 14:50:52 -0700")
Message-ID: <87bluy2wew.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> The driver does not use input subsystem so we do not need this header,
> and it is being removed, so stop pulling it in.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I'll queue this for v5.4.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
