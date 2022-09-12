Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6643C5B5509
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiILHH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiILHHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:07:55 -0400
Received: from mail.sch.bme.hu (mail.sch.bme.hu [152.66.208.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634022A960
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:07:53 -0700 (PDT)
Received: from Exchange2016-1.sch.bme.hu (152.66.208.194) by
 Exchange2016-1.sch.bme.hu (152.66.208.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 09:06:48 +0200
Received: from Cognitio.sch.bme.hu (152.66.211.220) by
 Exchange2016-1.sch.bme.hu (152.66.208.194) with Microsoft SMTP Server id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 09:06:48 +0200
From:   =?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>
To:     <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>, <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>
Subject: Re: [PATCH v3 2/2] net: fec: Use unlocked timecounter reads for saving state
Date:   Mon, 12 Sep 2022 07:31:06 +0000
Message-ID: <20220912073106.2544207-3-bence98@sch.bme.hu>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220912073106.2544207-1-bence98@sch.bme.hu>
References: <20220912073106.2544207-1-bence98@sch.bme.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Csókás Bence <csokas.bence@prolan.hu>

Please thoroughly test this, as I am still
out-of-office, and cannot test on hardware.
