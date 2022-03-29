Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3144EA874
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiC2HYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 03:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiC2HYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 03:24:19 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0244724316E;
        Tue, 29 Mar 2022 00:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1648538556; x=1680074556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ISy1PdTNl86QIZVHuPS0xM2PPd3z/iaIEXnSylN2poQ=;
  b=BFDbO9wk58ZQt/RAyv9+XjXntuRqhm5LJMbc2Ukz+KMLwe4HRowg6Wrz
   kv92ieX7ysjTUsXEg3ELFkXerQHRqajG+DIU/7EAicM9xEKvfIV/2ZNYv
   5yQXViOAVj7oGqFUO2zn3eE8C8gOQbHsA7yA4s/SJI3tCFGUOfNeG/fPy
   U=;
X-IronPort-AV: E=Sophos;i="5.90,219,1643673600"; 
   d="scan'208";a="188496438"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 29 Mar 2022 07:22:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-28a78e3f.us-west-2.amazon.com (Postfix) with ESMTPS id A1E24A2761;
        Tue, 29 Mar 2022 07:22:33 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 29 Mar 2022 07:22:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.180) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 29 Mar 2022 07:22:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <bpf@vger.kernel.org>, <corbet@lwn.net>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-doc@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net 00/13] docs: update and move the netdev-FAQ
Date:   Tue, 29 Mar 2022 16:22:23 +0900
Message-ID: <20220329072223.6733-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220328215247.69d31c4a@kernel.org>
References: <20220328215247.69d31c4a@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D22UWC004.ant.amazon.com (10.43.162.198) To
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
Date:   Mon, 28 Mar 2022 21:52:47 -0700
> On Tue, 29 Mar 2022 13:38:08 +0900 Kuniyuki Iwashima wrote:
> > From:   Jakub Kicinski <kuba@kernel.org>
> > Date:   Sat, 26 Mar 2022 19:53:47 -0700
> > > A section of documentation for tree-specific process quirks had
> > > been created a while back. There's only one tree in it, so far,
> > > the tip tree, but the contents seem to answer similar questions
> > > as we answer in the netdev-FAQ. Move the netdev-FAQ.
> > > 
> > > Take this opportunity to touch up and update a few sections.  
> > 
> > Thanks for update!
> > 
> > I would like to clarify one thing about this website.
> > 
> >   http://vger.kernel.org/~davem/net-next.html
> > 
> > I often check this before submitting patches.  I like this much, but it
> > seems not working properly for now.  Is this no longer maintained or by
> > coincidence this time?  If I could help something, please let me know :)
> 
> Sorry about that, DaveM has been traveling during this merge window. 
> He said he'll fix it soon.

Ah, sorry for noise, and thank you!

Have a nice trip, DaveM!
