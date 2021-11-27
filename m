Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9732745FDC3
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 10:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353797AbhK0Jxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 04:53:32 -0500
Received: from michaelblizek.twilightparadox.com ([193.238.157.55]:60288 "EHLO
        michaelblizek.twilightparadox.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239063AbhK0Jvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 04:51:32 -0500
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Nov 2021 04:51:31 EST
Received: from localhost ([127.0.0.1] helo=grml)
        by michaelblizek.twilightparadox.com with esmtp (Exim 4.92)
        (envelope-from <michi1@michaelblizek.twilightparadox.com>)
        id 1mqu0j-0002q5-G9; Sat, 27 Nov 2021 10:28:45 +0100
Date:   Sat, 27 Nov 2021 10:27:41 +0100
From:   michi1@michaelblizek.twilightparadox.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [RFC] Connection oriented routing
Message-ID: <20211127092741.GA2599@grml>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I have been deleloping a connection oriented layer 3+4 protocol mostly for
wifi mesh networks. Its main difference is that "tcp" connections are not
end-to-end but between neighboring routers instead.

It runs ane you can test it, if you want, but it is not ready for merging or
actual use yet. Some unfinished tasks include:
- cleanups
- performance: lots of things which can be improved
- keepalive
- interfaces for configuration+statistics
- move to a newer upstream kernel
- I am not sure how some of the in-kernel interfaces work. More specifically,
  I am not sure which "struct proto/proto_ops" functions need to be
  implemented and how ho avoid race conditions when accessing various
  variables. Also, network namespaces are not handled yet either. I will look
  closer into this when the other issues are resolved in order to avoid
  upstream changes breaking it in the mean time.

Website: https://michaelblizek.twilightparadox.com/projects/cor/index.html
Kernel repo: https://repo.or.cz/w/cor.git?a=tree
Userspace tools: https://repo.or.cz/w/corutils.git

Please share your thoughts!

	-Michi
