Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC4A76E75
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfGZQEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:04:24 -0400
Received: from eidolon.nox.tf ([185.142.180.128]:34186 "EHLO eidolon.nox.tf"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfGZQEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 12:04:23 -0400
X-Greylist: delayed 1114 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2019 12:04:23 EDT
Received: from equinox by eidolon.nox.tf with local (Exim 4.92)
        (envelope-from <equinox@diac24.net>)
        id 1hr2Pk-002kBB-5q
        for netdev@vger.kernel.org; Fri, 26 Jul 2019 17:45:48 +0200
Date:   Fri, 26 Jul 2019 17:45:48 +0200
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Subject: [HOWTO?] packet: tx-only socket / binding to "nothing"?
Message-ID: <20190726154548.GC258193@eidolon.nox.tf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,


quick question: is there a recommended setup to get a send-only packet
socket?  I've been reading net/packet/af_packet.c up and down and don't
see an explicit way, so I ended up binding to ("lo", ETH_P_LOOP)
instead.  (Nothing special about ETH_P_LOOP, I just grabbed a random
value that looked like it might never happen.)

Cheers,


-David
