Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE85624EA61
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgHVXUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgHVXUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:20:04 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622ECC061575;
        Sat, 22 Aug 2020 16:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kOLzG1/3voVnbRG1POVfM7xr2nMy3QnryFm1D6I44WA=; b=zQL7nWTEyt5EhSgNZwvooYVJN4
        0Z5IHeKmeq5O/I34xm8ub/ac2i96YFv5QL7NCyYfzzvCwrKCrKn1hOEgOrolbWZ+NFhDdx0qbLGQz
        w+WBXBLWsh/7NztPWasKW0aBHOvrPPep0h0jRgpNQ8PXVOQfeItcZjDjc5W3nTeMud3cabEbwd/3l
        0YvFcS+5IQjYIvbbgUsPJAZQD0UxpKMb904WzrtDdiLbzXnpfuBPEvN43URjLjx2kYr1R0kD7R8wB
        iV0WjTiLmb69/EJvyZkzoH0/u6/F3GlZYuZ0tVtD0dm9JoBkzYyFQIkCCEZgc1xLI+NqaNvOVWoKa
        AqMEGk0g==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9cnq-0006fS-1X; Sat, 22 Aug 2020 23:20:02 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] net: mac80211: mesh.h: delete duplicated word
Date:   Sat, 22 Aug 2020 16:19:48 -0700
Message-Id: <20200822231953.465-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231953.465-1-rdunlap@infradead.org>
References: <20200822231953.465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "address".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/mesh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/mac80211/mesh.c
+++ linux-next-20200731/net/mac80211/mesh.c
@@ -672,7 +672,7 @@ void ieee80211_mesh_root_setup(struct ie
  * @hdr:	802.11 frame header
  * @fc:		frame control field
  * @meshda:	destination address in the mesh
- * @meshsa:	source address address in the mesh.  Same as TA, as frame is
+ * @meshsa:	source address in the mesh.  Same as TA, as frame is
  *              locally originated.
  *
  * Return the length of the 802.11 (does not include a mesh control header)
