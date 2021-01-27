Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6E2305420
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhA0HMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317709AbhA0Aqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:46:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A86AB2067C
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 00:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611708373;
        bh=2QVge+wx6qCgSOekzEAiVCNszepUCqOtLrhMBLSjs2w=;
        h=Date:From:To:Subject:From;
        b=VTTSdyr68pLrs2PuYkedUJk8qgQlI+n8bgtr5X4qyYKx57MJdRyn88ffD/zqFuLc8
         Jjdvm51sxLFOQn3NJZN0tcFRjGmeLZhvKSSlv9KBFE/5LQWmo++6leJKwQ8PfhB2YG
         2/Kv5osLyWwLyH+7eVWosp/znGC+SwAAeLTslSqhQb15bvsQ6TloynTkEmUCwdPo6g
         FZxE2+WJPWH1Tq/lExcYNzjgCIe9BHfP9wloQFJrCMbT/7Pw4vponWQ//XX4TbH05/
         7vA68sgvpqa0Z086CFaS9ePJpmGRE+cqyiINOIqSYzPiGs+zB4STjIKZAYH6RVyQxh
         RXayqEXWyHz3w==
Date:   Tue, 26 Jan 2021 16:46:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Subject: Delays
Message-ID: <20210126164612.59856fd6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks!

vger seems to be randomly inserting many-hour delays on forwarding
emails which also renders patchwork pretty hard to use.

Sorry if there are delays or mistakes in applying patches, the issue
has been known (and repeatedly reported) for the last two weeks, and 
it's getting increasingly bad.
