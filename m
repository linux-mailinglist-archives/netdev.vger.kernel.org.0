Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A178218D357
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgCTPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:52:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgCTPwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:52:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CF961584D837;
        Fri, 20 Mar 2020 08:52:43 -0700 (PDT)
Date:   Fri, 20 Mar 2020 08:52:40 -0700 (PDT)
Message-Id: <20200320.085240.1137730407369663617.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 0/2] net: bridge: vlan options: nest the
 tunnel options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320112303.81904-1-nikolay@cumulusnetworks.com>
References: <20200320112303.81904-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Mar 2020 08:52:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Fri, 20 Mar 2020 13:23:01 +0200

> After a discussion with Roopa about the new tunnel vlan option, she
> suggested that we'll be adding more tunnel options and attributes, so
> it'd be better to have them all grouped together under one main vlan
> entry tunnel attribute instead of making them all main attributes. Since
> the tunnel code was added in this net-next cycle and still hasn't been
> released we can easily nest the BRIDGE_VLANDB_ENTRY_TUNNEL_ID attribute
> in BRIDGE_VLANDB_ENTRY_TUNNEL_INFO and allow for any new tunnel
> attributes to be added there. In addition one positive side-effect is
> that we can remove the outside vlan info flag which controlled the
> operation (setlink/dellink) and move it under a new nested attribute so
> user-space can specify it explicitly.
> 
> Thus the vlan tunnel format becomes:
>  [BRIDGE_VLANDB_ENTRY]
>      [BRIDGE_VLANDB_ENTRY_TUNNEL_INFO]
>          [BRIDGE_VLANDB_TINFO_ID]
>          [BRIDGE_VLANDB_TINFO_CMD]
>          ...

Makes sense, series applied, thanks.
