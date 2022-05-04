Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BBD519B2D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346837AbiEDJLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiEDJLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:11:38 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBBE61A824
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 02:08:03 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 76950600D8;
        Wed,  4 May 2022 11:08:02 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1nmAzK-0005gH-Cn; Wed, 04 May 2022 11:08:02 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net v3 0/2] vrf: fix address binding with icmp socket
Date:   Wed,  4 May 2022 11:07:37 +0200
Message-Id: <20220504090739.21821-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
References: <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The first patch fixes the issue.
The second patch adds related tests in selftests.

v2 -> v3:
 update seltests
 fix ipv6

v1 -> v2:
 add the tag "Cc: stable@vger.kernel.org" for correct stable submission

 net/ipv4/ping.c                           | 12 +++++++++++-
 tools/testing/selftests/net/fcnal-test.sh | 12 ++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

Comments are welcome,
Nicolas

