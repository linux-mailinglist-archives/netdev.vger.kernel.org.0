Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364F5139DB2
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgAMX5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:57:16 -0500
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:43258 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgAMX5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 18:57:16 -0500
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 18:57:15 EST
Received: from [167.98.27.226] (helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ir9JN-0003ga-WA; Mon, 13 Jan 2020 23:39:58 +0000
Message-ID: <cbed1d656d40ba099714b13f17b912a3dd30b402.camel@codethink.co.uk>
Subject: [stable] wimax: i2400: fix memory leaks
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Date:   Mon, 13 Jan 2020 23:39:57 +0000
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like these fixes are needed for 4.19 (and older stable
branches):

commit 2507e6ab7a9a440773be476141a255934468c5ef
Author: Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Tue Sep 10 18:01:40 2019 -0500

    wimax: i2400: fix memory leak

commit 6f3ef5c25cc762687a7341c18cbea5af54461407
Author: Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Fri Oct 25 23:53:30 2019 -0500

    wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

