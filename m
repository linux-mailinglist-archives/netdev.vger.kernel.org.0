Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B57950E659
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241573AbiDYRBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 13:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbiDYRBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 13:01:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A038DB8
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:58:38 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="245870517"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="245870517"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 09:58:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="532207912"
Received: from silpixa00396680.ir.intel.com (HELO silpixa00396680.ger.corp.intel.com) ([10.237.223.54])
  by orsmga006.jf.intel.com with ESMTP; 25 Apr 2022 09:58:28 -0700
From:   Ray Kinsella <mdr@ashroe.eu>
To:     netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, stephen@networkplumber.org,
        Ray Kinsella <mdr@ashroe.eu>
Subject: [PATCH 0/1] updates to tc-bpf manpage
Date:   Mon, 25 Apr 2022 17:57:32 +0100
Message-Id: <20220425165733.240902-1-mdr@ashroe.eu>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_FAIL,SPF_HELO_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

I was a bit unsure what ML this patch should go to?
It is a small update/fix for the tc-bpf manpage.

Ray Kinsella (1):
  tc-bpf: added instructions to build cbpf generator

 man/man8/tc-bpf.8 | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.26.2

