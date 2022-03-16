Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302BC4DB354
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356703AbiCPOej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbiCPOei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:34:38 -0400
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 073112A71B;
        Wed, 16 Mar 2022 07:33:23 -0700 (PDT)
Received: from smtpclient.apple (p5b3d2183.dip0.t-ipconnect.de [91.61.33.131])
        by mail.holtmann.org (Postfix) with ESMTPSA id 3B5F4CECF7;
        Wed, 16 Mar 2022 15:33:23 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH 1/2] Bluetooth: msft: Clear tracked devices on resume
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220312020707.1.I2b7f789329979102339d7e0717522ba417b63109@changeid>
Date:   Wed, 16 Mar 2022 15:33:22 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5A997787-B8A9-43B2-85FF-1882672D5AFF@holtmann.org>
References: <20220312020707.1.I2b7f789329979102339d7e0717522ba417b63109@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> Clear already tracked devices on system resume. Once the monitors are
> reregistered after resume, matched devices in range will be found again.
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> net/bluetooth/msft.c | 19 +++++++++++++++----
> 1 file changed, 15 insertions(+), 4 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

