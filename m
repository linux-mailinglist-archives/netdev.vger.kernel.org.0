Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5C748357E
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiACRVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiACRVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:21:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38685C061761;
        Mon,  3 Jan 2022 09:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79EE61174;
        Mon,  3 Jan 2022 17:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3FAC36AEB;
        Mon,  3 Jan 2022 17:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230512;
        bh=KDcOrgZIU1XDeH6Uo1OKvN4VTlGEYf+34WT5LyZU3Fc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OkyGR7z2+zOu07oK66nwXVdb+DmZa00050akbOjEWkut2RPlEW48yHw2a8JORhR8m
         CDUOGu/TQpvvaD7FXF0daltKw9AexNjTGDmbe30S0vT9NYLY3hppLE2cBiCWSy04uN
         0YwLKOWqTOB3nYLiVhhbqVmeP70W7j/N7kEoh7r1KbHfBZkQDs5+tWQ2k0xB6V+K0V
         Y1denEl8lwJxNhVv6bRxZkqPeXn7zpcKAKaWWs8W/UT/0EuEGEGCJtrspy7+TJeuM0
         jnrfsKBJUPQy0YVds91tvgifgIfLzm9+8kaFaGrU4Ghdd/IviSWe5KvWAvdw0mdUQV
         Qxxt1VsxT9l1Q==
Date:   Mon, 3 Jan 2022 09:21:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linuxwwan <linuxwwan@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        "Sergey Ryazanov" <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: Re: [PATCH 2/2] net: wwan: iosm: Keep device at D0 for s2idle case
Message-ID: <20220103092142.102c272f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <SJ0PR11MB500869254A4E9DEEC1DF3B5DD7499@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20211224081914.345292-2-kai.heng.feng@canonical.com>
        <20211229201814.GA1699315@bhelgaas>
        <CAAd53p74bHYmQJzKuriDrRWpJwXivfYCfNCsUjC47d1WKUZ=gQ@mail.gmail.com>
        <SJ0PR11MB500869254A4E9DEEC1DF3B5DD7499@SJ0PR11MB5008.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jan 2022 15:28:18 +0000 Kumar, M Chetan wrote:
> > Dave, can you drop it from netdev until IOSM devs confirm this patch is
> > correct?  
> 
> Dave, please drop this patch from netdev.

YMMV but these sort of requests aren't usually acted on. netdev doesn't
rebase so revert is needed, and the developers involved are best at
writing commit messages for those since they have all the context. 
So sending a revert patch, with Link to the discussion and context
explained is the best way.
