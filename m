Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0C1A2EC0
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 07:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgDIFSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 01:18:35 -0400
Received: from vip1.b1c1l1.com ([64.57.102.218]:35129 "EHLO vip1.b1c1l1.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgDIFSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 01:18:34 -0400
Received: by vip1.b1c1l1.com (Postfix) with ESMTPSA id 6668C27347;
        Thu,  9 Apr 2020 05:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=b1c1l1.com; s=alpha;
        t=1586409163; bh=h/667wW09W1Wsw37ua4O3+yMZVWkXTuT1HKVnioe6gw=;
        h=From:To:Cc:Subject:Date;
        b=ZTyxyzmR8B+hdyAyylGKvIDB7oo1Tvlf0lffBy6bCIETdoFO8iTWbcyT3+U0yFxE/
         bG0j/feiJClruAdcwWZYMzyJwGarMnmynBch9XJyUi5KdFC8Y0QgeHuIGXiQzKmzF3
         CJRuCYg+1Vxnx3uX6ATKu2Oi8w/fTE4UmH+xD/V02/vBNpbzP4CzoB9KSfuUzH6rYk
         B9chPVDWse1/np3hbVFaGTc+MFwes2lSaEqaCqygc1vS7f9A7m7YR4vPnmPgoOAAwc
         +eecqGmasjpvpHxkjqnmXWPjODfTBx9msoEcskPfD2CAFfAQ2vbyjf6LSb/yEzBQkq
         B3UUgPLWxY3GA==
From:   Benjamin Lee <ben@b1c1l1.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Lee <ben@b1c1l1.com>
Subject: [PATCH iproute2 0/3] man: Updates for tc-htb.8
Date:   Wed,  8 Apr 2020 22:12:12 -0700
Message-Id: <20200409051215.27291-1-ben@b1c1l1.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm new, so please let me know if this isn't the right place or format.

Here are a few minor updates for the tc-htb.8 man page.

Benjamin Lee (3):
  man: tc-htb.8: add missing qdisc parameter r2q
  man: tc-htb.8: add missing class parameter quantum
  man: tc-htb.8: fix class prio is not mandatory

 man/man8/tc-htb.8 | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

-- 
2.25.1

