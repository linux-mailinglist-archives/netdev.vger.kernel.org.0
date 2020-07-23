Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF522B768
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgGWUSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgGWUSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:18:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE36C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 13:18:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 901F111E48C65;
        Thu, 23 Jul 2020 13:01:16 -0700 (PDT)
Date:   Thu, 23 Jul 2020 13:17:58 -0700 (PDT)
Message-Id: <20200723.131758.642362772753839021.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v1 0/7] udp_tunnel: convert Intel drivers with
 shared tables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bfa03cf8613ada508774a2e6e89b9b01bfd968dd.camel@intel.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
        <1af4aea7869bdb9f3991536b6449521b214ed103.camel@intel.com>
        <bfa03cf8613ada508774a2e6e89b9b01bfd968dd.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 13:01:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Date: Thu, 23 Jul 2020 20:06:15 +0000

> On Wed, 2020-07-22 at 14:22 -0700, Tony Nguyen wrote:
>> On Tue, 2020-07-21 at 18:27 -0700, Jakub Kicinski wrote:
>> > This set converts Intel drivers which have the ability to spawn
>> > multiple netdevs, but have only one UDP tunnel port table.
>> > 
>> > Appropriate support is added to the core infra in patch 1,
>> > followed by netdevsim support and a selftest.
>> > 
>> > The table sharing works by core attaching the same table
>> > structure to all devices sharing the table. This means the
>> > reference count has to accommodate potentially large values.
>> > 
>> > Once core is ready i40e and ice are converted. These are
>> > complex drivers, and I don't have HW to test so please
>> > review..
>> 
>> I'm requesting our developers to take a look over and validation to
>> test the ice and i40e patches. I will report back when I get results.
> 
> Would you mind if I pick these patches up into Jeff's tree? It will
> make it easier to test that way.

No objections on my end, and you can add my:

Acked-by: David S. Miller <davem@davemloft.net>
