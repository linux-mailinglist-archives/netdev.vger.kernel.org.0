Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DFF69ECB5
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjBVCID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjBVCIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:08:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E618E23659
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 18:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 732E1B811BC
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 02:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01F3C433D2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 02:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677031678;
        bh=0RJeyOC+AFw6CjUl6t7Uxw1bGEEVBzf0o26V0Gth8dw=;
        h=Date:From:To:Subject:From;
        b=O7L94PmoGGkiIx2rKg1U3pyi7QGG5M+643Ss2qGeaBAalNvyse8jmVKpghfhAc/MJ
         nfN5Kk4zp5OLaYXkjOs4e+05j3q+dhyqMD+DFFUyKCOJtW9VeCBOBdf3wvXe1GwkMc
         cqTSSzGt+KR0h8QwZl08FfLD2olRP0CZ0QsBlIc7KZSgjtrJG3nmnBwVYYZXxrut3E
         Uwui/+izD9wkKG2uQ85Uv+JseJr6yGzzT482lx69RspVn6avNCZAu9x9W4rqmwfwvi
         s4m7QcfAFsLp4Xm+oMkwSBEia3W+2cMq1+NpefrUcuwdcJfmZeDaYYtk7bhr5crWVv
         D2XMQy7dM459w==
Date:   Tue, 21 Feb 2023 18:07:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Subject: [ANN] netdev development stats for 6.3
Message-ID: <20230221180756.0964fb2f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Here are the stats for the last release cycle: based on 15,383 emails
netdev has seen since Dec 15th, over 68 days (226 msgs / day).

Roughly 55% of the patches merged had a review tag (4% of which were
exclusively from the same email domain as the author). This means
an increase of 7% compared to the previous cycle (from 48%).

When comparing the stats note the fluctuation in total number of
messages (6.2 cycle had roughly 3k more messages).


Top 10 reviewers (thr):               Top 10 reviewers (msg):
   1. [276] Jakub Kicinski              1. [453] Jakub Kicinski 
   2. [118] Simon Horman                2. [234] Andrew Lunn
   3. [105] Leon Romanovsky             3. [232] Simon Horman
   4. [104] Andrew Lunn                 4. [184] Leon Romanovsky
   5. [ 88] Paolo Abeni                 5. [162] Jiri Pirko
   6. [ 62] Eric Dumazet                6. [125] Krzysztof Kozlowski
   7. [ 61] Jiri Pirko                  7. [121] Paolo Abeni
   8. [ 51] Krzysztof Kozlowski         8. [105] Eric Dumazet
   9. [ 43] Kalle Valo                  9. [102] Vladimir Oltean
  10. [ 42] Alexander Lobakin          10. [ 91] Michael S. Tsirkin

Simon (and Olek) were noticeably more active in this release cycle.
Russell has dropped out (he mentioned battling COVID).


Top 10 authors (thr):                 Top 10 authors (msg):
   1. [ 44] Jakub Kicinski              1. [283] Vladimir Oltean
   2. [ 41] Vladimir Oltean             2. [211] Saeed Mahameed
   3. [ 35] Tony Nguyen                 3. [184] Oleksij Rempel
   4. [ 33] Lorenzo Bianconi            4. [172] Jakub Kicinski
   5. [ 27] Stephen Rothwell            5. [145] Tony Nguyen
   6. [ 27] Eric Dumazet                6. [127] Lorenzo Bianconi
   7. [ 24] Arnd Bergmann               7. [126] Daniel Golle
   8. [ 21] Horatiu Vultur              8. [114] Jiri Pirko
   9. [ 18] Saeed Mahameed              9. [104] Aurelien Aptel
  10. [ 18] Jiri Pirko                 10. [100] Paul Blakey

Vladimir claims the top author spot continuing work on TSN (taprio, 
mqprio, MAC Merge uAPI and driver support).

Stephen Rothwell takes spot number 5, meaning we must have had 27
merge conflicts, lets try to have fewer conflicts going forward...

As for "scores" which are supposed to point out who doesn't help 
with reviewing (10 * reviews - 3 * authorship):

Top 10 scores (positive):             Top 10 scores (negative):
   1. [3446] Jakub Kicinski             1. [140] Lorenzo Bianconi
   2. [1590] Simon Horman               2. [ 91] Paul Blakey
   3. [1482] Andrew Lunn                3. [ 87] Oleksij Rempel
   4. [1336] Leon Romanovsky            4. [ 84] Stephen Rothwell
   5. [1069] Paolo Abeni                5. [ 83] Daniel Golle
   6. [ 821] Jiri Pirko                 6. [ 75] Alejandro Lucero
   7. [ 751] Krzysztof Kozlowski        7. [ 71] Yoshihiro Shimoda
   8. [ 720] Eric Dumazet               8. [ 66] Aurelien Aptel
   9. [ 559] Russell King               9. [ 60] Jason Xing
  10. [ 552] Alexander Lobakin         10. [ 58] Piergiorgio Beruto

Lorenzo, Paul and Oleksij author much more than they review :)
Although in all fairness most folks on the list are there due
to reving the same series rather than generating a lot of code.

Interestingly the flow of semi-automated trivial patches seem 
to have slowed down significantly (authors of those previously
occupied most of the top 5 spots).


As for the corporate stats:

Top 7 reviewers (thr):                Top 7 reviewers (msg):
   1. [340] Meta                        1. [623] Meta
   2. [210] Intel                       2. [463] Intel
   3. [191] nVidia                      3. [439] RedHat
   4. [178] RedHat                      4. [437] nVidia
   5. [125] Google                      5. [238] Corigine
   6. [120] Corigine                    6. [234] Andrew Lunn
   7. [104] Andrew Lunn                 7. [225] Google

Intel takes the #2 spot from nVidia. Corigine makes an appearance 
thanks to Simon's work.

Top 7 authors (thr):                  Top 7 authors (msg):
   1. [142] RedHat                      1. [923] nVidia
   2. [137] nVidia                      2. [445] RedHat
   3. [128] Intel                       3. [406] Intel 
   4. [ 77] Google                      4. [324] NXP
   5. [ 60] Meta                        5. [271] Microchip
   6. [ 58] NXP                         6. [268] Pengutronix
   7. [ 54] Microchip                   7. [213] Meta

Top 12 scores (positive):             Top scores (negative):
   1. [4358] Meta                       1. [127] Marvell
   2. [2437] Intel                      2. [120] Alibaba
   3. [2008] RedHat                     ...
   4. [1910] nVidia                     5. [ 71] Bootlin
   5. [1622] Corigine                   ...
   6. [1482] Andrew Lunn                8. [ 52] Renesas
   7. [1371] Google                     9. [ 51] ZTE
   8. [ 916] Linaro                     ... one-time contributors follow
   9. [ 741] Oracle
  10. [ 504] Kalle Valo
  11. [ 498] Rob Herring
  12. [ 489] Broadcom

Positive scores mostly match the review ranking (with RedHat jumping
to #3, given nVidia's large patch volume). As mentioned bots have
mostly disappeared in this release cycle, Marvell and Alibaba are 
the top "net negative" contributors in terms of reviews. Microchip 
has dropped off the negative list.

Code: https://github.com/kuba-moo/ml-stat
