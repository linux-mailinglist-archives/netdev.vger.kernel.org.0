Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5A4FBCD6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244182AbiDKNPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiDKNPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:15:16 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Apr 2022 06:12:59 PDT
Received: from mta-65-225.siemens.flowmailer.net (mta-65-225.siemens.flowmailer.net [185.136.65.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12713377E5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:12:58 -0700 (PDT)
Received: by mta-65-225.siemens.flowmailer.net with ESMTPSA id 202204111311537eb345416c49261d76
        for <netdev@vger.kernel.org>;
        Mon, 11 Apr 2022 15:11:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=erez.geva.ext@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=4VjDyuInZVjsVfUc5RWMYo1c7nQgG7qsMEwjLRPM0Mo=;
 b=DOvCkOMdfeOHtrPeK6CJbNmFQ4W1gi3Ju0UacJRS6O7XSrNUKP+1KD8oP6NaP71dgh4fxl
 7VF46AWGselVIRnx8bWkQLKQoRC9xjp87iqVu0bF8LyPt+64KoJ/3wwWcEYq/FIPwRp0uflM
 QVdqbnhOsLr2uS4quyZGth5QVUbGI=;
From:   Erez Geva <erez.geva.ext@siemens.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>
Subject: [PATCH 0/1] Add DSA callback to traffic control information
Date:   Mon, 11 Apr 2022 15:11:47 +0200
Message-Id: <20220411131148.532520-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-118190:519-21489:flowmailer
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new callback function to DSA switch,
 so a tag driver could fetch traffic control information.

For example, if the switch enabel ETF,
 the tag driver would need to insert the transmit time stamp into the tag.

* P.S.
In "Documentation/networking/dsa (master)$ retext dsa.rst",
 under "Driver development".
I did not find any text regarding traffic control callbacks.

Erez Geva (1):
  DSA Add callback to traffic control information

 include/net/dsa.h  |  2 ++
 net/dsa/dsa_priv.h |  1 +
 net/dsa/slave.c    | 17 +++++++++++++++++
 3 files changed, 20 insertions(+)

-- 
2.30.2

