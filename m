Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293DFDA4E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 03:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfD2BKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 21:10:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfD2BKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 21:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rcVcqdFO49SFdrHQTsw0++3zaLLxzZQr+ZrLI9vdMJc=; b=KpvuH2+0lzYVkEorucmHsBuHd
        9nENTd8ckYbPux/I8yhWIsKwznn8tqPrBSB11H5t3J9sF4OMLPHJySs+PFXMp90M3wMPR0QE2a7zK
        HJBW8427+oSp15gE4DA5Wt89dn36LLmFAz5pY3bwS63ePnx4U/qcczNkYAkZJrhCRc8ImE2y/NlzZ
        F7v/rmItmr7c4E6v5Wh1Kscy/4cPRaBYg0lgTh8zdM+Y/vGn4MEeYzwOOZquE0deV1uQ4reiLJQEi
        HWwkLhxYID6+SogWgqU8qXd5ghS1we9Qits72rDQnNgbTQL5N6ddt4Q3eL/IE8BsrWt5gVwuz/buw
        6JCv148jw==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=dragon.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hKuob-00068s-Om; Mon, 29 Apr 2019 01:10:41 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -net] Documentation: fix netdev-FAQ.rst markup warning
Message-ID: <eabf639b-0e35-4758-a4ad-b78e85a3eb0f@infradead.org>
Date:   Sun, 28 Apr 2019 18:10:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix ReST underline warning:

./Documentation/networking/netdev-FAQ.rst:135: WARNING: Title underline too short.

Q: I made changes to only a few patches in a patch series should I resend only those changed?
--------------------------------------------------------------------------------------------


Fixes: ffa91253739c ("Documentation: networking: Update netdev-FAQ regarding patches")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-51-rc7.orig/Documentation/networking/netdev-FAQ.rst
+++ lnx-51-rc7/Documentation/networking/netdev-FAQ.rst
@@ -132,7 +132,7 @@ version that should be applied. If there
 will reply and ask what should be done.
 
 Q: I made changes to only a few patches in a patch series should I resend only those changed?
---------------------------------------------------------------------------------------------
+---------------------------------------------------------------------------------------------
 A: No, please resend the entire patch series and make sure you do number your
 patches such that it is clear this is the latest and greatest set of patches
 that can be applied.


