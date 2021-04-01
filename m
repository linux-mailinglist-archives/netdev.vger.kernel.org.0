Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB35B3522E8
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbhDAWuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235149AbhDAWuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 18:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 568BB610FC;
        Thu,  1 Apr 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617317411;
        bh=I59LTVgVFNx1e+DjGlo183n46Bs9JsSvMOYLL6VQnGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=US/Z+TLzF54riPHSi9D60ECybYshrYjqqeAkpoLvRWmzAJ3yfZjt2iDTXT6rix+bC
         grS1/hydoo9r4sYDYISxykvar5l6o4/IYUHJ0ZL7Cc8q/KJGQRPASs1TPUFLiQRvdF
         enKRRcWYDO//3Y3k/6l1Lu/qSqQpapWuXv2tinf/WQ+bvqxw+ztt3H8ndX5FusHc0t
         +v8vrCrCFwEbxTL8MGspHWGjsZRQNuZ12bqIo4L3+/eHQfPwFIqKEYRfF1X5g5HxE2
         fl+H/Ack8Z1FXs2IxgKLIEp20GNaVDHNT0ThDPyCd+jUJO35qNtJITCsjDgJ2SslCx
         JAYjtzyHs51uw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B0CF608FE;
        Thu,  1 Apr 2021 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-03-31
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731741130.4407.5053214899334528050.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 22:50:11 +0000
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 31 Mar 2021 16:08:43 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Benita adds support for XPS.
> 
> Ani moves netdev registration to the end of probe to prevent use before
> the interface is ready and moves up an error check to possibly avoid
> an unneeded call. He also consolidates the VSI state and flag fields to
> a single field.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] ice: Add Support for XPS
    https://git.kernel.org/netdev/net-next/c/634da4c11843
  - [net-next,02/15] ice: Delay netdev registration
    https://git.kernel.org/netdev/net-next/c/1e23f076b254
  - [net-next,03/15] ice: Update to use package info from ice segment
    https://git.kernel.org/netdev/net-next/c/a05983c3d024
  - [net-next,04/15] ice: handle increasing Tx or Rx ring sizes
    https://git.kernel.org/netdev/net-next/c/2ec5638559c1
  - [net-next,05/15] ice: change link misconfiguration message
    https://git.kernel.org/netdev/net-next/c/5c57145a49bd
  - [net-next,06/15] ice: remove unnecessary duplicated AQ command flag setting
    https://git.kernel.org/netdev/net-next/c/800c1443cbe1
  - [net-next,07/15] ice: Check for bail out condition early
    https://git.kernel.org/netdev/net-next/c/805f980bfe0e
  - [net-next,08/15] ice: correct memory allocation call
    https://git.kernel.org/netdev/net-next/c/36ac7911fae7
  - [net-next,09/15] ice: rename ptype bitmap
    https://git.kernel.org/netdev/net-next/c/94a936981a3e
  - [net-next,10/15] ice: Change ice_vsi_setup_q_map() to not depend on RSS
    https://git.kernel.org/netdev/net-next/c/8134d5ff9788
  - [net-next,11/15] ice: Refactor get/set RSS LUT to use struct parameter
    https://git.kernel.org/netdev/net-next/c/e3c53928a3b2
  - [net-next,12/15] ice: Refactor ice_set/get_rss into LUT and key specific functions
    https://git.kernel.org/netdev/net-next/c/b66a972abb6b
  - [net-next,13/15] ice: Consolidate VSI state and flags
    https://git.kernel.org/netdev/net-next/c/e97fb1aea905
  - [net-next,14/15] ice: cleanup style issues
    https://git.kernel.org/netdev/net-next/c/0c3e94c24793
  - [net-next,15/15] ice: Correct comment block style
    https://git.kernel.org/netdev/net-next/c/a07cc1786dab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


