Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45884ECE4D
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 12:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfKBLNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 07:13:51 -0400
Received: from aichinger-gw.4020.kapper.net ([94.136.7.154]:56211 "EHLO
        pi.h5.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfKBLNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 07:13:50 -0400
X-Greylist: delayed 2252 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Nov 2019 07:13:50 EDT
Received: from ralph by pi.h5.or.at with local (Exim 4.92)
        (envelope-from <ra@pi.h5.or.at>)
        id 1iQqlV-0001FY-2N
        for netdev@vger.kernel.org; Sat, 02 Nov 2019 11:36:17 +0100
Date:   Sat, 2 Nov 2019 11:36:16 +0100
From:   Ralph Aichinger <ra@pi.h5.or.at>
To:     netdev@vger.kernel.org
Subject: Unification of iproute2 "ip route show" v4 and v6 output
Message-ID: <20191102103616.GA4307@pi.h5.or.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

I am basically doing what the Debian maintaner of iproute2 
suggested in Debian bug #535128,

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=535128

i want to ask if there is any chance of getting IPv6 routes
(like addresses) from ip by default? 

I understand the dangers of breaking scripts relying on
"traditional" behaviour, on the other hand it seems that
iproute2 always prioritized "doing stuff right" vs. 
"doing it the traditional way". Maybe even some middle
ground (a config option?) would be possible?

TIA
/ralph
-- 
-----------------------------------------------------------------------------
                                                              https://aisg.at
                                                   ausserirdische sind gesund
