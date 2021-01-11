Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A817C2F0C80
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbhAKF2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbhAKF2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:28:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFD7A224B0;
        Mon, 11 Jan 2021 05:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342883;
        bh=ooDEkw0UM2LGjmds2qRU5wbLusgsXo1lss9k8agumxI=;
        h=From:To:Cc:Subject:Date:From;
        b=iLIJzyxUlU4vquL9o1PwFWXTDWRILwqbdBoliM1MdlIR4X3umoBqmsYXpyC+C0FdN
         Tb63oJF/ZnL7kDSdelyT3oqnWiPBBTJAOh86o64jH4rEoak5qDsFFxvRfrJyLTJxQa
         e8aZZASl/rLoZArIf0wsYq3YhG36kziozMI3yKgoJeoLI+hoLCiHHJAmhfmNAsoong
         Nlx6cD2lJGyAZRTT/QCDUS6zponXMqw7hNZr0Mm4yTmW8NnVf2NleS1HC8Dc1FteeB
         d/9SV06jgMR9P7Z1Fl4axM/gqBOKlpZaALLo6bttRB35xQCwTvCw8d7VSCUSrUaiCr
         p7x2thZGJcDyQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/9] MAINTAINERS: remove inactive folks from networking 
Date:   Sun, 10 Jan 2021 21:27:50 -0800
Message-Id: <20210111052759.2144758-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series intends to remove some most evidently inactive maintainers.

To make maintainers' lives easier we're trying to nudge people
towards CCing all the relevant folks on patches, in an attempt
to improve review rate. We have a check in patchwork which validates
the CC list against get_maintainers.pl. It's a little awkward, however,
to force people to CC maintainers who we haven't seen on the mailing
list for years. This series removes from maintainers folks who didn't
provide any tag (incl. authoring a patch) in the last 5 years.
To ensure reasonable signal to noise ratio we only considered
MAINTAINERS entries which had more than 100 patches fall under
them in that time period.

All this is purely a process-greasing exercise, I hope nobody
sees this series as an affront. Most folks are moved to CREDITS,
a couple entries are simply removed. 

The following inactive maintainers are kept, because they indicated
the intention to come back in the near future:

 - Veaceslav Falico (bonding)
 - Christian Benvenuti (Cisco drivers)

Patches in this series contain report from a script which did
the analysis. Big thanks to Jonathan Corbet for help and writing
the script (although I feel like I used it differently than Jon
may have intended ;)). The output format is thus:

 Subsystem $name
  Changes $reviewed / $total ($percent%)           // how many changes to the subsystem had at least one ack/review
  Last activity: $date_of_most_recent_patch
  $maintainer/reviewer1:
    Author $last_commit_authored_by_the_person $how_many_in_5yrs
    Committer $last_committed $how_many
    Tags $last_tag_like_review_signoff_etc $how_many
  $maintainer/reviewer2:
    Author $last_commit_authored_by_the_person $how_many_in_5yrs
    Committer $last_committed $how_many
    Tags $last_tag_like_review_signoff_etc $how_many
  Top reviewers: // Top 3 reviewers (who are not listed in MAINTAINERS)
    [$count_of_reviews_and_acks]: $email
  INACTIVE MAINTAINER $name   // maintainer / reviewer who has done nothing in last 5yrs

Jakub Kicinski (9):
  MAINTAINERS: altx: move Jay Cliburn to CREDITS
  MAINTAINERS: net: move Alexey Kuznetsov to CREDITS
  MAINTAINERS: vrf: move Shrijeet to CREDITS
  MAINTAINERS: ena: remove Zorik Machulsky from reviewers
  MAINTAINERS: tls: move Aviad to CREDITS
  MAINTAINERS: mtk-eth: remove Felix
  MAINTAINERS: ipvs: move Wensong Zhang to CREDITS
  MAINTAINERS: dccp: move Gerrit Renker to CREDITS
  MAINTAINERS: skge/sky2: move Mirko Lindner to CREDITS

 CREDITS     | 28 ++++++++++++++++++++++++++++
 MAINTAINERS | 11 +----------
 2 files changed, 29 insertions(+), 10 deletions(-)

-- 
2.26.2

