Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF42F24E61D
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 09:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHVHfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 03:35:18 -0400
Received: from mail.sh-ks.net ([83.236.182.180]:42742 "EHLO mail.sh-ks.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgHVHfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 03:35:17 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Aug 2020 03:35:17 EDT
Received: from x4d011822.dyn.telefonica.de by smtp.schlachthof-kassel.de (SendMail 8.15.2/2.0)  with ESMTPSA  TLSv1.2 id 07M7SRNk016045 for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 09:28:28 +0200
X-SHKS-Auth: authenticated by smtp.schlachthof-kassel.de: jb@x4d011822.dyn.telefonica.de; Sat, 22 Aug 2020 09:28:28 +0200
To:     netdev@vger.kernel.org
From:   netdev@dvl.sh-ks.net
Subject: missing support for certain realtek 8125-chip
Message-ID: <3a4a8e07-f77f-1225-242c-fb1648cc47c5@dvl.sh-ks.net>
Date:   Sat, 22 Aug 2020 09:27:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi.

we've got a odroid h2+ from hardkernel with two realtek 8125 chips
onboard, but the r8169-driver doesn't work with them.

on module-load we got "unknown chip XID 641" for both.

the chips themselves are labled as:

RTL 8125B
  JCS07H2
     GK08

maybe it's only an additional line in mac_info to support these chips,
but no one here is experienced enough to decide/try this.


it would be nice, if someone here with more experience can say something
about or perhaps add support for that chip.

thanks.

regards

sh-ks
