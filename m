Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239F1432647
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhJRSZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRSZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:25:41 -0400
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAC8C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 11:23:30 -0700 (PDT)
Received: from wncross.lan (unknown [IPv6:2a02:8106:1:6800:28c6:cddd:3280:eea4])
        by dehost.average.org (Postfix) with ESMTPA id 6A92238F8DDE;
        Mon, 18 Oct 2021 20:23:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1634581404; bh=kCgZNXZz3za7ASxK1lAOYdJMTRmpW0QPMboGGSiuEdY=;
        h=From:To:Cc:Subject:Date:From;
        b=XRdmJz7erHsujaQtPn1Ob2aUk8MbTwgZsXNy0sxwDQ+sgB6AJ+l3VpsFJW4tOEXfq
         WHrdzYtNsmffBJbQicLC48KjqW+Ib/lsuBWgR1NPTKngnCKlRc77DlmmnZm0N4fkJ0
         nZum+ID0i+lXhfio2wpNnZGVisQlqweSi4IflYSE=
From:   Eugene Crosser <crosser@average.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Subject: [PATCH net] vrf: Revert "Reset skb conntrack connection..."
Date:   Mon, 18 Oct 2021 20:22:49 +0200
Message-Id: <20211018182250.23093-1-crosser@average.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous change in the VRF driver breaks behaviour of netfiler
(explanation in the commit message).  It was suggested to revert
the change.

 drivers/net/vrf.c | 4 ----
 1 file changed, 4 deletions(-)

Thank you,

Eugene

