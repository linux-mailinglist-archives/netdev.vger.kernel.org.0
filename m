Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D74EA6A5
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 06:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiC2EkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 00:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiC2EkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 00:40:03 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B93258;
        Mon, 28 Mar 2022 21:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1648528700; x=1680064700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pBA2m+cIFq2SEHJ7z8tYF7rHnn9wxdFXvGg8jh2IpRU=;
  b=qCNlBxWeEmKVnxO/4vO/FeIpGoF8Pmalh9XEiuHtNB3yoLN6Y182nCsr
   GBuzXYSG6Lg1NjPdhGyCkYpejXlQOl/v84tuXsDxQN6jbMFpNWgyWeao2
   d98dmIs4+SEW/m+Fa2L+jCTqrm9lSRyodie9Z0arrgXvJRR44cZkcEH1m
   M=;
X-IronPort-AV: E=Sophos;i="5.90,219,1643673600"; 
   d="scan'208";a="184965589"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 29 Mar 2022 04:38:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-51ba86d8.us-west-2.amazon.com (Postfix) with ESMTPS id 93B951205E1;
        Tue, 29 Mar 2022 04:38:16 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 29 Mar 2022 04:38:15 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 29 Mar 2022 04:38:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <bpf@vger.kernel.org>, <corbet@lwn.net>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <linux-doc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <kuniyu@amazon.co.jp>
Subject: Re: [PATCH net 00/13] docs: update and move the netdev-FAQ
Date:   Tue, 29 Mar 2022 13:38:08 +0900
Message-ID: <20220329043808.95053-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220327025400.2481365-1-kuba@kernel.org>
References: <20220327025400.2481365-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.153]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Sat, 26 Mar 2022 19:53:47 -0700
> A section of documentation for tree-specific process quirks had
> been created a while back. There's only one tree in it, so far,
> the tip tree, but the contents seem to answer similar questions
> as we answer in the netdev-FAQ. Move the netdev-FAQ.
> 
> Take this opportunity to touch up and update a few sections.

Thanks for update!

I would like to clarify one thing about this website.

  http://vger.kernel.org/~davem/net-next.html

I often check this before submitting patches.  I like this much, but it
seems not working properly for now.  Is this no longer maintained or by
coincidence this time?  If I could help something, please let me know :)
