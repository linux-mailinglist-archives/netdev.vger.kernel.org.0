Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD9634D602
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhC2R0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhC2R0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 13:26:48 -0400
X-Greylist: delayed 159 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Mar 2021 10:26:47 PDT
Received: from joooj.vinc17.net (joooj.vinc17.net [IPv6:2001:4b99:1:3:216:3eff:fe20:ac98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC261C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 10:26:47 -0700 (PDT)
Received: from smtp-zira.vinc17.net (lfbn-tou-1-1431-42.w90-89.abo.wanadoo.fr [90.89.233.42])
        by joooj.vinc17.net (Postfix) with ESMTPSA id 00E84FD;
        Mon, 29 Mar 2021 19:24:06 +0200 (CEST)
Received: by zira.vinc17.org (Postfix, from userid 1000)
        id 9C889C205A8; Mon, 29 Mar 2021 19:24:05 +0200 (CEST)
Date:   Mon, 29 Mar 2021 19:24:05 +0200
From:   Vincent Lefevre <vincent@vinc17.net>
To:     netdev@vger.kernel.org
Subject: ip help text should fit on 80 columns
Message-ID: <20210329172405.GD209599@zira.vinc17.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mailer-Info: https://www.vinc17.net/mutt/
User-Agent: Mutt/2.0.6+144 (4e01ccdb) vl-132933 (2021-03-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Help text such as output by "ip help" or "ip link help" should fit
on 80 columns. It currently seems to take up to 86 columns.

Tested version:

zira:~> ip -V
ip utility, iproute2-5.9.0, libbpf 0.3.0

but that's the iproute2 5.10.0-4 Debian package.

-- 
Vincent Lefèvre <vincent@vinc17.net> - Web: <https://www.vinc17.net/>
100% accessible validated (X)HTML - Blog: <https://www.vinc17.net/blog/>
Work: CR INRIA - computer arithmetic / AriC project (LIP, ENS-Lyon)
