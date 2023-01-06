Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD84A65FEEC
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjAFK0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbjAFK02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:26:28 -0500
X-Greylist: delayed 398 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 02:25:05 PST
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD7171498
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:25:05 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 15989 invoked from network); 6 Jan 2023 11:18:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1673000303; bh=PNw2w9IynA9dhg+0BXAX2mG+8xC0xN3sSjZgRTrUy2k=;
          h=From:To:Cc:Subject;
          b=HvFKJqvncCfqqvdgOT31sdIinFMMK4bGhMdyXTLJUqTMIRsozJYlADS/MNdaGjPXF
           0ebhJaQpD+M7OkAFN1R3b0d8Rqrjt5FTCuMlHk+tZr69yarOmD5+m/d4CEUoGO//ZS
           clfVqosQZgQ5rNvQfDY2TErCjDunRjfN1W30UcDY=
Received: from 89-64-1-45.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.1.45])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiapeng.chong@linux.alibaba.com>; 6 Jan 2023 11:18:23 +0100
Date:   Fri, 6 Jan 2023 11:18:23 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     helmut.schaa@googlemail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] wifi: rt2x00: Remove useless else if
Message-ID: <20230106101823.GA994926@wp.pl>
References: <20230106022731.111243-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106022731.111243-1-jiapeng.chong@linux.alibaba.com>
X-WP-MailID: 9c2c211b270cb0c6755bfb4135db918b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YXO0]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 10:27:31AM +0800, Jiapeng Chong wrote:
> The assignment of the else and else if branches is the same, so the else
> if here is redundant, so we remove it.
> 
> ./drivers/net/wireless/ralink/rt2x00/rt2800lib.c:8927:9-11: WARNING:
> possible condition with no effect (if == else).
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3631
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
