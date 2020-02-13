Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D872615B6A3
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 02:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgBMBYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 20:24:40 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:60443 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729369AbgBMBYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 20:24:40 -0500
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 20:24:39 EST
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 01D1BGrP030201;
        Thu, 13 Feb 2020 02:11:21 +0100
Received: from utente-Aspire-V3-572G.campusx-relay3.uniroma2.it (wireless-71-132.net.uniroma2.it [160.80.132.71])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 1ED50120085;
        Thu, 13 Feb 2020 02:11:12 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1581556272; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=gUgsca+8NvqClcWrP1qCq8W1+PibckFgtXZUU5Fdfyw=;
        b=1UnrmZjAE+wdLTRkwx0U54IbreYZJttu6z+ZlAkmD+cZk7MsyUK1x+c2jRew5MXT8xu1Vo
        OKZN+JISo3/U84Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1581556272; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=gUgsca+8NvqClcWrP1qCq8W1+PibckFgtXZUU5Fdfyw=;
        b=aF8wFDtQPLMAmMVrp6n981pdkwPJm0aZ8wkWKOt+eCukmt2J2TsfOcMexSAaJRZ6KoSGSi
        kp2XIhf/trh4T9Bq8G2dSOdaIya5UCdK280WhFjf+TFkygODBWPEjblw2yKumSQC05pof+
        blFSvvNl1I3Qiltza1GEOX43SNg2oq6IBwc6oO/9gCvIJxEl79/+7PY5G95kHHGK1yVXIk
        JEWTK1tcfCFhu7MHIZaSO7gpU1YM2eXS1abXMusc/wcH9vLGqttBpIhfhgB+x71s2FDZu0
        qeA66P72t9nGecE2WGCGAxhTcqQ9sRdtSygjo2P67+eRDb3lF7XAgk3KiN3EaA==
From:   Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahmed.abdelsalam@gssi.it, david.lebrun@uclouvain.be,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it,
        Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Subject: [net-next 0/2] Add support for SRv6 End.DT4 action
Date:   Thu, 13 Feb 2020 02:09:30 +0100
Message-Id: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series adds the support for SRv6 End.DT4 action.
End.DT4 decapsulates the received packets and does IPv4 routing
lookup in a specific routing table.

The IPv4 routing subsystem does not allow to specify the routing
table in which the lookup has to be performed.

Patch 1 enables to perform IPv4 FIB lookup in a predefined FIB table.
Patch 2 adds the support for SRv6 End.DT4 action.

Thanks,
Carmine Scarpitta

Carmine Scarpitta (2):
  Perform IPv4 FIB lookup in a predefined FIB table
  Add support for SRv6 End.DT4 action

 include/net/route.h   |  2 +-
 net/ipv4/route.c      | 22 ++++++++++++-------
 net/ipv6/seg6_local.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 9 deletions(-)

-- 
2.17.1

