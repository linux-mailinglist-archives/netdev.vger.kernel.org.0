Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3B217C70F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 21:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCFU36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 15:29:58 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59396 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbgCFU36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 15:29:58 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jAJbY-0002bz-HB; Fri, 06 Mar 2020 21:29:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] mptcp: don't auto-adjust rcvbuf size if locked
Date:   Fri,  6 Mar 2020 21:29:44 +0100
Message-Id: <20200306202946.8285-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mptcp receive buffer is auto-sized based on the subflow receive
buffer.  Don't do this if userspace specfied a value via SO_RCVBUF
setsockopt.

Also update selftest program to provide a new option to set a fixed
size.


