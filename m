Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5C95EAC74
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiIZQ1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiIZQ0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:26:51 -0400
X-Greylist: delayed 94 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Sep 2022 08:15:33 PDT
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3347E015;
        Mon, 26 Sep 2022 08:15:32 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout3.routing.net (Postfix) with ESMTP id 60F71604B1;
        Mon, 26 Sep 2022 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1664204886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xZG8JkRaZLK232kDPLAOmHeKNwxxMI/j9n7ukbBYAW0=;
        b=s7SVLJJEfwZODlXq4TDif6GkRLd/BTItP/PGcCqfAYRBoFlTPD258SCsJ00KGW9KyA30B6
        EQLEANnwyYPg7HpgU5ZiRhGmk1enjE9QTn0f/WMjlQKEfCUECDjLtWptAiEj+mcofcbEBU
        GZBWbxMWoNDf5A7oajch6PbbW58b3lA=
Received: from frank-G5.. (fttx-pool-217.61.154.230.bambit.de [217.61.154.230])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 77D0C360037;
        Mon, 26 Sep 2022 15:08:05 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-usb@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add Support for Dell 5811e with usb-id 0x413c:0x81c2
Date:   Mon, 26 Sep 2022 17:07:38 +0200
Message-Id: <20220926150740.6684-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 46a954e0-9594-4660-91c0-7275a392d480
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Add new USB-id for dell branded EM7455 with this usb-id in qcserial and qmi
driver.
MBIM-mode works out of the box with 6.0-rc6.

Frank Wunderlich (2):
  USB: serial: qcserial: add new usb-id for Dell branded EM7455
  net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455

 drivers/net/usb/qmi_wwan.c    | 1 +
 drivers/usb/serial/qcserial.c | 1 +
 2 files changed, 2 insertions(+)

-- 
2.34.1

