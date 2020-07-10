Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B85521BC18
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgGJRVt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jul 2020 13:21:49 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41325 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgGJRVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:21:49 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5FB0ECED26;
        Fri, 10 Jul 2020 19:31:44 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: BLUETOOTH SUBSYSTEM
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200708133638.14589-1-grandmaster@al2klimov.de>
Date:   Fri, 10 Jul 2020 19:21:46 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <330C715F-ADB9-42B7-93CF-7605F5E9A9D2@holtmann.org>
References: <20200708133638.14589-1-grandmaster@al2klimov.de>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>  If not .svg:
>    For each line:
>      If doesn't contain `\bxmlns\b`:
>        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>            If both the HTTP and HTTPS versions
>            return 200 OK and serve the same content:
>              Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
> Continuing my work started at 93431e0607e5.
> See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
> (Actually letting a shell for loop submit all this stuff for me.)
> 
> If there are any URLs to be removed completely or at least not HTTPSified:
> Just clearly say so and I'll *undo my change*.
> See also: https://lkml.org/lkml/2020/6/27/64
> 
> If there are any valid, but yet not changed URLs:
> See: https://lkml.org/lkml/2020/6/26/837
> 
> If you apply the patch, please let me know.
> 
> 
> net/bluetooth/Kconfig | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

