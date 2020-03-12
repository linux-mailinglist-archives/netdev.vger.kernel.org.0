Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98446183823
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgCLSCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:02:35 -0400
Received: from forward500o.mail.yandex.net ([37.140.190.195]:47183 "EHLO
        forward500o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbgCLSCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:02:35 -0400
Received: from mxback15g.mail.yandex.net (mxback15g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:94])
        by forward500o.mail.yandex.net (Yandex) with ESMTP id F070D6051E
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 21:02:33 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxback15g.mail.yandex.net (mxback/Yandex) with ESMTP id B66SFXcjlr-2Xk48k3n;
        Thu, 12 Mar 2020 21:02:33 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1584036153;
        bh=nHn9h0ZTRtAn0bVPH1NmoSiTeRm0+ucixzSD1Qh/6S0=;
        h=Message-Id:Subject:In-Reply-To:Date:References:To:From;
        b=VJwODc5W81+PZ3e7QAJAERct7HUre9TPZUJDhjMn9jIfOYXmn5GJ0sN+5Gr4q/5Kj
         h9W0qjSKufPsjr3a65bWBe7JSikS6OmPRxQtNn0H+g0nFlCwXWoOeBgls8t7Tztxn8
         QT3XcxFbgzJiEo6cBhc4GeUwkyxXS3IxoH9f/lZo=
Authentication-Results: mxback15g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt2-508c8f44300a.qloud-c.yandex.net with HTTP;
        Thu, 12 Mar 2020 21:02:33 +0300
From:   Aleksei Zakharov <zakharov.a.g@yandex.ru>
Envelope-From: zakharov-a-g@yandex.ru
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20200302115347.GA1530@yandex.ru>
References: <20200302115347.GA1530@yandex.ru>
Subject: Re: [PATCH] man: fix lnstat unresolved_discards description
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Thu, 12 Mar 2020 21:02:33 +0300
Message-Id: <1321584035715@vla5-ac90c725e5c1.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
Could this be submitted or am i missing something?
lnstat's unresolved_discards field description looks unclear, as for me.
And from the code it looks like it's a counter of dropped packets,
not table entries, unless i'm not mistaken.

02.03.2020, 14:54, "Aleksei Zakharov" <zakharov.a.g@yandex.ru>:
> Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
> ---
>  man/man8/lnstat.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/man/man8/lnstat.8 b/man/man8/lnstat.8
> index b98241bf..f25a9623 100644
> --- a/man/man8/lnstat.8
> +++ b/man/man8/lnstat.8
> @@ -121,7 +121,7 @@ How many forced garbage collection runs were executed. Happens when adding an
>  entry and the table is too full.
>  .sp
>  .B unresolved_discards
> -How many neighbor table entries were discarded due to lookup failure.
> +How many packets were discarded due to lookup failure and arp queue overfill.
>  .sp
>  .B table_fulls
>  Number of table overflows. Happens if table is full and forced GC run (see
> --
> 2.17.1

-- 
Regards,
Aleksei Zakharov

