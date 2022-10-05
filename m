Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018B75F5838
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJEQSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 12:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJEQSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 12:18:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B838858147;
        Wed,  5 Oct 2022 09:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664986690; x=1696522690;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UYfHvpCRI1zbJ4zp2KlFrLkB1BDaE2lezmw/BQ7Cz3Y=;
  b=FEzsoqtdkkBwKdsYM4cMLmM3jy1c9fhrfm1BkcFGOElYOGLbOe16ps0H
   3hwdbzUk5s7dcw1991txdHDptrES8msg5RSKJn6SyF0h7My7w5KMy6T93
   e0oMdYRnUHXIy316Bys0+TG5MSe9qqCbt8pYPbOXbFf8uEjkinbdPaLCw
   6kVr8Bvytz5yhQnH8ZfeQhR/y3Im8knCmlK1ksESqmiQPQ3q9wuKJa7lU
   rhI/OtWM0Bv3a1gBKfPEXnpsVrRt6qWnw8/sgELleIOBbu9wMo0Kik+Zy
   SlUUg1x0SHqWLQmr2UyJd/Ggt0sZGYn+GkN51Uyetp941vzBdjdGNMJSp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="290445161"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="290445161"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 09:18:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="687018947"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="687018947"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 05 Oct 2022 09:18:08 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 295GI70t014090;
        Wed, 5 Oct 2022 17:18:08 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: XDP Workshop @ Netdev 0x16 -- send me your topics
Date:   Wed,  5 Oct 2022 18:15:12 +0200
Message-Id: <20221005161511.55553-1-olek@lass.die.banner.fliegen>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(pls ignore if you ignore Netdevs)

Hey,

I'm open for topics/ideas/propos/.* for the XDP Workshop at Netdev
0x16 (Lisbon, 24-28 Oct 2022, workshop is on 25th, 9 AM WEST), the
crazier the better. I have some stuff written down already, also
will publish the agenda on some open resource soon.

Thanks,
Olek
