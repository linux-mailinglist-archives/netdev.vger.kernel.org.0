Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FFC49317B
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346669AbiARXyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:54:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41670 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbiARXyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:54:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F14C5B81859
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 23:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AC3C340E0;
        Tue, 18 Jan 2022 23:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642550081;
        bh=zfL3nb3Ett+dOrnFsJZ4YJk63pWkOCTfN1fozbhmoBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NrmB7t5HIS0UzE6aC8RNW7fOiaNZKDvPvKEh73H3jSfmJLcIX77rp8Cbb9hejJLs8
         /eMczSPv4Sd1R/D1+DFE6yP2ZbMP3vEynpMv4tfZLgIKA3xOrq13VzZEFIbqUelFuF
         iNzCKMjkWkvAzLVRfNdjQ8fsNsvhpizHfm5O/Yxe+OUhua+UNfoyGfYUA4dkOF7Hnt
         mmHcStCaduSn+HnDt6y7tEK0GYUQ6p5ymTkKRxlya01zV0jvBh98aJo/qFhp/hRdpH
         AgRS+7FdItsdg5LSDl7/+dwKIB5Onynqmmw1RT7EhXfmUCILAocV+vCEx5SkdQVgFD
         qs5KQdvTV85pA==
Date:   Tue, 18 Jan 2022 15:54:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, michel@fb.com,
        dcavalca@fb.com
Subject: Re: ethtool 5.16 release / ethtool -m bug fix
Message-ID: <20220118155439.6ef83f2a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118231423.aa66a42vso3hvobp@lion.mk-sys.cz>
References: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220118231423.aa66a42vso3hvobp@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 00:14:23 +0100 Michal Kubecek wrote:
> On Tue, Jan 18, 2022 at 02:51:59PM -0800, Jakub Kicinski wrote:
> > Hi Michal!
> > 
> > Sorry to hasten but I'm wondering if there is a plan to cut the 5.16
> > ethtool release? Looks like there is a problem in SFP EEPROM parsing
> > code, at least with QSFP28s, user space always requests page 3 now.
> > This ends in an -EINVAL (at least for drivers not supporting the paged
> > mode).
> > 
> > By the looks of it - Ido fixed this in 6e2b32a0d0ea ("sff-8636: Request
> > specific pages for parsing in netlink path") but it may be too much code 
> > to backport so I'm thinking it's easiest for distros to move to v5.16.  
> 
> Accidentally, I'm working on it right now. I need to run few more tests,
> should be done in 20-30 minutes (if there are no complications).

Perfect! That's lucky or unlucky depending on how you look at it :)

I see the tag already, thanks!
