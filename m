Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17264E5D2
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 03:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiLPCGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 21:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiLPCGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 21:06:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306641F2CB
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 18:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F90C61EB8
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 02:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8F2C433D2
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 02:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671156369;
        bh=AELH0oR7rpjY3ZaGD/Lokvyg5l87v5d5GLjWhXE1NK8=;
        h=Date:From:To:Subject:From;
        b=A/tbPjNt6RjDycqiEUtLFd2B1XvhOrC+8tSWsZY67Ug7Xhy4UoKDaQ1ehiIukXQQH
         Wkk4CfYnCxaxH8TBcqZsEYTprxFgzqyaoSzsbv9K9WFAwl7pvoZQSOf7E4TQ0tr6+x
         U2791sppCb6eHgJwkne3TlpGoqcfwVR+HO2NsTJI2lxyt/gjeBpoMrCVhFnx9CvKmf
         PR76sBoKxZFHCqSv5EXkTWeWqgjL1eP2tfJMHmMaVptM3IP5dF9mTvvZ+7McIGmPhK
         Q43jt2CGY2Bt4utGTefKlxqybbF8MdH43pIgBGJjwnr404ifMkOwk3oJA2EInKp7Fr
         M7Zta2sQWWlyA==
Date:   Thu, 15 Dec 2022 18:06:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [ANN] netdev development stats for 6.2
Message-ID: <20221215180608.04441356@kernel.org>
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

Here are the stats for the last release cycle (based on 18k emails
netdev has seen since Oct 3rd).

The methodology has not changed since the last time I shared those:
https://lore.kernel.org/all/20221004212721.069dd189@kernel.org/
I have now put the script up on GitHub for everyone to see / improve 
/ hack on: https://github.com/kuba-moo/ml-stat

When comparing the stats note that we had roughly 4k more messages,
partially due to the length of the analyzed period.

Like previously, please discount my "reviews" slightly as I send 
a lot of "process" emails..


Top 10 reviewers (thr):			Top 10 reviewers (msg):
   1. [354] Jakub Kicinski		   1. [582] Jakub Kicinski
   2. [171] Andrew Lunn			   2. [325] Andrew Lunn
   3. [140] Leon Romanovsky		   3. [263] Leon Romanovsky
   4. [ 88] Eric Dumazet		   4. [196] Vladimir Oltean
   5. [ 88] Paolo Abeni			   5. [154] Eric Dumazet
   6. [ 76] Vladimir Oltean		   6. [149] Jiri Pirko
   7. [ 60] Jiri Pirko			   7. [121] Krzysztof Kozlowski
   8. [ 57] Krzysztof Kozlowski		   8. [118] Russell King
   9. [ 53] Russell King		   9. [116] Paolo Abeni
  10. [ 47] Saeed Mahameed		  10. [ 86] Florian Fainelli

The review count went up quite a bit for everyone but Krzysztof and
myself. Andrew remains firmly our top reviewer. We can see a
significant increase in participation from nVidia.


Top 15 authors (thr):			Top 10 authors (msg):
   1. [ 65] Zhengchao Shao		   1. [234] Saeed Mahameed
   2. [ 58] Jakub Kicinski		   2. [182] David Howells
   3. [ 57] Yang Yingliang		   3. [146] Tony Nguyen
   4. [ 44] Kees Cook			   4. [140] Jakub Kicinski 
   5. [ 32] Eric Dumazet		   5. [125] Marc Kleine-Budde
   6. [ 32] Vladimir Oltean		   6. [119] Ido Schimmel
   7. [ 26] Yuan Can			   7. [113] Leon Romanovsky
   8. [ 26] Kumar, M Chetan		   8. [111] Steen Hegelund
   9. [ 26] Dan Carpenter		   9. [ 96] Vladimir Oltean
  10. [ 26] Xin Long			  10. [ 94] Yang Yingliang

Where we count "authorship" by a fresh posting of a patch to the list.
So Saeed gets credit for all revisions of all patches that came thru
his tree, for example.


As for "scores" which are supposed to point out who doesn't help 
with reviewing (10 * reviews - 3 * authorship):

 Top 10 scores (positive):		Top 10 scores (negative):
   1. [4458] Jakub Kicinski		   1. [240] Zhengchao Shao
   2. [2355] Andrew Lunn		   2. [206] Yang Yingliang 
   3. [1808] Leon Romanovsky		   3. [ 96] Yuan Can
   4. [1069] Paolo Abeni		   4. [ 87] Zhang Changzhong
   5. [1058] Eric Dumazet		   5. [ 87] Wang Yufen
   6. [1006] Vladimir Oltean		   6. [ 84] Lorenzo Bianconi
   7. [ 809] Jiri Pirko			   7. [ 82] Michal Wilczynski
   8. [ 765] Krzysztof Kozlowski	   8. [ 82] Colin Ian King 
   9. [ 700] Russell King		   9. [ 80] Shenwei Wang
  10. [ 561] Rob Herring		  10. [ 73] YueHaibing

The positive section looks very much like the top reviewer section.

Kuniyuki has become an active reviewer of the socket layer (thanks!!)
therefore taking Amazon off the negative scores. Now the top three
negative scores belong to people sending semi-automated "bug fixes".


As for the corporate stats:

Top 10 reviewers (thr):			Top 10 reviewers (msg):
   1. [398] Meta			   1. [746] Meta
   2. [260] nVidia			   2. [594] nVidia
   3. [212] Intel			   3. [427] Intel
   4. [174] RedHat			   4. [387] RedHat
   5. [171] Andrew Lunn			   5. [325] Andrew Lunn
   6. [141] Google			   6. [279] Google
   7. [ 83] NXP				   7. [210] NXP

Top 15 authors (thr):			Top 10 authors (msg):
   1. [366] Huawei			   1. [705] nVidia
   2. [184] Intel			   2. [554] Huawei
   3. [136] RedHat			   3. [554] Intel
   4. [123] Google			   4. [485] RedHat
   5. [113] nVidia			   5. [410] Microchip
   6. [ 90] Microchip			   6. [256] Pengutronix
   7. [ 68] Meta			   7. [254] Google

Top 15 scores (positive):		Top 15 scores (negative):
   1. [5179] Meta			   1. [1131] Huawei
   2. [3095] nVidia			   2. [ 217] Microchip
   3. [2355] Andrew Lunn 		   3. [  96] ZTE
   4. [2143] Intel			   4. [  82] Alibaba
   5. [1862] RedHat			   5. [  82] Colin Ian King
   6. [1470] Google			   ... one-time contributors follow
   7. [ 985] NXP
   8. [ 835] Linaro
   9. [ 755] Oracle
  10. [ 694] Isovalent
  11. [ 561] Rob Herring
  12. [ 560] Florian Fainelli


Significant increase in activity from nVidia, both in terms of
authorship (1.5x) and reviews (3x).

Huawei leads the pack in terms of patch bombardment with no real
participation. Interestingly Microchip remains in the #2 spot of 
the negative score list.
