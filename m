Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92266563DE3
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiGBDMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiGBDMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:12:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164083B3C5
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 20:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5AF5B83222
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 03:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B2BC3411E;
        Sat,  2 Jul 2022 03:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656731532;
        bh=w2zkETMYDmWbMlbp+z2KjdE/ixzZtREb87vtKrdnzMM=;
        h=From:To:Cc:Subject:Date:From;
        b=mZKyPkMVWyshzSLMXuz9BomNvRwC8P6RdSZ5EtbCxrSsbs1JoMZQaNsDpNbBVgGkN
         TqTVisAMIXDyecOLO1IMTLpoRXly8fk3VYO0WsRNGuV54kNx1CWSDQDMrZP/s4M6Vo
         e2cfs9XLc/JSDJnl2EW+B+2wsJvLr9OcnSVnVAwvcSIoiVHEjg3kqsYOxozk1ZfljZ
         O82cQO2/86Wz+7miuGmyPs56iWQ/e059DirKN9pYdE41yVCPHUFeCqEZnqqtxrd2DI
         KkfjtcKd9zTofLw5lIongAFHAD/RaWWz1wEhZ3WmMVPDpV6wdN7HczguvRdlU1LKZ4
         fwUacJKBBF0lQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 0/3] docs: netdev: document more of our rules
Date:   Fri,  1 Jul 2022 20:12:06 -0700
Message-Id: <20220702031209.790535-1-kuba@kernel.org>
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

v2: improve the series length blurb (Andrew)

Jakub Kicinski (3):
  docs: netdev: document that patch series length limit
  docs: netdev: document reverse xmas tree
  docs: netdev: add a cheat sheet for the rules

 Documentation/process/maintainer-netdev.rst | 36 +++++++++++++++++++++
 1 file changed, 36 insertions(+)

-- 
2.36.1

