Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A242C5E5820
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiIVBj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiIVBjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:39:25 -0400
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC14BA6C03;
        Wed, 21 Sep 2022 18:39:24 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 64D121E80D77;
        Thu, 22 Sep 2022 09:36:00 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nBV1HB9rEWZJ; Thu, 22 Sep 2022 09:35:57 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 44FE41E80D75;
        Thu, 22 Sep 2022 09:35:57 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     kuba@kernel.org
Cc:     aelior@marvell.com, linux-kernel@vger.kernel.org,
        manishc@marvell.com, netdev@vger.kernel.org, zeming@nfschina.com
Subject: =?UTF-8?q?Re=3A=20=5BPATCH=5D=20linux=3A=20qed=3A=20Remove=20unnecessary=20=E2=80=98NULL=E2=80=99=20values=20values=20from=20Pointer?=
Date:   Thu, 22 Sep 2022 09:39:11 +0800
Message-Id: <20220922013912.2653-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20220920164731.49856668@kernel.org>
References: <20220920164731.49856668@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thank you very much for your reply. Before, I found in the test that variable initialization assignment need to execute mov-related assembly instructions. If you remove unnecessary initialization assignments, you should be able to reduce the execution of some instructions.

