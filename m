Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B475A11CF71
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbfLLOLm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Dec 2019 09:11:42 -0500
Received: from mx2.uni-regensburg.de ([194.94.157.147]:36068 "EHLO
        mx2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729616AbfLLOLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 09:11:42 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2019 09:11:41 EST
Received: from mx2.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id E1BAE6000050
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 15:05:14 +0100 (CET)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx2.uni-regensburg.de (Postfix) with ESMTP id CD7EF600004E
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 15:05:14 +0100 (CET)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Thu, 12 Dec 2019 15:05:14 +0100
Message-Id: <5DF24919020000A100035A96@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.2.0 
Date:   Thu, 12 Dec 2019 15:05:13 +0100
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <netdev@vger.kernel.org>
Subject: Q: loopback and /sys/class/net/*/operstate
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Seeing "state UNKNOWN" in output of "ip addr sh" for loopback, I noticed that /sys/class/net/lo/operstate contains "unknown".
To me it seems that /usr/src/linux/drivers/net/loopback.c does not set up operstate of struct net_device.

Seen in 4.12.14-95.37-default (SLES12 SP4). My personal guess is that the struct was enhanced, and it was forgotten to upgrade loopback.c.

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000

Kind regards,
Ulrich




