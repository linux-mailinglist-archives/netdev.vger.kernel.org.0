Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1955C204F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 14:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbfI3MEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 08:04:41 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:20030 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfI3MEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 08:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1569845075;
        s=strato-dkim-0002; d=pixelbox.red;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=YFs2nW85v53bCTBvhL2RV3+dwFi2cEslKs2w/Xp/G4k=;
        b=rFPp1PUOWM+kwJCNG0UzReeM/GgGko44wxVk3/rinAWEw1Rdz6B+GxTzdnvPkkpZTy
        w8kC7JUMilb6zwJf7gAlIFuiIflxQCx20SidjllDOCpapIutDl5afeKb1+xkiVP5wh1B
        Q1EHhcj/F5ykf4+sFawGEIhZHPR/ME90rrdy/EgoYOhsN4s969QJJOxg/G34IqcjDcJl
        MnSwWeLRNKcoulY5FUIE+LiusTCskoE+3XypA4DqwgIhumsJgUehXufl4Y3y3uSPOa41
        xywiTEW2LfeD759JjjC0oN7TH/QfN0iLRGBBgHisxstr1zAUGrKzIyg9nSgkeNXxIoI6
        KdvA==
X-RZG-AUTH: ":PGkAZ0+Ia/aHbZh+i/9QzqYeH5BDcTFH98iPmzDT881S1Jv9Y40I0vUpkEK3poY1KyL7e8vwUVd6rhLT+3nQPD/JTWrS4IlCVOSV0M8="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 44.28.0 AUTH)
        with ESMTPSA id d0520cv8UC4TJ7R
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 30 Sep 2019 14:04:29 +0200 (CEST)
From:   Peter Fink <pedro@pixelbox.red>
To:     netdev@vger.kernel.org
Cc:     pfink@christ-es.de, davem@davemloft.net, linux@christ-es.de
Subject: net: usb: ax88179_178a: allow passing MAC via DTB
Date:   Mon, 30 Sep 2019 14:04:02 +0200
Message-Id: <1569845043-27318-1-git-send-email-pedro@pixelbox.red>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


From: Peter Fink <pfink@christ-es.de>

This is a resend of the following patch as net-next was closed before:

I adopted the feature to pass the MAC address through device tree
from asix_devices.c (introduced in 03fc5d4) to ax88179-based devices.
Please have a look if this patch can be accepted.

I introduced a new function to avoid code duplication, but I'm not perfectly
satisfied with the function name. Suggestions welcome.

I'm not totally sure if the use of net->dev_addr and net->perm_addr
was correct in the first place or if my understanding is lacking some bits.
But I kept the existing behavior as it is working as expected.

Patch tested with 4.19, but applies cleanly on net-next.

Best regards,
Peter

--

 drivers/net/usb/ax88179_178a.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

-- 
2.7.4
