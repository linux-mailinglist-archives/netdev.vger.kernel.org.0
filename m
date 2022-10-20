Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1186063FE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJTPPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiJTPPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:15:41 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350603B987
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:15:27 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 4459 invoked from network); 20 Oct 2022 17:15:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1666278923; bh=fEnzvgcsJeNbZprUh21cKq/9USyvXftXBPCl1AVe/Jk=;
          h=From:To:Cc:Subject;
          b=gHxB2v0TC5KTHeARoHbdR1J9nsxImZ+simA4h1p7+eLoRpQKxKuoawwD4XEN08PCR
           DM2JjkyX4mucggCkalp1oQJeaak7lwkNhpqQ7m4P4ZeWTFcLgJHoq100/OToqXp+XG
           X74WiqsM0cEA+P2PFXiAum2TuQSLfjz93fPY4BPg=
Received: from 89-64-7-202.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.7.202])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <colin.i.king@gmail.com>; 20 Oct 2022 17:15:23 +0200
Date:   Thu, 20 Oct 2022 17:15:22 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     "Colin King (gmail)" <colin.i.king@gmail.com>
Cc:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: wifi: rt2x00: add TX LOFT calibration for MT7620
Message-ID: <20221020151522.GA99236@wp.pl>
References: <01410678-ab7d-1733-8d5a-e06d1a4b6c9e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01410678-ab7d-1733-8d5a-e06d1a4b6c9e@gmail.com>
X-WP-MailID: 78bdfce7f51fbd7d7bf58efa97131f14
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [0SM0]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 02:45:22PM +0100, Colin King (gmail) wrote:
> I noticed a signed / unsigned comparison warning when building linux-next
> with clang. I believe it was introduced in the following commit:
> 
> commit dab902fe1d29dc0fa1dccc8d13dc89ffbf633881
> Author: Tomislav Požega <pozega.tomislav@gmail.com>
> Date:   Sat Sep 17 21:28:43 2022 +0100
> 
>     wifi: rt2x00: add TX LOFT calibration for MT7620
> 
> 
> The warning is as follows:
> 
> drivers/net/wireless/ralink/rt2x00/rt2800lib.c:9472:15: warning: result of
> comparison of constant -7 with expression of type 'char' is always false
> [-Wtautological-constant-out-of-range-compare]
>         gerr = (gerr < -0x07) ? -0x07 : (gerr > 0x05) ? 0x05 : gerr;

This was very currently addressed:
https://lore.kernel.org/linux-wireless/20221019155541.3410813-1-Jason@zx2c4.com/

Regards
Stanislaw
