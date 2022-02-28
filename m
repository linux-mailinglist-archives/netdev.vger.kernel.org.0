Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606F74C6E72
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbiB1Nl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236667AbiB1Nly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:41:54 -0500
Received: from bergelmir.uberspace.de (bergelmir.uberspace.de [185.26.156.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D6A7CDCA
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 05:41:13 -0800 (PST)
Received: (qmail 32092 invoked by uid 989); 28 Feb 2022 13:34:30 -0000
Authentication-Results: bergelmir.uberspace.de;
        auth=pass (plain)
From:   Daniel Braunwarth <daniel@braunwarth.dev>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, daniel@braunwarth.dev
Subject: [PATCH net-next 0/2] if_ether.h: add industrial fieldbus Ethertypes
Date:   Mon, 28 Feb 2022 14:30:27 +0100
Message-Id: <20220228133029.100913-1-daniel@braunwarth.dev>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -
X-Rspamd-Report: R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) BAYES_HAM(-2.999964)
X-Rspamd-Score: -1.599964
Received: from unknown (HELO unkown) (::1)
        by bergelmir.uberspace.de (Haraka/2.8.28) with ESMTPSA; Mon, 28 Feb 2022 14:34:30 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of patches adds the Ethertypes for PROFINET and EtherCAT.

The defines should be used by iproute2 to extend the list of available link
layer protocols.

Daniel Braunwarth (2):
  if_ether.h: add PROFINET Ethertype
  if_ether.h: add EtherCAT Ethertype

 include/uapi/linux/if_ether.h | 2 ++
 1 file changed, 2 insertions(+)

--
2.35.1
