Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF6249313F
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345266AbiARXOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:14:39 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56642 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiARXO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:14:27 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CCFD1212C3;
        Tue, 18 Jan 2022 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642547666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjk/ocpLrCq5mzno9/g86HL7PAGZ9UYl6ScXKn1UhPY=;
        b=r8AtU9J7S+zYdm1uCTkfmJ3npnT2of53kyffiRl3zMrkx40ZLal3NhgnV+CBYv+vsa/n3M
        Yt2iOsnXTo//wCiUk8s/QkzjEsLsOGFNpz1TwS2xumBdKYsxWKBohrIYS22o+CvvwYKQhO
        Iz2SavY7L71MECA73hIFnslvmKBpr5c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642547666;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjk/ocpLrCq5mzno9/g86HL7PAGZ9UYl6ScXKn1UhPY=;
        b=Qz/x2hRFrZaLM2501TIoTs1UtuP4M/+pEaUY+UfYAY0jHPae3eNVXdLKpPqVOBbnGRMYEM
        UKzB2LjBfIC05oDA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BD522A3B81;
        Tue, 18 Jan 2022 23:14:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A250D6053D; Wed, 19 Jan 2022 00:14:23 +0100 (CET)
Date:   Wed, 19 Jan 2022 00:14:23 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, michel@fb.com,
        dcavalca@fb.com
Subject: Re: ethtool 5.16 release / ethtool -m bug fix
Message-ID: <20220118231423.aa66a42vso3hvobp@lion.mk-sys.cz>
References: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 02:51:59PM -0800, Jakub Kicinski wrote:
> Hi Michal!
> 
> Sorry to hasten but I'm wondering if there is a plan to cut the 5.16
> ethtool release? Looks like there is a problem in SFP EEPROM parsing
> code, at least with QSFP28s, user space always requests page 3 now.
> This ends in an -EINVAL (at least for drivers not supporting the paged
> mode).
> 
> By the looks of it - Ido fixed this in 6e2b32a0d0ea ("sff-8636: Request
> specific pages for parsing in netlink path") but it may be too much code 
> to backport so I'm thinking it's easiest for distros to move to v5.16.

Accidentally, I'm working on it right now. I need to run few more tests,
should be done in 20-30 minutes (if there are no complications).

Michal
