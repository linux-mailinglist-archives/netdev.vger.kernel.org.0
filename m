Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BED477A2A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhLPRNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:13:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55254 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240033AbhLPRNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 12:13:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B52B661EAF
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 17:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1670BC36AE0
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 17:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639674814;
        bh=xDJFAkEC47Ku2aGMg6wuUnu2aRbf48tdLuLMM2/0ZDc=;
        h=Date:From:To:Subject:From;
        b=i1VMkcWBJ6l+zYeT24fMEaRGSGmT387sKndRcpDPv3M40t1EHjOz2iZVsKfyidaYq
         sFIUdenDWm7Sq1MKTh8Xmvy5YxJBAW5heYy3U3uubFz15QY49+4OsxhAAs6XX9LbYj
         B+Ffu8+LuHfewTn3fx2V8dsU6k7rJIFgpq8DcOQj7GEanoYdsIpqOxdfpDPxyWcrCP
         uy6Ja4wHOPm9rdm2jvfZ9CN35pAvLSNXwlADZbAlHcb5/D3+S28IjsumUyPfFYB/pj
         1fSNyHn2eMgLS0tpBzp1Jw+SFlxJQpMYhuT+ZZ9RiLyXwJ/pfDLCsWEcTyA4C9nBKv
         oNXcp7gG0hhGw==
Date:   Thu, 16 Dec 2021 09:13:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Missing pw-bot responses in last 12 hours
Message-ID: <20211216091332.371ca7f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor heads up, looks like the patchwork reply bot had some issues in
the last 12 hours. It's being investigated now. Responses to applied
patches may be delayed or missing.
