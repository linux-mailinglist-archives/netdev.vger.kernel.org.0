Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C59400C95
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 20:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbhIDScB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 14:32:01 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:58693 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbhIDSbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 14:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Content-ID:
        Content-Description; bh=blpZE9y4KzRJRRxWx4qpHNucdgQj3S3fwwnHKLMpPG0=; b=ieA8U
        Idt+HQVOd7C2K4xIZXfC1UcTgo1ABkqFi+hMq3qEi394pm71n/sFnBsPEudmtKnV3lah3U+9fgmYY
        XXZSURrAibDEShM1k5Du80Mg5/MJ1x7dAqzCgipL+t0klfCnLyhNrtvpJklnlRdLlgxSwqL8X22LT
        a/gdk4ImtpZMOW2MZVcYDyUyWmXmyLGbYWaKtVDAPd1dvs/MJ196BQz9pzN16w3qs8XQ9F8GuOiG1
        YEA5lGD9ZeWeYBPga07a81BKd7CGbxiycEhMkufjPgiK5CmDCIeE0lVEiPtdZh6zbsawcoHOFtZIK
        eQR+qq0Slo0S0gHFPPk9ciIr5XAiA==;
Message-Id: <cover.1630770829.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Sat, 4 Sep 2021 17:53:49 +0200
Subject: [PATCH 0/2] net/9p: increase default msize
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Greg Kurz <groug@kaod.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As previously discussed, many users are not aware about the 'msize' option
of the Linux 9p client and the negative impact it can have if its value is
too low. This series raises the default value for 'msize' from 8k to 128k.

Later on in separate series, the current capping of user supplied values for
'msize' of currently max. 512k should be addressed, which is likewise too
small: https://lists.gnu.org/archive/html/qemu-devel/2021-02/msg06343.html

Christian Schoenebeck (2):
  net/9p: use macro to define default msize
  net/9p: increase default msize to 128k

 net/9p/client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
2.20.1

