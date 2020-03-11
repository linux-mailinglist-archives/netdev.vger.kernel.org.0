Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C997918228E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 20:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbgCKTd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 15:33:57 -0400
Received: from balrog.mythic-beasts.com ([46.235.227.24]:39983 "EHLO
        balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731232AbgCKTdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 15:33:53 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2020 15:33:52 EDT
Received: from [146.90.33.204] (port=40284 helo=slartibartfast.quignogs.org.uk)
        by balrog.mythic-beasts.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <peter@bikeshed.quignogs.org.uk>)
        id 1jC726-0001Gt-L7; Wed, 11 Mar 2020 19:28:46 +0000
From:   peter@bikeshed.quignogs.org.uk
To:     linux-doc@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Peter Lister <peter@bikeshed.quignogs.org.uk>
Subject: [PATCH 0/1] Convert text to ReST list and remove doc build warnings
Date:   Wed, 11 Mar 2020 19:28:22 +0000
Message-Id: <20200311192823.16213-1-peter@bikeshed.quignogs.org.uk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 65
X-Spam-Status: No, score=6.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Lister <peter@bikeshed.quignogs.org.uk>

A minimal patch to format a couple of multi-line return value descriptions as
ReST lists, mostly by adding blank lines to kerneldoc comments.

This is pure formatting - the actual documentation text remains unchanged.

It also removes a couple of warnings from the doc build.


Peter Lister (1):
  Reformat return value descriptions as ReST lists.

 drivers/net/phy/sfp-bus.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

-- 
2.24.1

