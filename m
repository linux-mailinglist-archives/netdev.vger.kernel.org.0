Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544C860EDD1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 04:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiJ0CNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 22:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiJ0CNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:13:20 -0400
X-Greylist: delayed 19194 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Oct 2022 19:13:18 PDT
Received: from 19.mo581.mail-out.ovh.net (19.mo581.mail-out.ovh.net [178.33.251.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD69E52EF
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 19:13:18 -0700 (PDT)
Received: from player697.ha.ovh.net (unknown [10.109.146.32])
        by mo581.mail-out.ovh.net (Postfix) with ESMTP id 59FE422ED8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:15:17 +0000 (UTC)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player697.ha.ovh.net (Postfix) with ESMTPSA id 93D7E3023A29A;
        Wed, 26 Oct 2022 20:15:10 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-102R004942e3b79-1ee2-40b7-a635-651feff5914f,
                    8F04C294CDB50EE67E28FDC8B80665AEEC511E10) smtp.auth=rafal@milecki.pl
X-OVh-ClientIp: 194.187.74.233
Message-ID: <fcb5a26c-bfd7-3492-a870-29ee447905b6@milecki.pl>
Date:   Wed, 26 Oct 2022 22:15:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: report queued and
 transmitted bytes
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
References: <20221026142624.19314-1-zajec5@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
In-Reply-To: <20221026142624.19314-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10760506887954213722
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrtddvgddugeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeftrghfrghlucfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpeeuleetudfgkeevfffggeffveevleeutdekkeejueekveevtefhhfegveeggefhudenucfkphepuddvjedrtddrtddruddpudelgedrudekjedrjeegrddvfeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeorhgrfhgrlhesmhhilhgvtghkihdrphhlqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheekuddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.10.2022 16:26, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows BQL to operate avoiding buffer bloat and reducing latency.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Please drop it, I'll work on V2.
