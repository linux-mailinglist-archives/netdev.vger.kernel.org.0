Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDBA5061A0
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbiDSBRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239603AbiDSBRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:17:44 -0400
X-Greylist: delayed 87876 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Apr 2022 18:15:03 PDT
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A66BB3;
        Mon, 18 Apr 2022 18:14:56 -0700 (PDT)
Date:   Tue, 19 Apr 2022 01:14:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail2; t=1650330895;
        bh=wzjLv5GUoM7KeGIIy7AzLAwk4fQSO5fQfUO1CoZX6mE=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=LiOp4kU0sz/rECP1P5L+HAWzzUAn0yRxycXak9G9oVdeVD69ewZ8Cx8c6Ks0d57NM
         tHPEI1YJN++9FapXLDzPo0O498sTWj3MR9oPslAEwEDIEhh7nacD8J7MuAaA2Xt+6r
         r6exslw4i+WL1Yh74CxU5Pu7a7NC64PgaeuFW8a/54zeMZVva6wjEiDudqTqOGvyTL
         ++cIs6teTsdqDLWvQOpr6ADKBJSgrBqWvHY82xW1GTq/Lg1B03EBd/lt2ZJoJAsD1n
         uZcZDMzmD/TpwqBs5qJ4k4WIFbvIGOfZVrp+lWqxwjUD35Tus75DjbxiBdbuObKbGK
         XVtufnavEu+Iw==
To:     linux-wireless@vger.kernel.org
From:   Solomon Tan <solomonbstoner@protonmail.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        miriam.rachel.korenblit@intel.com, johannes.berg@intel.com,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        kvalo@kernel.org, luciano.coelho@intel.com,
        Solomon Tan <solomonbstoner@protonmail.ch>
Reply-To: Solomon Tan <solomonbstoner@protonmail.ch>
Subject: [PATCH 1/3] iwlwifi: Remove prohibited spaces
Message-ID: <20220419011340.14954-2-solomonbstoner@protonmail.ch>
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

This patch addresses the error from checkpatch.pl regarding the presence
of prohibited spaces.

Signed-off-by: Solomon Tan <solomonbstoner@protonmail.ch>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/n=
et/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 9040da3dcce3..c11088fecc16 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -81,7 +81,7 @@ static const u16 iwl_nvm_channels[] =3D {
 =09/* 2.4 GHz */
 =091, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
 =09/* 5 GHz */
-=0936, 40, 44 , 48, 52, 56, 60, 64,
+=0936, 40, 44, 48, 52, 56, 60, 64,
 =09100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144,
 =09149, 153, 157, 161, 165
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net=
/wireless/intel/iwlwifi/mvm/debugfs.c
index 49898fd99594..5e7f2c64937e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -214,9 +214,9 @@ static ssize_t iwl_dbgfs_set_nic_temperature_read(struc=
t file *file,
 =09int pos;

 =09if (!mvm->temperature_test)
-=09=09pos =3D scnprintf(buf , sizeof(buf), "disabled\n");
+=09=09pos =3D scnprintf(buf, sizeof(buf), "disabled\n");
 =09else
-=09=09pos =3D scnprintf(buf , sizeof(buf), "%d\n", mvm->temperature);
+=09=09pos =3D scnprintf(buf, sizeof(buf), "%d\n", mvm->temperature);

 =09return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -261,7 +261,7 @@ static ssize_t iwl_dbgfs_set_nic_temperature_write(stru=
ct iwl_mvm *mvm,
 =09=09mvm->temperature =3D temperature;
 =09}
 =09IWL_DEBUG_TEMP(mvm, "%sabling debug set temperature (temp =3D %d)\n",
-=09=09       mvm->temperature_test ? "En" : "Dis" ,
+=09=09       mvm->temperature_test ? "En" : "Dis",
 =09=09       mvm->temperature);
 =09/* handle the temperature change */
 =09iwl_mvm_tt_handler(mvm);
@@ -291,7 +291,7 @@ static ssize_t iwl_dbgfs_nic_temp_read(struct file *fil=
e,
 =09if (ret)
 =09=09return -EIO;

-=09pos =3D scnprintf(buf , sizeof(buf), "%d\n", temp);
+=09pos =3D scnprintf(buf, sizeof(buf), "%d\n", temp);

 =09return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
--
2.35.3


