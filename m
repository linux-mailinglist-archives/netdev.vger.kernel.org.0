Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247EF2543E3
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgH0Kj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:39:59 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:3545 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0Kj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:39:57 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 1C63B5C1614;
        Thu, 27 Aug 2020 18:39:53 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, marcelo.leitner@gmail.com
Subject: [PATCH net-next 0/2] Put ip6_fragment in ipv6_stub
Date:   Thu, 27 Aug 2020 18:39:50 +0800
Message-Id: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGUlIQx0eT0JDQkpDVkpOQkNOSU9MQkhJS05VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PUk6DCo4OD5LLxkvHAwrHzg3
        Tz9PCh9VSlVKTkJDTklPTEJISEhKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUJKQjcG
X-HM-Tid: 0a742f80a1332087kuqy1c63b5c1614
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add ip6_fragment in ipv6_stub and use it in openvswitch

wenxu (2):
  ipv6: add ipv6_fragment hook in ipv6_stub
  openvswitch: using ip6_fragment in ipv6_stub

 include/net/ipv6_stubs.h  | 2 ++
 net/ipv6/af_inet6.c       | 1 +
 net/openvswitch/actions.c | 6 ++----
 3 files changed, 5 insertions(+), 4 deletions(-)

-- 
1.8.3.1

