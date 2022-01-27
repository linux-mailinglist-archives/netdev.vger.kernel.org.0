Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D758649E38A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241806AbiA0Ndj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242072AbiA0Ncu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:32:50 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8BEC061760
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 05:32:44 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id n8so5378971lfq.4
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 05:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NWE1+aRes3zB48V9f+3catFSPmCCuIRuHklKncMmBWY=;
        b=NZEIsYtyt3kAm88SSBmhYlFpn7sBVaEUhuSUqdAm9aXQSwU6BQ8Th13fvmHWKmpLqR
         NFGwNcjB03qZT8OAZ1l3wfGiCeJB3tgq23vZWlcg0zkuQBh+TNMlC867+ylYZJMJ0Nfz
         t7r9i49RjChrz/Ffgc1+i+4gzsHZxgzjdd3BMf793ds0+gy7QnywKrfcqfZhxJGTyV7l
         8P9PayEWFag+k/mSgWbVvobX5AmKcdeyIgeWWCklnxv6WMmntlHWMVyDGA8kvWsq0ha1
         uDRB8MtXFF9f6ntorvqqF52XFeNKKUZCO8Wjc8Zc7zJyn30v86wP1gKMNOXkhu9zsuZC
         rPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NWE1+aRes3zB48V9f+3catFSPmCCuIRuHklKncMmBWY=;
        b=FzKx6Se8myRkcuAUEEIf0fhYxpCCaDH7jQb5TQ4/dfCMdyw+nCe7R7u62pLW6ApAIB
         P63zKWmMQ5IFIf1g42CC9UXpE44YbU/ajyd8Q7hrOhEZ1vH0gRfuUVKuDzTsW/bDCU3C
         IiNyChfLbePi8zVq+6CKwri5fRvXsClwNOMXCAJOtNs9qz5y1MBzRDpYAywgPT9dsjpw
         hvPCfHzCDagofkVYK5wSfXNOfAIwQsmt1Wu+LdhS7r1tGWYIZCAcgivvlNCtvLJLqDvG
         PwTXpPCBYScaCgGMjNwsCUDKAp5X3vf/yuoOdUV65+1uCKKGl/US1Qq8TmLAGhKS8IeL
         kTvw==
X-Gm-Message-State: AOAM532iVnXtqNbP6vtchiCTqKLgOTrTORNRO1V4ChhICnlnHSvby3JQ
        DQTutEE0A5izFqoBPbRNsom5qlpMcgiHcB5dR5c=
X-Google-Smtp-Source: ABdhPJzlVkP5tf3tJ0aQ19MF0BxUeu4Hs+LNclZls29RYtyz6MEg6w8mcjpm1n47mBSMnxV1pcYJgrL3WmID6lJFAm8=
X-Received: by 2002:a19:f806:: with SMTP id a6mr2962254lff.592.1643290362527;
 Thu, 27 Jan 2022 05:32:42 -0800 (PST)
MIME-Version: 1.0
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 27 Jan 2022 19:02:30 +0530
Message-ID: <CALHRZuqE3z27wq58a=xdRbjEXLfufN7mkVxANgnSqB0EEFnd3Q@mail.gmail.com>
Subject: Re: [net PATCH 0/9] Fixes for CN10K and CN9xxx platforms
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David and Jakub,

Any comments on this patchset ?

Thanks,
Sundeep

On Fri, Jan 21, 2022 at 12:04 PM Subbaraya Sundeep <sbhatta@marvell.com> wrote:
>
> Hi,
>
> This patchset has consolidated fixes in Octeontx2 driver
> handling CN10K and CN9xxx platforms. When testing the
> new CN10K hardware some issues resurfaced like accessing
> wrong register for CN10K and enabling loopback on not supported
> interfaces. Some fixes are needed for CN9xxx platforms as well.
>
> Below is the description of patches
>
> Patch 1: AF sets RX RSS action for all the VFs when a VF is
> brought up. But when a PF sets RX action for its VF like Drop/Direct
> to a queue in ntuple filter it is not retained because of AF fixup.
> This patch skips modifying VF RX RSS action if PF has already
> set its action.
>
> Patch 2: When configuring backpressure wrong register is being read for
> LBKs hence fixed it.
>
> Patch 3: Some RVU blocks may take longer time to reset but are guaranteed
> to complete the reset. Hence wait till reset is complete.
>
> Patch 4: For enabling LMAC CN10K needs another register compared
> to CN9xxx platforms. Hence changed it.
>
> Patch 5: Adds missing barrier before submitting memory pointer
> to the aura hardware.
>
> Patch 6: Increase polling time while link credit restore and also
> return proper error code when timeout occurs.
>
> Patch 7: Internal loopback not supported on LPCS interfaces like
> SGMII/QSGMII so do not enable it.
>
> Patch 8: When there is a error in message processing, AF sets the error
> response and replies back to requestor. PF forwards a invalid message to
> VF back if AF reply has error in it. This way VF lacks the actual error set
> by AF for its message. This is changed such that PF simply forwards the
> actual reply and let VF handle the error.
>
> Patch 9: ntuple filter with "flow-type ether proto 0x8842 vlan 0x92e"
> was not working since ethertype 0x8842 is NGIO protocol. Hardware
> parser explicitly parses such NGIO packets and sets the packet as
> NGIO and do not set it as tagged packet. Fix this by changing parser
> such that it sets the packet as both NGIO and tagged by using
> separate layer types.
>
> Thanks,
> Sundeep
>
> Geetha sowjanya (5):
>   octeontx2-af: Retry until RVU block reset complete
>   octeontx2-af: cn10k: Use appropriate register for LMAC enable
>   octeontx2-pf: cn10k: Ensure valid pointers are freed to aura
>   octeontx2-af: Increase link credit restore polling timeout
>   octeontx2-af: cn10k: Do not enable RPM loopback for LPC interfaces
>
> Kiran Kumar K (1):
>   octeontx2-af: Add KPU changes to parse NGIO as separate layer
>
> Subbaraya Sundeep (2):
>   octeontx2-af: Do not fixup all VF action entries
>   octeontx2-pf: Forward error codes to VF
>
> Sunil Goutham (1):
>   octeontx2-af: Fix LBK backpressure id count
>
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  2 +
>  .../ethernet/marvell/octeontx2/af/lmac_common.h    |  3 +
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  1 +
>  .../ethernet/marvell/octeontx2/af/npc_profile.h    | 70 +++++++++++-----------
>  drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 66 +++++++++++++++-----
>  drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  4 ++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  7 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 14 ++++-
>  .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  2 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 20 +++----
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 22 ++++++-
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 20 ++++---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  7 ++-
>  15 files changed, 164 insertions(+), 76 deletions(-)
>
> --
> 2.7.4
>
