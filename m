Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232F650619D
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241561AbiDSBRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbiDSBRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:17:12 -0400
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651792D1EB
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 18:14:30 -0700 (PDT)
Date:   Tue, 19 Apr 2022 01:14:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail2; t=1650330868;
        bh=9M5szPGT7SceYEUfth8beJqIX9oNjhtVwa7dIqIdi9E=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=YSQXp0kUaTaeJN5KLZqsZB8o99aXiy3DHtxRyV6dhFbpnxp3WQHhOzTCsmIisK06B
         CAloTr9zJVIgX/57XPf1d1Gpoyt5IJvDyXb3rnxcSfuxRUbfKOVGQjOYQdA4/RaW1P
         ta+QcFJhtA7Xy4jls7ipPK5J8BhnN71mFtIKQ5Pq9AUUgr4kUzG1vlMOrGmqaFTge5
         ZvHTJK4afdTWiL9/9BLE2+8M0nACMjsjqFllnLy0RdV5bkxvd1G8bf0lSG4CFKaxoC
         dQXQ1hKGVzUYEl4KUgeRa998qahqvlt1VlK5QTrjj3X5jhhBFLrs4Z7s3X+KVwwOCm
         72X5kQgdlmNkw==
To:     linux-wireless@vger.kernel.org
From:   Solomon Tan <solomonbstoner@protonmail.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        miriam.rachel.korenblit@intel.com, johannes.berg@intel.com,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        kvalo@kernel.org, luciano.coelho@intel.com,
        Solomon Tan <solomonbstoner@protonmail.ch>
Reply-To: Solomon Tan <solomonbstoner@protonmail.ch>
Subject: [PATCH 0/3] iwlwifi: Address whitespace coding style errors
Message-ID: <20220419011340.14954-1-solomonbstoner@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of three patches addresses the whitespace coding style
errors marked by checkpatch.pl as an "ERROR". In order of sequence,
the following edits are made:
1. Removal of prohibited spaces
2. Addition of required space
3. Replacement of space with tabs as code indent.

Signed-off-by: Solomon Tan <solomonbstoner@protonmail.ch>

