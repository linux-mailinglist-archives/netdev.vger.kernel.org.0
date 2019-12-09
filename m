Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09AB811682E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 09:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfLIIbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 03:31:03 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36946 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfLIIbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 03:31:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6351B20482;
        Mon,  9 Dec 2019 09:31:01 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Oj_Eo7elimUl; Mon,  9 Dec 2019 09:31:01 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0681520185;
        Mon,  9 Dec 2019 09:31:01 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Dec 2019
 09:31:00 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8CF193180AB8;
 Mon,  9 Dec 2019 09:31:00 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH stable v4.19 0/4] xfrm: Fixes for v4.19
Date:   Mon, 9 Dec 2019 09:30:41 +0100
Message-ID: <20191209083045.20657-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset has some fixes for the xfrm interfaces
that are needed but did not make it into the stable
tree so far.

1) Fix a memory leak when creating xfrm interfaces.

2) Fix a xfrm interface corruptinon on changelink.

3) Fix a list corruption when changing network namespaces.

4) Fix unregistation of the underying phydev, otherwise
   the phydev cannot be removed.
