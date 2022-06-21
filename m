Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAFB55314F
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350018AbiFULpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiFULpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:45:49 -0400
Received: from smtpbg.qq.com (smtpbg139.qq.com [175.27.65.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36930286DC;
        Tue, 21 Jun 2022 04:45:45 -0700 (PDT)
X-QQ-mid: bizesmtp73t1655811936ten2qx0b
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 19:45:31 +0800 (CST)
X-QQ-SSF: 0100000000700040B000B00A0000000
X-QQ-FEAT: vEggWWkZ1aeeivA2IGpkAS2dbrJ+8veKZTDvAPbI7V7/+4zenqmxuMDxGo+tl
        Src8wFYMgxo61jPU+MYlHgcPqkm7i8y+RyIWTPF1toZb7FWez++aBSy0GE+ACchBr3/Cphm
        IGnewpE/EwMSDusD7H33UI0T2hA71YXAoykoBughQzekW3QeQ/FB04CBdPAcPMEUm5BNlDz
        ObSaDFDl47Y/XI8tw3231fCpPu3y+tHRq1p6JePgvIczjwCGrAxhz3uCEMuyVVOC7g8Tgmv
        KugiQ5BLETt/A78ulO8aTJJi11Idc5frlSbTFcsiCIqV2NNBPeGwZ/7p0Dtjs0w2OntX2kD
        2rGjFMIZn3S+onJ8Iw=
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     isdn@linux-pingi.de
Cc:     jiangjian@cdjrlc.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: mISDN: hfcsusb: drop unexpected word "the" in the comments
Date:   Tue, 21 Jun 2022 19:45:29 +0800
Message-Id: <20220621114529.108079-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word "the" in the comments that need to be dropped

file: ./drivers/isdn/hardware/mISDN/hfcsusb.c
line: 1560
 /* set USB_SIZE_I to match the the wMaxPacketSize for ISO transfers */
changed to
 /* set USB_SIZE_I to match the wMaxPacketSize for ISO transfers */

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index cd5642cef01f..651f2f8f685b 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1557,7 +1557,7 @@ reset_hfcsusb(struct hfcsusb *hw)
 	write_reg(hw, HFCUSB_USB_SIZE, (hw->packet_size / 8) |
 		  ((hw->packet_size / 8) << 4));
 
-	/* set USB_SIZE_I to match the the wMaxPacketSize for ISO transfers */
+	/* set USB_SIZE_I to match the wMaxPacketSize for ISO transfers */
 	write_reg(hw, HFCUSB_USB_SIZE_I, hw->iso_packet_size);
 
 	/* enable PCM/GCI master mode */
-- 
2.17.1

