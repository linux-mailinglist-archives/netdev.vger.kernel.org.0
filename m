Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C4F5A9010
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiIAHZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiIAHZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:25:03 -0400
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35D889E0E5;
        Thu,  1 Sep 2022 00:24:08 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 1FDF51E80CD3;
        Thu,  1 Sep 2022 15:23:47 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GBFilu_N-GO3; Thu,  1 Sep 2022 15:23:44 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 5E0ED1E80CD2;
        Thu,  1 Sep 2022 15:23:44 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, zeming@nfschina.com
Subject: Re: [PATCH] net: ipv4: Use SPDX-license-identifier and remove the License description
Date:   Thu,  1 Sep 2022 15:23:52 +0800
Message-Id: <20220901072353.3235-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20220831193223.153911e4@kernel.org>
References: <20220831193223.153911e4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


sorry, I haven't found a more authoritative description about the GPL-2.0-or-later license. I saw some GPL-2.0-or-later licenses added in the patch submission. If I'm not sure if this is feasible, I will change it. Re-send patch for GPL-2.0 license.

