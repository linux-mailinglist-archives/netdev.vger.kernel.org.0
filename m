Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA925974DF
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiHQRMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbiHQRMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:12:44 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729216B174;
        Wed, 17 Aug 2022 10:12:43 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oOMau-0002nC-Tu; Wed, 17 Aug 2022 19:12:41 +0200
Message-ID: <f1a68bf1-2fc3-48f9-520f-2343e20c9bfc@leemhuis.info>
Date:   Wed, 17 Aug 2022 19:12:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: Bug 216320 - KSZ8794 operation broken
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, craig@mcqueen.id.au,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>
References: <967ef480-2fac-9724-61c7-2d5e69c26ec3@leemhuis.info>
 <20220817140406.jqv72rkpro5gmgvu@skbuf>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220817140406.jqv72rkpro5gmgvu@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1660756363;e0f7c7db;
X-HE-SMSGID: 1oOMau-0002nC-Tu
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.08.22 16:04, Vladimir Oltean wrote:
> On Wed, Aug 17, 2022 at 03:36:44PM +0200, Thorsten Leemhuis wrote:
>> I noticed a regression report in bugzilla.kernel.org that afaics nobody
>> acted upon since it was reported. That's why I decided to forward it by
>> mail to those that afaics should handle this.
> 
> Thanks. I don't track bugzilla,

No worries, that's not unusual (or I guess: pretty common).

> but I will respond to this ticket.
> Is there a way to get automatically notified of DSA related issues?

I assume in theory it would be possible to create a product for this
case in bugzilla.kernel.org and then you could directly (if you become
the default assignee) or indirectly (virtual user you could then could
start to watch) be notified.

In practice that is rarely done afaik.

My plan is to discuss bugzilla.kernel.org handling next month on
kernel/maintainers summit. Maybe we decide something there to improve
things. I'd say: wait for it and continue to no track bugzilla for now,
as https://docs.kernel.org/admin-guide/reporting-issues.html clearly
tells people to not file bugs there, unless MAINTAINERS tells them to
(which is not the case here afaik).

Ciao, Thorsten
