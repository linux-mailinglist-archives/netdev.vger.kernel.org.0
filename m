Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDADA5061A3
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245143AbiDSBSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbiDSBSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:18:05 -0400
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F052E698;
        Mon, 18 Apr 2022 18:15:24 -0700 (PDT)
Date:   Tue, 19 Apr 2022 01:15:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail2; t=1650330923;
        bh=1GFGYWgcMmJP4l5OtKG/5cs+LyA9/eYC0MJ8P1m8xlg=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=V+DXe/SnQB47XqyyhSfe7jCE5WBce8ni5iPME4kgFFAvo0+dZP3KIJVm8QSJ+H7tT
         AGb3A+ldMIZIfgOr2ldlu+SxgV6JR2M9KJEeLRfCwKUmM7M+L0aubzfKuhYLX7cali
         9X3ElMImvt1BmUTq8ye/MvYH0iuM1v/GhbyWARKXPRptFqTFywqqom4En/YguWe8SD
         av4eVE4topVUaspWjpg7z2ox8eWlphHAhYxIBQbjCan+1GpWjS0EA129FwKWBMivDz
         plVbUdBUJYhJTHE88+z5mZnCrSYWB1EBFIcfAKJDEU5YhNkXXS57IZ+msk3MjY88es
         pU2llwlRsWYdg==
To:     linux-wireless@vger.kernel.org
From:   Solomon Tan <solomonbstoner@protonmail.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        miriam.rachel.korenblit@intel.com, johannes.berg@intel.com,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        kvalo@kernel.org, luciano.coelho@intel.com,
        Solomon Tan <solomonbstoner@protonmail.ch>
Reply-To: Solomon Tan <solomonbstoner@protonmail.ch>
Subject: [PATCH 2/3] iwlwifi: Add required space before open '('
Message-ID: <20220419011340.14954-3-solomonbstoner@protonmail.ch>
In-Reply-To: <20220419011340.14954-1-solomonbstoner@protonmail.ch>
References: <20220419011340.14954-1-solomonbstoner@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the error from checkpatch.pl that a space is
required before an open parenthesis.

Signed-off-by: Solomon Tan <solomonbstoner@protonmail.ch>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wire=
less/intel/iwlwifi/mvm/fw.c
index e842816134f1..bae270893eac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1016,7 +1016,7 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)

 =09ret =3D iwl_read_ppag_table(&mvm->fwrt, &cmd, &cmd_size);
 =09/* Not supporting PPAG table is a valid scenario */
-=09if(ret < 0)
+=09if (ret < 0)
 =09=09return 0;

 =09IWL_DEBUG_RADIO(mvm, "Sending PER_PLATFORM_ANT_GAIN_CMD\n");
--
2.35.3


