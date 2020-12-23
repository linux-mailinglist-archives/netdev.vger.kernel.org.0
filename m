Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4222E21CD
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 22:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgLWU7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgLWU7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71D88224B2;
        Wed, 23 Dec 2020 20:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608757141;
        bh=hwyV9m/DOq1mzuCAyM3ww3sqRezZ0VcoMY3occQEJCI=;
        h=Date:From:To:Cc:Subject:From;
        b=N+fggvsyVQzXiiWlJnO+iQSmgZ/JoNKVq+N/n5uWlNW9w6dsOt73bDs//WsYxaypF
         +KJr44KyQYtViruMWO5S/zcWie46CIboSfiIzedc0CY2ZjgI7IPVh+wMoDwKNW2rC9
         f86/zQm1cp20JB1EqCyFcJyJ4ol19PEYI1bpJAdPD+snWJrYYy2FMIefGmUvLJC2wx
         UrRjDMTzPc8oOFxJvPDFETdG/2PGn4uU0As6eMMYGSyVPz4MwDUjvYKKbv8we/Xus/
         7FnCJjLykx5S6EcDnOQhPjNlqD6KdxF3vqv1SwbMCR3VQdb9Eh/pYEgCNr0RtVMy8T
         vD3Zx20ZPu+NA==
Date:   Wed, 23 Dec 2020 12:59:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
Subject: Winter solstice pause
Message-ID: <20201223125900.686cc1f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all, just a quick FYI.

Patches had slowed down to a trickle, so we'll most likely leave the
trees be until Monday starting now. Many reviewers and maintainers are
likely to be AFK for the next few days.

Please let us know if anything requires urgent attention :)
