Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF49A562172
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiF3RqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiF3RqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:46:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8D23631E;
        Thu, 30 Jun 2022 10:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ACD6621AD;
        Thu, 30 Jun 2022 17:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255ABC34115;
        Thu, 30 Jun 2022 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656611178;
        bh=u/9qxCzbEkQBcytv7lOwYR8v/Dx/VVKIWpmEu7mODBY=;
        h=From:To:Cc:Subject:Date:From;
        b=W2dRhMD97p021AGYm0NRR9OVofsH1m+HRTNTRqH0LNCuDkWHzhNPBwA4z74AOPrJh
         EMOw3p3oFXH68ambOsE+NmQr6mIf8A0zW6fgL9D3VLRerC8X4YOJ+V4L9K6CFRJzxD
         AFg2somlShNHrg0+/5dE+Ea7Euwjapn/lCXBIvFKfqd+5VXiOXHsw0EUZEvDGzQ98M
         nNAWpoyEw3ahZ7jeSC649irujXx6zEdtQnmEbglOWdk3bOawxvOx6PIz/JN5TCr/Ex
         q9ed8p0WlYU6loqH0d8OgQ4YvzIZZcy1dj/NhsMfhrRsNI70zeChJUdl1DDXLWwiLj
         IW/IvRqyjT7kw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] docs: netdev: document more of our rules
Date:   Thu, 30 Jun 2022 10:46:04 -0700
Message-Id: <20220630174607.629408-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series length limit and reverse xmas tree are not documented.
Add those, and a tl;dr section summarizing how we differ.

Jakub Kicinski (3):
  docs: netdev: document that patch series length limit
  docs: netdev: document reverse xmas tree
  docs: netdev: add a cheat sheet for the rules

 Documentation/process/maintainer-netdev.rst | 30 +++++++++++++++++++++
 1 file changed, 30 insertions(+)

-- 
2.36.1

