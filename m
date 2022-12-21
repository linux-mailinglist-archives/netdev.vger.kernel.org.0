Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015B1653672
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbiLUSkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiLUSkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E452656D
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 10:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F39C1618E8
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 18:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0153EC433D2;
        Wed, 21 Dec 2022 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671648010;
        bh=HSjQirGA0DapM5bnC7IPl69AbGQvAHBXrjLyUpjEIho=;
        h=From:To:Cc:Subject:Date:From;
        b=iZthVvl/6ox0ygyKNtncZVkflsfHDfm3/O/6glrWYzICp+DEZ1agJChrTW00HggM0
         +g5wfgN2cNq42+XS+WB8ZRPGhoWbYBzuT1xqnUay/p3yhajtBqaFhwjv2clU2ox6GK
         ECB6+De5z35TK09nauwtfEJYR+0hMkBWhMUiQ4vMz6WKgUzm6iwQKAM3VyyiTFDfG/
         K1Gp1b5Nm+k5WyQuJWK004+vEjOn4t/1BeGKLqo3MbUAtjmIrTSk45yhS3YUafahFw
         Wxj/PjCWEMUn0BEQ1IXNsXK8n0idR9mPi55BfI3nmZniqClYbOdHmG4ilyAqQMwgZr
         dM052MZC+yvZg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        f.fainelli@gmail.com, andrew@lunn.ch, rdunlap@infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] netdev doc de-FAQization
Date:   Wed, 21 Dec 2022 10:40:05 -0800
Message-Id: <20221221184007.1170384-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been tempted to do this for a while. I think that we have outgrown
the FAQ format for our process doc. I'm curious what others think but
I often find myself struggling to locate information in this doc,
because the questions do not serve well as section headers.

Jakub Kicinski (2):
  docs: netdev: reshuffle sections in prep for de-FAQization
  docs: netdev: convert to a non-FAQ document

 Documentation/process/maintainer-netdev.rst | 363 +++++++++++---------
 1 file changed, 196 insertions(+), 167 deletions(-)

-- 
2.38.1

