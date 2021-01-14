Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD7D2F56A4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbhANBuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbhANBuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:50:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 635F42343B;
        Thu, 14 Jan 2021 01:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610588964;
        bh=2ccZHLU4CWXsqjnD9/TJOJPYJ2TLtOTn2NRJySDvYz0=;
        h=From:To:Cc:Subject:Date:From;
        b=CvhUhzsBL8Vdap758YpHva1hOH14DO98pB9YUk+gxGmtEOy6zu4+GKYr0T9BauM7b
         OIAyElJlpEO0sY0ZqUtI3hqcZqGxMAxiHM29lhHjulYgnqo6Ao81lmTnGMqRSylA8i
         NAUAgxLZc6LlGDTSt2g+w75VMm2YuZ0FP0HQ3yk9krOUSxyiIzRtS7WNOYz4+nEswi
         w0/rtPZd/Pag/vtyotTGiOTlp8ILwT3TSRSlKMN2sD7uyhL3QjpXVeL4KpSzo47cm7
         Hpv1kg2YFqyC7IaSZ24r0VwXB+xZoh1xQRL+4ZS3OvOc9II/jSQFcCq/Rg4E8w6/86
         +l6lO4RgMdNpg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 0/7] MAINTAINERS: remove inactive folks from networking 
Date:   Wed, 13 Jan 2021 17:49:05 -0800
Message-Id: <20210114014912.2519931-1-kuba@kernel.org>
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
 - Felix Fietkau (mtk-eth)
 - Mirko Linder (skge/sky2)

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

v2:
 - keep Felix and Mirko

Jakub Kicinski (7):
  MAINTAINERS: altx: move Jay Cliburn to CREDITS
  MAINTAINERS: net: move Alexey Kuznetsov to CREDITS
  MAINTAINERS: vrf: move Shrijeet to CREDITS
  MAINTAINERS: ena: remove Zorik Machulsky from reviewers
  MAINTAINERS: tls: move Aviad to CREDITS
  MAINTAINERS: ipvs: move Wensong Zhang to CREDITS
  MAINTAINERS: dccp: move Gerrit Renker to CREDITS

 CREDITS     | 24 ++++++++++++++++++++++++
 MAINTAINERS |  9 +--------
 2 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.26.2

