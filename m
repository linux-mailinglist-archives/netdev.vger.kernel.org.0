Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4536924338C
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 07:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgHMFQP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Aug 2020 01:16:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52770 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHMFQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 01:16:14 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1k65b1-0003Cx-MX; Thu, 13 Aug 2020 05:16:11 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0232B5FDD5; Wed, 12 Aug 2020 22:16:09 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id EF3449FB5C;
        Wed, 12 Aug 2020 22:16:09 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Nivedita Singhvi <nivedita.singhvi@canonical.com>
cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] docs: networking: bonding.rst resources section cleanup
In-reply-to: <20200813051005.6450-1-nivedita.singhvi@canonical.com>
References: <20200813051005.6450-1-nivedita.singhvi@canonical.com>
Comments: In-reply-to Nivedita Singhvi <nivedita.singhvi@canonical.com>
   message dated "Thu, 13 Aug 2020 10:40:05 +0530."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26964.1597295769.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 12 Aug 2020 22:16:09 -0700
Message-ID: <26965.1597295769@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nivedita Singhvi <nivedita.singhvi@canonical.com> wrote:

>Removed obsolete resources from bonding.rst doc:
>   - bonding-devel@lists.sourceforge.net hasn't been used since 2008
>   - admin interface is 404
>   - Donald Becker's domain/content no longer online
>
>Signed-off-by: Nivedita Singhvi <nivedita.singhvi@canonical.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
> Documentation/networking/bonding.rst | 18 ------------------
> 1 file changed, 18 deletions(-)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
>index 24168b0d16bd..adc314639085 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -2860,17 +2860,6 @@ version of the linux kernel, found on http://kernel.org
> The latest version of this document can be found in the latest kernel
> source (named Documentation/networking/bonding.rst).
> 
>-Discussions regarding the usage of the bonding driver take place on the
>-bonding-devel mailing list, hosted at sourceforge.net. If you have questions or
>-problems, post them to the list.  The list address is:
>-
>-bonding-devel@lists.sourceforge.net
>-
>-The administrative interface (to subscribe or unsubscribe) can
>-be found at:
>-
>-https://lists.sourceforge.net/lists/listinfo/bonding-devel
>-
> Discussions regarding the development of the bonding driver take place
> on the main Linux network mailing list, hosted at vger.kernel.org. The list
> address is:
>@@ -2881,10 +2870,3 @@ The administrative interface (to subscribe or unsubscribe) can
> be found at:
> 
> http://vger.kernel.org/vger-lists.html#netdev
>-
>-Donald Becker's Ethernet Drivers and diag programs may be found at :
>-
>- - http://web.archive.org/web/%2E/http://www.scyld.com/network/
>-
>-You will also find a lot of information regarding Ethernet, NWay, MII,
>-etc. at www.scyld.com.
>-- 
>2.17.1
>
