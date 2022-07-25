Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EEA58033D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbiGYRCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiGYRCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:02:50 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFF1B876
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 10:02:47 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 7474 invoked from network); 25 Jul 2022 19:02:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1658768564; bh=jZl6nmbwdbhYiW5mJjTv3vyZliHhWUIo2ivhXQ0y+Pg=;
          h=From:To:Cc:Subject;
          b=edtMkbOVm74DvTmD0kYjSk2tEzAPXV6hVJuIWp+sydlGE3bnkUTxZpKBtjB/7FhLi
           OIWlyAwWRUFAaNCSEJduOXSEYyRmO0DKPAL49dt4JWbTGB1NCIc3t0wc5ZWE9OOVOs
           CsxzIE+EqJi3IlfujDZKCj9C/jLcKl4vEWAPG6AY=
Received: from unknown (HELO kicinski-fedora-PC1C0HJN) (kubakici@wp.pl@[163.114.132.128])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <amadeus@jmu.edu.cn>; 25 Jul 2022 19:02:43 +0200
Date:   Mon, 25 Jul 2022 10:02:35 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Chukun Pan <amadeus@jmu.edu.cn>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lintel Huang <lintel.huang@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt7601u: Add AP mode support
Message-ID: <20220725100235.2a6d0ee8@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220725161603.15201-1-amadeus@jmu.edu.cn>
References: <20220725161603.15201-1-amadeus@jmu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: ebff1ada147d0a9580d9a20cd51d747d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [cUNk]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 00:16:03 +0800 Chukun Pan wrote:
> Add AP mode support to mt7601u chipset.
> Simply tested it with firmware version
> 201302052146 and it seems working fine.

The chipset does not support CAB properly, trying to run APs on it is 
a waste of everyone's time. Just buy better HW if you need AP mode.
These are $5 dongles so I hope the suggestion is acceptable.
