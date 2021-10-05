Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9B5422FD3
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhJESWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:22:22 -0400
Received: from mail.i8u.org ([75.148.87.25]:61377 "EHLO chris.i8u.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhJESWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 14:22:21 -0400
Received: by chris.i8u.org (Postfix, from userid 1000)
        id 49BFA16C959B; Tue,  5 Oct 2021 11:20:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by chris.i8u.org (Postfix) with ESMTP id 4912216C92CD;
        Tue,  5 Oct 2021 11:20:28 -0700 (PDT)
Date:   Tue, 5 Oct 2021 11:20:28 -0700 (PDT)
From:   Hisashi T Fujinaka <htodd@twofifty.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kubakici@wp.pl>,
        "Andreas K. Huettel" <andreas.huettel@ur.de>
Subject: Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14 ("The NVM
 Checksum Is Not Valid") [8086:1521]
In-Reply-To: <b56c4c30-d393-96fb-182c-726a60a39eed@molgen.mpg.de>
Message-ID: <3db85012-3e16-ca2d-5742-d9ecd45eba7e@twofifty.com>
References: <1823864.tdWV9SEqCh@kailua> <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <7064659e-fe97-f222-5176-844569fb5281@twofifty.com> <4111f2b7-cbac-3451-593f-a154aca65263@intel.com>
 <b56c4c30-d393-96fb-182c-726a60a39eed@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021, Paul Menzel wrote:

> Linux has a no-regression policy, meaning when userspace/hardware with an 
> older Linux kernel worked than it *has to* work with a new version too. So 
> besides fixing the firmware/system, it?s as important to find the commit 
> introducing the regression and fix it.

I think you're looking at the wrong driver. igb is fairly stable and we
haven't been poking at it much. Most of the changes have been from the
community. Sasha is commiting to igc, not igb.

In any case, we don't have the hardware (motherboard or NIC) and any
bisection will have to be done by the issue submitter.

Todd Fujinaka todd.fujinaka@intel.com
