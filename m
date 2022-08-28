Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD65A3F83
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 21:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiH1TuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 15:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiH1TuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 15:50:11 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239562715;
        Sun, 28 Aug 2022 12:50:07 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1661716204; bh=4VVgZ7rQh5tbYoNVZ4m2rwL1L6QWOYZAwRIkB40h+lg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ud4mWVwyUceYt5Nuc1sVBj1PHwn/GWFzoIu6uvi4AnQm1tPLWwY7nly84CTBYR+nm
         aDKxrvGU3ZbQXJG3qKKOveLHlyInJzMhgdrtXiOHLCBQ1UbhwXv3f6eP06yvPc6bsg
         dCL0cbmtkl6t+XOz5R1yQ7c2CTqKXrZphpj1n/safh9eIw0GBihqSGuP3AGzoxDiC1
         lFtHrsJ+RCta9ldjy01KRIgcqJ0luRdkzdL7WkmfXrfbiFgugruu3vBFr7l1MW9b16
         GSavAPrWk96zebcGYyShGoB8tYNaNP2z+nxUN/kceEQI7r1HdBo3GMPdWDwycC1IM+
         ZFT2tCa+8bVZg==
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Avi Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: taprio vs. wireless/mac80211
In-Reply-To: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
References: <117aa7ded81af97c7440a9bfdcdf287de095c44f.camel@sipsolutions.net>
Date:   Sun, 28 Aug 2022 21:50:04 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ler86tcj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> Anyone have recommendations what we should do?

Given that (presumably?) the use case taprio enables needs special
handling all the way down to the hardware to be able to work at all on
WiFi, why not just make the driver (or mac80211) expose a separate (set
of) netdev queue(s) tied to that handling when prompted to do so?

-Toke
