Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254033D25DE
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhGVNzy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Jul 2021 09:55:54 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36025 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhGVNzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:55:51 -0400
Received: from smtpclient.apple (p5b3d2eb8.dip0.t-ipconnect.de [91.61.46.184])
        by mail.holtmann.org (Postfix) with ESMTPSA id A46E1CECDD;
        Thu, 22 Jul 2021 16:36:24 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] bluetooth: btrsi: use non-kernel-doc comment for
 copyright
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210721020334.3129-1-rdunlap@infradead.org>
Date:   Thu, 22 Jul 2021 16:36:24 +0200
Cc:     open list <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BC3E0AE2-F6E7-43BE-8CEE-882722E0609F@holtmann.org>
References: <20210721020334.3129-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

> kernel-doc complains about a non-kernel-doc comment that uses "/**"
> to begin the comment, so change it to just "/*".
> 
> drivers/bluetooth/btrsi.c:2: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>    * Copyright (c) 2017 Redpine Signals Inc.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Aditya Srivastava <yashsri421@gmail.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Cc: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>
> Cc: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> ---
> drivers/bluetooth/btrsi.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

