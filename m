Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FBDEEABA
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfKDVFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:05:05 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41445 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728709AbfKDVFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 16:05:05 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 440F420D0F;
        Mon,  4 Nov 2019 16:05:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 04 Nov 2019 16:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=sJhf3D
        xJCnHRGR1xQB2dO9jmz/hUafbD7SrQODTBM4M=; b=laJI95ZtmQkp5c6kjEmcV7
        H1uUI8JvcMZ195ieYlKvPoQKbUOZEB3UhEL1DLKN2FtHpGHC38g50HCmUUmFxLxY
        8oOptoAIFbqEtp0VXsbK6RNcOccLwPDOaEB7LSAc/1V5zgZ2yXDnj7jm8sJoYAKR
        FbB/v/irNeIKz5EkRs4F4gveWLaSkdwXKDu4dpIXesGZK6aDK7ozNhRi1E8ltLVH
        S6xTpBUjxcC1PzzuQ+Mi7aTj/0EsJTxKEa3ma5Pot9KwHYCxoot/78zM9ML1sDuW
        009ReffuaQmZUcmc7j53kpHxotAbcTHnGdNB16A26o/gCI0crUZ+zZtI/H5gC/ww
        ==
X-ME-Sender: <xms:f5LAXcls6BPDD90vx43Ycf2nS72whF8pHbxA2QOLkNAZmZ4egrMt4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgudeghecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepje
    ejrddufeekrddvgeelrddvtdelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:f5LAXSm3BpMCpTctYqPh9osGJ3glQK6T6lGNk37095PPtyW_vvMP4A>
    <xmx:f5LAXSIsCN0QQWouN7YmgUumPjWyqeRO8rfb1v_8nQk8-a3SaNqgww>
    <xmx:f5LAXWz6Wwoh_CcvanvNidAVFQAJbMqeqkcc1i97nk2Dh-_YoVjQ4w>
    <xmx:gJLAXZqe3KZ8iSYNfjth0R0pdaXU_jnmxDRglYZgozmWeA9iI5OYAA>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id C91D83060069;
        Mon,  4 Nov 2019 16:05:02 -0500 (EST)
Date:   Mon, 4 Nov 2019 23:04:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191104210450.GA10713@splinter>
References: <20191103083554.6317-1-idosch@idosch.org>
 <20191104123954.538d4574@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104123954.538d4574@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 12:39:54PM -0800, Jakub Kicinski wrote:
> On Sun,  3 Nov 2019 10:35:48 +0200, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> > the driver and device's firmware. They are used to pass various
> > configurations to the device, but also to get events (e.g., port up)
> > from it. After the Ethernet header, these packets are built in a TLV
> > format.
> > 
> > Up until now, whenever the driver issued an erroneous register access it
> > only got an error code indicating a bad parameter was used. This patch
> > set from Shalom adds a new TLV (string TLV) that can be used by the
> > firmware to encode a 128 character string describing the error. The new
> > TLV is allocated by the driver and set to zeros. In case of error, the
> > driver will check the length of the string in the response and print it
> > to the kernel log.
> > 
> > Example output:
> > 
> > mlxsw_spectrum 0000:03:00.0: EMAD reg access failed (tid=a9719f9700001306,reg_id=8018(rauhtd),type=query,status=7(bad parameter))
> > mlxsw_spectrum 0000:03:00.0: Firmware error (tid=a9719f9700001306,emad_err_string=inside er_rauhtd_write_query(), num_rec=32 is over the maximum number of records supported)
> 
> Personally I'm not a big fan of passing unstructured data between user
> and firmware. Not having access to the errors makes it harder to create
> common interfaces by inspecting driver code.

I don't understand the problem. If we get an error from firmware today,
we have no clue what the actual problem is. With this we can actually
understand what went wrong. How is it different from kernel passing a
string ("unstructured data") to user space in response to an erroneous
netlink request? Obviously it's much better than an "-EINVAL".

Also, in case it was not clear, this is a read-only interface and only
from firmware to kernel. No hidden knobs or something fishy like that.

> Is there any precedent in the tree for printing FW errors into the logs
> like this?

The mlx5 driver prints a unique number for each firmware error. We tried
to do the same in switch firmware, but it lacked the infrastructure so
we decided on this solution instead. It achieves the same goal, but in a
different way.
