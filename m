Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBFD5F4F12
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 06:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJEE11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 00:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJEE10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 00:27:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E935D6B8D1
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 21:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90117B81C23
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 04:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F42C433D6
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 04:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664944042;
        bh=gSoMBoGZS/+PSxWpSulKBBNiStdFZpT6ZdZVIP7o194=;
        h=Date:From:To:Subject:From;
        b=shxH23uPJ2l2eiCs4Hs0zZvVz05kD1p2QCTt0jWj5JOO/B0TOwNM7D0k+6ns1ktGH
         pA9X2yNDzgLGvv5rlhoJzpYougcgINwj71253NZtwJfRlAeJRnnocI/xSrzHFmODcV
         +ujHA9CoCbmywyH4xue/lnXiLcx6483bRem88cYqXBbMtZVIi5Pwqpz1uQquK4o1YB
         J+HmfdemlbNLCeAiGFQsyDweuR2FGN7ghy6tS2gSoDA9LTC+O8S6nLAxWMDhOqjlIQ
         P7IVYN8knIPYyfzrLjaE3c95OmkHmIhqCo+KPBTQMHfApwWD9Gwi4JMNsK6g8kbRD9
         i+ubWitlRCWTQ==
Date:   Tue, 4 Oct 2022 21:27:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Subject: netdev development stats for 6.1?
Message-ID: <20221004212721.069dd189@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

For a while now I had been curious if we can squeeze any interesting
stats from the ML traffic. In particular I was curious "who is helping",
who is reviewing the most patches (but based on the emails sent not just
review tags).

I quickly wrote a script to scan emails sent to netdev since 5.19 was
tagged (~14k) and count any message which has subject starting with
'[' as a patch and anything else as a comment/review. It's not very
scientific but the result for the most part matches my expectations.

A disclaimer first - this methodology puts me ahead because I send
a lot of emails. Most of them are not reviews, so ignore me.

Second question to address upfront is whether publishing stats is
useful or mostly risks people treating participation as a competition
and trying to game the system? Hard to say, but if even a single person
can point to these stats to help justify more time spent reviewing to
their management - it's worth it.

That said feedback is very welcome, public or private.


The stats are by number of threads and number of messages.

 Top 10 reviewers (thr):            Top 10 reviewers (msg):
   1. [320] Jakub Kicinski            1. [538] Jakub Kicinski
   2. [134] Andrew Lunn               2. [263] Andrew Lunn
   3. [ 51] Krzysztof Kozlowski       3. [122] Krzysztof Kozlowski
   4. [ 51] Paolo Abeni               4. [ 80] Rob Herring
   5. [ 47] Eric Dumazet              5. [ 78] Eric Dumazet
   6. [ 46] Rob Herring               6. [ 70] Paolo Abeni
   7. [ 35] Florian Fainelli          7. [ 65] Vladimir Oltean
   8. [ 35] Kalle Valo                8. [ 58] Ido Schimmel
   9. [ 32] David Ahern               9. [ 58] Michael S. Tsirkin
  10. [ 31] Vladimir Oltean          10. [ 57] Russell King


These seem to make sense, but the volume-centric view shows.
Note that the numbers are very close so the exact order is
of little importance. The names should be familiar to everyone,
I hope :)


 Top 10 authors (thr):              Top 10 authors (msg):
   1. [ 84] Zhengchao Shao            1. [287] Zhengchao Shao=20
   2. [ 52] Vladimir Oltean           2. [232] Vladimir Oltean=20
   3. [ 43] Jakub Kicinski            3. [166] Saeed Mahameed=20
   4. [ 28] Tony Nguyen               4. [156] Kuniyuki Iwashima=20
   5. [ 28] cgel.zte@gmail.com        5. [134] Sean Anderson
   6. [ 23] Stephen Rothwell          6. [122] Oleksij Rempel
   7. [ 23] Hangbin Liu               7. [106] Tony Nguyen
   8. [ 20] Wolfram Sang              8. [ 93] Mattias Forsblad=20
   9. [ 20] Kuniyuki Iwashima         9. [ 93] Jian Shen=20
  10. [ 20] Jiri Pirko               10. [ 86] Jakub Kicinski


Here Stephen is probably by accident as I was counting his merge
resolutions as patches.

What is clear tho (with the notable exception of Vladimir)
- most of the authors are not making the top reviewer list :(


And here is the part that I was most curious about.
Calculate a "score" which is roughly:
   10 * reviews - 3 * authorship,
to see who is a "good citizen":

 Top 10 scores (positive):          Top 10 scores (negative):
   1. [4102] Jakub Kicinski           1. [397] Zhengchao Shao
   2. [1848] Andrew Lunn              2. [116] Kuniyuki Iwashima
   3. [737] Krzysztof Kozlowski       3. [105] cgel.zte@gmail.com
   4. [620] Paolo Abeni               4. [ 93] Mattias Forsblad
   5. [611] Rob Herring               5. [ 82] Yang Yingliang
   6. [588] Eric Dumazet              6. [ 82] Sean Anderson
   7. [429] Florian Fainelli          7. [ 77] Daniel Lezcano=20
   8. [418] Kalle Valo                8. [ 68] Stephen Rothwell=20
   9. [406] David Ahern               9. [ 67] Arun Ramadoss=20
  10. [344] Russell King             10. [ 64] Wang Yufen


Now looking at companies.

[Using my very rough mapping of people to company based on email=20
domain and manual mapping for major contributors]

 Top 7 reviewers (thr):     Top 7 reviewers (msg):
   1. [369] Meta              1. [640] Meta
   2. [139] Intel             2. [306] RedHat
   3. [134] Andrew Lunn       3. [263] Andrew Lunn=20
   4. [127] RedHat            4. [243] Intel
   5. [ 80] nVidia            5. [193] nVidia
   6. [ 71] Google            6. [134] Linaro
   7. [ 61] Linaro            7. [121] Google

 Top 8 authors (thr):       Top 7 authors (msg):=20
   1. [207] Huawei            1. [640] Huawei
   2. [103] nVidia            2. [496] nVidia
   3. [ 96] Intel             3. [342] Intel
   4. [ 94] RedHat            4. [332] RedHat
   5. [ 75] Google            5. [263] NXP
   6. [ 60] Microchip         6. [170] Linaro
   7. [ 59] NXP               7. [157] Amazon
   8. [ 51] Meta          =20

Top 12 scores (positive):     Top 12 scores (negative):
   1. [4763] Meta               1. [887] Huawei
   2. [1848] Andrew Lunn        2. [145] Microchip
   3. [1432] RedHat             3. [105] ZTE
   4. [1415] Intel              4. [ 95] Amazon
   5. [ 680] Linaro             5. [ 93] Mattias Forsblad
   6. [ 652] Google             6. [ 68] Stephen Rothwell
   7. [ 627] nVidia             7. [ 59] Wolfram Sang
   8. [ 609] Rob Herring        8. [ 57] wei.fang@nxp.com
   9. [ 429] Florian Fainelli   9. [ 56] Ar=C4=B1n=C3=A7 =C3=9CNAL
  10. [ 418] Kalle Valo        10. [ 53] Sean Anderson
  11. [ 368] Russell King      11. [ 48] Maxime Chevallier
  12. [ 356] David Ahern       12. [ 46] Jianguo Zhang


The bot operators top the list of "bad citizens" as they do not
contribute to the review process. Microchip and Amazon also seem=20
to send a lot more code than they help to review.

Huge *thank you* to all the reviewers!
