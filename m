Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EC6255D98
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgH1PQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:16:54 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:12064 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbgH1PQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:16:46 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 0F8885C10B0
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 23:14:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/2] Add ip6_fragment in ipv6_stub
Date:   Fri, 28 Aug 2020 23:14:30 +0800
Message-Id: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQx4eHklMS01NHUlPVkpOQkNNSUxNTEhKSUhVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P1E6Tww4HT5WQhkXIUhLIw4O
        Sw0aCkpVSlVKTkJDTUlMTUxISUNDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUJISjcG
X-HM-Tid: 0a7435a273eb2087kuqy0f8885c10b0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add ip6_fragment in ipv6_stub and use it in openvswitch
This version add default function eafnosupport_ipv6_fragment

wenxu (2):
  ipv6: add ipv6_fragment hook in ipv6_stub
  openvswitch: using ip6_fragment in ipv6_stub

 include/net/ipv6_stubs.h  | 3 +++
 net/ipv6/addrconf_core.c  | 8 ++++++++
 net/ipv6/af_inet6.c       | 1 +
 net/openvswitch/actions.c | 7 +------
 4 files changed, 13 insertions(+), 6 deletions(-)

-- 
1.8.3.1

