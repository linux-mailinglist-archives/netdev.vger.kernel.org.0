Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138A140484D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhIIKRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:17:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52008 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhIIKRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 06:17:10 -0400
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E4FD14F65C2E3;
        Thu,  9 Sep 2021 03:15:57 -0700 (PDT)
Date:   Thu, 09 Sep 2021 11:15:52 +0100 (BST)
Message-Id: <20210909.111552.1875064195273792824.davem@davemloft.net>
To:     maciej.machnikowski@intel.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, linux-kselftest@vger.kernel.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        kuba@kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <PH0PR11MB4951328A680F3D0FC7F9051CEAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210908165802.1d5c952d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49516BE62562735F017470A4EAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
        <PH0PR11MB4951328A680F3D0FC7F9051CEAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 09 Sep 2021 03:16:00 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Date: Thu, 9 Sep 2021 09:24:07 +0000

> Dave,
> 
> Are there any free slots on Plumbers to discuss and close on SyncE interfaces 
> (or can we add an extra one). I can reuse the slides from the Netdev to give 
> background and a live discussion may help closing opens around it,
> and I'd be happy to co-present with anyone who wants to also join this effort.

Sorry, I think it's much too late for this.
