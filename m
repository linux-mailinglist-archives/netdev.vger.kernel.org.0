Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656D24267F9
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239771AbhJHKfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:35:33 -0400
Received: from smtprelay0173.hostedemail.com ([216.40.44.173]:41382 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236118AbhJHKfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:35:32 -0400
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 82B7532071;
        Fri,  8 Oct 2021 10:33:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id 2CB9C20A29E;
        Fri,  8 Oct 2021 10:33:35 +0000 (UTC)
Message-ID: <34cc3eda06fa2e793c46b48ee734fd879e6f8ab1.camel@perches.com>
Subject: Re: [RESEND PATCH v2 2/7] nfc: nci: replace GPLv2 boilerplate with
 SPDX
From:   Joe Perches <joe@perches.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Fri, 08 Oct 2021 03:33:34 -0700
In-Reply-To: <20211007133021.32704-3-krzysztof.kozlowski@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
         <20211007133021.32704-3-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.10
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 2CB9C20A29E
X-Stat-Signature: an5cja49j9hatjzfj5y5i9dbqs1fshrj
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19rWGlJCAT2yUGU+WhaXGKE7yZZjxHmsvk=
X-HE-Tag: 1633689215-230328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-10-07 at 15:30 +0200, Krzysztof Kozlowski wrote:
> Replace standard GPLv2 only license text with SPDX tag.

Nak

This is actually licenced with GPL-2.0-or-later

> diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
[]
> @@ -1,20 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
[]
You may use, redistribute and/or modify this File in
> - * accordance with the terms and conditions of the License, a copy of which
> - * is available on the worldwide web at
> - * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

See the actual text at the old link which includes:

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.


