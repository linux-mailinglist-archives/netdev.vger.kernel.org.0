Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E6E2AFD0A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgKLBcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:19 -0500
Received: from smtp.netregistry.net ([202.124.241.204]:59756 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbgKLAP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 19:15:26 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2020 19:15:26 EST
Received: from 124-148-94-203.tpgi.com.au ([124.148.94.203]:32948 helo=192-168-1-16.tpgi.com.au)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1kd0BZ-0002jp-N1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:10:00 +1100
Date:   Thu, 12 Nov 2020 10:09:54 +1000
From:   Russell Strong <russell@strong.id.au>
To:     netdev@vger.kernel.org
Subject: IPv4 TOS vs DSCP
Message-ID: <20201112100954.62d696b6@192-168-1-16.tpgi.com.au>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

After needing to do policy based routing based on DSCP, I discovered
that IPv4 does not support this.  It does support TOS, but this has
never been upgraded to the new ( now quite old ) DSCP interpretation.

Is there a historical reason why the interpretation has not changed?

I could copy the dscp into a fwmark and then use that, but that seems a
little unnecessarily complicated.  If I were to change this, what would
be the objections?

Russell
