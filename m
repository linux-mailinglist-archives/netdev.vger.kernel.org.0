Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2B56F1FE6
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346791AbjD1U7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346864AbjD1U6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:58:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173907688;
        Fri, 28 Apr 2023 13:57:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4B9F64581;
        Fri, 28 Apr 2023 20:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187F2C433EF;
        Fri, 28 Apr 2023 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682715438;
        bh=vo6C1yWF0ned5CeZH7bF1cw4zzfUkFcAx8IxP+5XcDc=;
        h=Date:From:To:Subject:From;
        b=ucZSzOa10NAghy+VW1dtKBc6fNaYN2hG9SKunGOmik1XK7+z8+QSCuCV5bze+C1rY
         beyih8BQs0O/gxpk+PBzt9x41aivJg3P4IutDO+XWFpstLo4vosj5DgOelRnHKeIIc
         XvtQQA6R6j+XUgAZpCmlVXye/FiH0HSnntwR+KXY2OOAjVFQwNKteh15Mo+cOJ5bBm
         RoJ6kpSeB973IMzC92JKV460xu7oEno/TQmsZIItuF5CvvGPk94pV4GGKsqsozAPfJ
         zwJDdNCFZ+P+eYkUKmPQUACm4Rmbx0/KjzM5AUlEUO5clV1EnzRvTzDOPoPfqEvaaE
         ZC2mo5nPSm1LA==
Date:   Fri, 28 Apr 2023 13:57:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org
Subject: [ANN] netdev development stats for 6.4
Message-ID: <20230428135717.0ba5dc81@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Stats for 6.4 are here!=20

Changes
-------

You'll notice that the absolute values/scores are a lot smaller,
they are now divided by the number of weeks the cycle had, to make
cycle-to-cycle comparisons easier.=20

There is also info now on how many positions given person moved=20
within the ranking.

Last by not least I thought it could be interesting to look at
histograms of how long have community members been around.=20

As always please feel free to share any feedback / thoughts you have,=20
I can't promise I'll be able to honor requests for _additional_ stats :)
but tweaks or indicating what's helpful and what's not would be great.
Code: https://github.com/kuba-moo/ml-stat

Methodology?
------------

The statistics are based (largely) on mailing list traffic, so they
count emails and postings rather than review tags and commits. Notably
this means we count revisions of a series as separate "threads".
This is because we're trying to measure how the community works,=20
not the outcomes.

We count email traffic (and commits where appropriate) between the
net-next pull requests (from the 6.3 PR to the 6.4 PR this time).

6.4 statistics
--------------

The cycle started on Feb 21 and ended on Apr 26th, it was one week
shorter than the previous cycle.=20

We have seen total of 16529 messages (258 / day) which is 14% more than
last time. However, the number of commits directly applied by netdev
maintainers declined by 4% (a day) for total of 1112 in the cycle.
Higher number of messages is likely due to previous cycle including=20
end of year / winter celebrations.

We have seen 748 people/aliases on the list which is up 2.5% (a day)
from last time. According to my rough count of the 748 people, 341 has
posted patches but never replied to a thread started by another person,
252 were only replying and never posted patches, and 155 did both.

Amazingly the number of commits which go into the tree with at least one
Review/Ack tag has increased further by 10% and is now at 65% (58% of
which do not come from the same email domain as the author). This does
not count review done by the maintainer applying the patch.

Rankings
--------

Top reviewers (thr):                 Top reviewers (msg):               =20
   1 (   ) [44] Jakub Kicinski          1 (   ) [73] Jakub Kicinski     =20
   2 (   ) [33] Simon Horman            2 ( +1) [72] Simon Horman       =20
   3 ( +1) [12] Andrew Lunn             3 ( -1) [29] Andrew Lunn        =20
   4 ( +2) [ 9] Eric Dumazet            4 (   ) [18] Leon Romanovsky    =20
   5 ( -2) [ 8] Leon Romanovsky         5 ( +1) [15] Krzysztof Kozlowski=20
   6 ( +2) [ 7] Krzysztof Kozlowski     6 ( +3) [15] Vladimir Oltean    =20
   7 (+13) [ 6] Florian Fainelli        7 (+22) [14] Florian Fainelli   =20
   8 ( -3) [ 6] Paolo Abeni             8 (   ) [14] Eric Dumazet       =20
   9 ( +3) [ 5] Vladimir Oltean         9 (+18) [13] Jason Wang         =20
  10 (   ) [ 4] Kalle Valo             10 ( +2) [12] Russell King       =20
  11 ( +2) [ 4] Russell King           11 (+14) [ 9] Willem de Bruijn   =20
  12 (+15) [ 4] Willem de Bruijn       12 (+23) [ 8] Stefano Garzarella =20

Simon takes a very strong second position which should not=20
be a surprise to anyone following the list. Florian jumps=20
back into the top 10 (after an absence in 6.3).


Top authors (thr):                   Top authors (msg):                 =20
   1 (   ) [7] Jakub Kicinski           1 ( +1) [24] Saeed Mahameed     =20
   2 ( +4) [4] Eric Dumazet             2 (+18) [23] David Howells      =20
   3 ( -1) [4] Vladimir Oltean          3 (+29) [16] Shannon Nelson     =20
   4 ( -1) [4] Tony Nguyen              4 ( -3) [16] Vladimir Oltean    =20
   5 (***) [3] Arseniy Krasnov          5 ( +2) [15] Daniel Golle       =20
   6 (+22) [3] Pedro Tammela            6 ( -2) [15] Jakub Kicinski     =20
   7 (+33) [3] Daniel Golle             7 ( -2) [13] Tony Nguyen        =20
   8 (***) [2] Zheng Wang               8 (***) [13] Ar=C4=B1n=C3=A7 =C3=9C=
NAL         =20
   9 (+13) [2] Heiner Kallweit          9 (+50) [12] Christian Marangi  =20
  10 (***) [2] Kal Conley              10 (+32) [12] Xuan Zhuo          =20

A lot of movement among patch producers. Apart from "usual suspects"
we see Shannon (new Pensando driver), David H (splice rework), Arseniy
(vsock work), Pedro (TC improvements), Daniel & Arinc (MediaTek DSA),
Christian (LED / PHY integration), Xuan Zhuo (virtio cleanup & XDP work).


I will skip individual scores this time because they look _very_ much
like the top reviewers in positive and top authors in negative.=20
Maybe I need to change the formula to catch something interesting...

Company rankings
----------------

Top reviewers (thr):                 Top reviewers (msg):               =20
   1 (   ) [47] Meta                    1 (   ) [80] Meta               =20
   2 ( +4) [33] Corigine                2 ( +3) [72] Corigine           =20
   3 ( -1) [22] Intel                   3 ( -1) [48] Intel              =20
   4 (   ) [19] RedHat                  4 ( -1) [44] RedHat             =20
   5 (   ) [17] Google                  5 ( +2) [32] Google             =20
   6 ( -3) [13] nVidia                  6 (   ) [29] Andrew Lunn        =20
   7 (   ) [12] Andrew Lunn             7 ( -3) [28] nVidia             =20

Corigine takes #2 spot, thanks to impressive work from Simon,
congrats! nVidia continues to slip for the second cycle in a row.


Top authors (thr):                   Top authors (msg):                 =20
   1 (   ) [19] RedHat                  1 ( +1) [79] RedHat             =20
   2 ( +1) [13] Intel                   2 ( -1) [58] nVidia             =20
   3 ( +2) [10] Meta                    3 (   ) [44] Intel              =20
   4 ( -2) [10] nVidia                  4 ( +4) [39] AMD                =20
   5 ( -1) [ 9] Google                  5 ( +4) [24] Google             =20
   6 (   ) [ 7] NXP                     6 ( +1) [23] Meta               =20
   7 ( +2) [ 5] AMD                     7 ( -3) [23] NXP                =20

RedHat takes #1 code producing spot, likely due to David H's work.


Top scores (positive):               Top scores (negative):             =20
   1 (   ) [590] Meta                   1 (***) [15] TI                 =20
   2 ( +3) [464] Corigine               2 (***) [12] AMD                =20
   3 ( -1) [258] Intel                  3 ( -1) [11] Alibaba            =20
   4 ( +3) [200] Google                 4 (***) [10] Sberdevices        =20
   5 ( -2) [180] RedHat                 5 (+50) [ 8] Zheng Wang         =20
   6 (   ) [169] Andrew Lunn            6 (***) [ 8] Dectris            =20
   7 ( -3) [129] nVidia                 7 ( -6) [ 8] Marvell            =20
   8 (   ) [125] Linaro                =20
   9 ( +3) [111] Broadcom              =20
  10 ( +5) [ 64] NXP                  =20
  11 ( -2) [ 57] Oracle               =20
  12 ( +2) [ 54] Isovalent            =20
  13 (***) [ 52] Qualcomm             =20
  14 (+20) [ 48] Microchip            =20
  15 (***) [ 41] Huawei               =20

The positive participation scores reflect the reviewer activity.
Florian puts Broadcom in the top 10. NXP reenters top 10 as well thanks
to Vladimir's work (or perhaps just a code vs review balance shift ;)).
It's great to see Microchip making an appearance on the left (review=20
work of Horatiu, and Steen). Qualcomm is here because I fixed Kalle's
corporate mapping :) Huawei is Yunsheng Lin.

On the "bad" side the only constants are Alibaba and Marvell, who
continue to contribute code but do not participate in reviewing=20
the work of others :(

Histograms!
-----------

I was wondering about the distribution of "tenure" in the community.
Are we relying on "old timers" to review the code? Are the "old timers"
still coding? Do we have any new participants at all?

The statistics are calculated by measuring the time distance since first
authored commit in the tree. The bucketing is a bit odd, first buckets
are short term and in power of 2 (*), later are in 2 year spans (#).
The histograms should have the same scale so that comparing across
categories is legit.

Tenure for reviewer
 0- 3mo   |   2 | *
 3- 6mo   |   3 | **
6mo-1yr   |   9 | *******
 1- 2yr   |  23 | ******************
 2- 4yr   |  33 | ##########################
 4- 6yr   |  43 | ##################################
 6- 8yr   |  36 | #############################
 8-10yr   |  40 | ################################
10-12yr   |  31 | #########################
12-14yr   |  33 | ##########################
14-16yr   |  31 | #########################
16-18yr   |  46 | #####################################
18-20yr   |  49 | #######################################

Tenure for author
 0- 3mo   |  40 | **************************
 3- 6mo   |  15 | **********
6mo-1yr   |  23 | ***************
 1- 2yr   |  49 | ********************************
 2- 4yr   |  47 | ###############################
 4- 6yr   |  50 | #################################
 6- 8yr   |  31 | ####################
 8-10yr   |  33 | #####################
10-12yr   |  19 | ############
12-14yr   |  25 | ################
14-16yr   |  22 | ##############
16-18yr   |  32 | #####################
18-20yr   |  31 | ####################

Unsurprisingly in the "recent" buckets are sparse for reviewers and
more filled for authors. There's an interesting grouping of authors=20
in the 1-6yr region. Perhaps it takes a year to become efficient and
5 more years to give up? :) The 4-6yr bucket is also active on the
reviewer side but there's a much stronger showing for the oldest
16-20yr category in terms of reviews.

Note that these are stats of the number of people, not activity.
Activity looked fairly similar.
