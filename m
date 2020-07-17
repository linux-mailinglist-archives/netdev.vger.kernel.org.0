Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9E12244C0
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgGQT6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:58:37 -0400
Received: from mx3.wp.pl ([212.77.101.10]:31022 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbgGQT6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 15:58:37 -0400
Received: (wp-smtpd smtp.wp.pl 3755 invoked from network); 17 Jul 2020 21:58:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1595015914; bh=plQfnxetZpE336xJnFbaJlHfbP2EsFoOwqdsfCYe7zc=;
          h=From:To:Cc:Subject;
          b=ZKx5AQJCcNLhzs2wESn5jIpm/94yVougdy/7s3/53JQKnjHfWH/GjzmQUG3cgmyK7
           DqmME0W1EqqqKy5AMeXtwfhgAoKM5BpgTilIzeiP0iJlV+RZI11j8wKXUHwtmKFPWy
           NbmHj7YnbVrnW8Lniv6yUZ1tMllAf9PhYKvR3szY=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.7])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 17 Jul 2020 21:58:34 +0200
Date:   Fri, 17 Jul 2020 12:58:26 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 0/6] introduce PLDM firmware update
 library
Message-ID: <20200717125826.1f0b3fbb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200717183541.797878-1-jacob.e.keller@intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: b19d5611600ed5037fc867882e2452e7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [8WDS]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 11:35:35 -0700 Jacob Keller wrote:
> This series goal is to enable support for updating the ice hardware flash
> using the devlink flash command.

Looks reasonable.

You have some left over references to ignore_pending_flash_update in
comments, and you should use NLA_POLICY_RANGE() for the new attr.

Taking and releasing the FW lock may be fun for multi-host devices if
you ever support those.
