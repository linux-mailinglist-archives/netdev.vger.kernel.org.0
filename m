Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6556E4E35
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjDQQWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjDQQWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:22:38 -0400
Received: from synguard (unknown [212.29.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD2EBB9E;
        Mon, 17 Apr 2023 09:22:28 -0700 (PDT)
Received: from T14.siklu.local (unknown [192.168.42.162])
        by synguard (Postfix) with ESMTP id D03F24DE4E;
        Mon, 17 Apr 2023 19:03:07 +0300 (IDT)
From:   Shmuel Hazan <shmuel.h@siklu.com>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: net: mvpp2: tai: add extts support 
Date:   Mon, 17 Apr 2023 19:01:48 +0300
Message-Id: <20230417160151.1617256-1-shmuel.h@siklu.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,RDNS_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for PTP event capture on the Aramda
80x0/70x0. This feature is mainly used by tools linux ts2phc(3) in order
to synchronize a timestamping unit (like the mvpp2's TAI) and a system
DPLL on the same PCB. 

The patch series includes 3 patches: the second one implements the
actual extts function.


