Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DE6686DCB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjBASU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjBASUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715007C717
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E1361902
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDE0C433EF;
        Wed,  1 Feb 2023 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675275618;
        bh=p+HE9BfAfBU+CImL4OxdukQsCQ+bZEL3c88IhB6fn9k=;
        h=From:To:Cc:Subject:Date:From;
        b=TpBa8z2b72AKqsg50zuW3edOlLL/cAJgXn2DshcGs/idGAIxzz9G0xChTgP1C6RM3
         dTLVhY8hSmS/f9pYZKcARm53Cq/VfZz+ED1ZkFHXiW+37skUXwo52KrMhfPa3d1/R9
         M9NVtUVgvQXYi1aUbP6y6cByZ1gg4W5gMJpnu9In7J3rZU8/EVmQ4cr/9cm/pqElRa
         YWlkDESVHYMn8p5r+mite5xNl44rSYDipyNOKIt4qa4GYjIlOggbRXKXlJnIpcxuPP
         SOQSiTGJYBT8iikWAOitgaTDRKz7O8Hx3d7e7eJa+BZ8DrNIdPt/u0X7qVhXC0Mr2y
         jZzTAouicB5AA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/4] MAINTAINERS: spring refresh of networking maintainers
Date:   Wed,  1 Feb 2023 10:20:10 -0800
Message-Id: <20230201182014.2362044-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use Jon Corbet's script for generating statistics about maintainer
coverage to identify inactive maintainers of relatively active code.
Move them to CREDITS.

Jakub Kicinski (4):
  MAINTAINERS: bonding: move Veaceslav Falico to CREDITS
  mailmap: add John Crispin's entry
  MAINTAINERS: ipv6: retire Hideaki Yoshifuji
  MAINTAINERS: update SCTP maintainers

 .mailmap    | 1 +
 CREDITS     | 8 ++++++++
 MAINTAINERS | 4 +---
 3 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.39.1

