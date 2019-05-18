Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650C8221A4
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 06:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbfEREeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 00:34:03 -0400
Received: from smtp-out.sig.net.nz ([202.27.199.35]:49889 "EHLO
        gromit.sig.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfEREeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 00:34:02 -0400
X-Greylist: delayed 2219 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 May 2019 00:34:01 EDT
Received: from feathers.ext.sig.nz ([2002:ca1b:c777:2:5349:476e:6574:25])
         by gromit.sig.net.nz ([2002:ca1b:c777:2:5349:476e:6574:23]:25)  with esmtp  (Exim 4.72 #1)
        id 1hRqSx-0005zf-TE 
        for netdev@vger.kernel.org; Sat, 18 May 2019 15:57:00 +1200
Date:   Sat, 18 May 2019 13:52:36 +1000 (AEST)
From:   Martin Kealey <martin@kurahaupo.gen.nz>
To:     netdev@vger.kernel.org
Subject: patch for iproute2
Message-ID: <alpine.DEB.2.00.1905181350500.8326@feathers.ext.sig.nz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello iproute2 maintainer.

(Sorry, I don't know your name)

I recently noticed a discrepancy: the internal documentation for the ip
command says that an *RTT* value can be sufficed with "s" (second) or "ms"
(millisecond), but in practice no suffix of any kind is accepted.

I found that that commit 697ac63905cb5ca5389cd840462ee9868123b77f to
git://git.kernel.org/pub/scm/network/iproute2/iproute2.git caused this
regression; it was over-zealous in disallowing non-digits in *all* contexts
where a number is expected.

As far as I can tell, this does not have any kernel-related impact, merely
it affects what arguments are accepted by the "ip" command.

I have a suitable patch for fixing this; what is the procedure for
submitting it?

-Martin
