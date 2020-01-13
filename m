Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CC3139CC2
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 23:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgAMWp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 17:45:29 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:41184 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728829AbgAMWp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 17:45:29 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ir8Sa-0005eE-Gc; Mon, 13 Jan 2020 22:45:24 +0000
Message-ID: <5cc1353038a8d71518710539312dc578693e5ab3.camel@codethink.co.uk>
Subject: [stable] i40e: prevent memory leak in i40e_setup_macvlans
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date:   Mon, 13 Jan 2020 22:45:23 +0000
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like this fix is needed for 5.4 (but not any older stable
branch):

commit 27d461333459d282ffa4a2bdb6b215a59d493a8f
Author: Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Wed Sep 25 10:48:30 2019 -0500

    i40e: prevent memory leak in i40e_setup_macvlans

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

