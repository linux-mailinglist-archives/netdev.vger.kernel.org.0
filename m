Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4F6219346
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgGHWVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHWVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:21:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1648C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 15:21:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADA7F1277EA5C;
        Wed,  8 Jul 2020 15:21:35 -0700 (PDT)
Date:   Wed, 08 Jul 2020 15:21:32 -0700 (PDT)
Message-Id: <20200708.152132.1607915539652673805.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/9] bnxt_en: Driver update for net-next.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708143939.62014a87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
        <20200708143939.62014a87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 15:21:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 8 Jul 2020 14:39:39 -0700

> On Wed,  8 Jul 2020 07:53:52 -0400 Michael Chan wrote:
>> This patchset implements ethtool -X to setup user-defined RSS indirection
>> table.  The new infrastructure also allows the proper logical ring index
>> to be used to populate the RSS indirection when queried by ethtool -x.
>> Prior to these patches, we were incorrectly populating the output of
>> ethtool -x with internal ring IDs which would make no sense to the user.
>> 
>> The last 2 patches add some cleanups to the VLAN acceleration logic
>> and check the firmware capabilities before allowing VLAN acceleration
>> offloads.
>> 
>> v4: Move bnxt_get_rxfh_indir_size() fix to a new patch #2.
>>     Modify patch #7 to revert RSS map to default only when necessary.
>> 
>> v3: Use ALIGN() in patch 5.
>>     Add warning messages in patch 6.
>> 
>> v2: Some RSS indirection table changes requested by Jakub Kicinski.
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied to net-next, thanks everyone.
