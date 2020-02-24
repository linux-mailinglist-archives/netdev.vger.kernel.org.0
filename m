Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9DE616B04E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgBXTdO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Feb 2020 14:33:14 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38548 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgBXTdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:33:13 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 33C80CED24;
        Mon, 24 Feb 2020 20:42:38 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: pull-request: mac80211-next next-2020-02-24
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200224183442.82066-1-johannes@sipsolutions.net>
Date:   Mon, 24 Feb 2020 20:33:12 +0100
Cc:     netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BCCC37CB-FA6D-433C-B772-EC46EF734FED@holtmann.org>
References: <20200224183442.82066-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

> Some new updates - initial beacon protection support and TID
> configuration are the interesting parts, but need drivers to
> fill in, so that'll come from Kalle later :)
> 
> Please pull and let me know if there's any problem.
> 
> Thanks,
> johannes
> 
> 
> 
> The following changes since commit 92df9f8a745ee9b8cc250514272345cb2e74e7ef:
> 
>  Merge branch 'mvneta-xdp-ethtool-stats' (2020-02-16 20:04:42 -0800)
> 
> are available in the Git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-02-24
> 
> for you to fetch changes up to 370f51d5edac83bfdb9a078d7098f06403dfa4bc:
> 
>  mac80211: Add api to support configuring TID specific configuration (2020-02-24 14:07:01 +0100)
> 
> ----------------------------------------------------------------
> A new set of changes:
> * lots of small documentation fixes, from Jérôme Pouiller
> * beacon protection (BIGTK) support from Jouni Malinen
> * some initial code for TID configuration, from Tamizh chelvam
> * I reverted some new API before it's actually used, because
>   it's wrong to mix controlled port and preauth
> * a few other cleanups/fixes
> 
> ----------------------------------------------------------------
> Amol Grover (1):
>      cfg80211: Pass lockdep expression to RCU lists
> 
> Emmanuel Grumbach (1):
>      cfg80211: remove support for adjacent channel compensation
> 
> Johannes Berg (4):
>      mac80211: check vif pointer before airtime calculation
>      Revert "mac80211: support NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211_MAC_ADDRS"
>      Revert "nl80211: add src and dst addr attributes for control port tx/rx"

so I am bit concerned if these reverts are pushed so quickly without allowing ample time to discuss or review them on the mailing list. I for one, don’t agree with the assessment made to justify these reverts.

Regards

Marcel

