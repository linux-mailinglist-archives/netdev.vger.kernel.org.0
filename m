Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2C4421B13
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhJEAXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:23:21 -0400
Received: from mail.i8u.org ([75.148.87.25]:62374 "EHLO chris.i8u.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230242AbhJEAXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 20:23:21 -0400
Received: by chris.i8u.org (Postfix, from userid 1000)
        id 4AB6616C959B; Mon,  4 Oct 2021 17:21:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by chris.i8u.org (Postfix) with ESMTP id 4A4A016C9327;
        Mon,  4 Oct 2021 17:21:31 -0700 (PDT)
Date:   Mon, 4 Oct 2021 17:21:31 -0700 (PDT)
From:   Hisashi T Fujinaka <htodd@twofifty.com>
To:     "Andreas K. Huettel" <andreas.huettel@ur.de>
cc:     Jakub Kicinski <kubakici@wp.pl>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [EXT] Re: [Intel-wired-lan] Intel I350 regression 5.10 -> 5.14
 ("The NVM Checksum Is Not Valid") [8086:1521]
In-Reply-To: <1763660.QCnGb9OGeP@pinacolada>
Message-ID: <caf054b-c155-7614-5e97-e5ed34bf4eee@twofifty.com>
References: <1823864.tdWV9SEqCh@kailua> <20211004074814.5900791a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <7064659e-fe97-f222-5176-844569fb5281@twofifty.com> <1763660.QCnGb9OGeP@pinacolada>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021, Andreas K. Huettel wrote:

>>>>
>>>> Any advice on how to proceed? Willing to test patches and provide
>>>> additional debug info.
>> Sorry to reply from a non-Intel account. I would suggest first
>> contacting Dell, and then contacting DeLock. This sounds like an
>> issue with motherboard firmware and most of what I can help with
>> would be with the driver. I think the issues are probably before
>> things get to the driver.
>
> Ouch. OK. Can you think of any temporary workaround?
>
> (Other than downgrading to 5.10 again, which I can't since it fails
> at the graphics (i915) modesetting...)

This is completely unofficial because I don't really work on client
systems, but I'd try different NICs, different slots, and the BIOS
settings.

You also might try support@intel.com because they're much more used to
client system support.

Todd Fujinaka todd.fujinaka@intel.com
