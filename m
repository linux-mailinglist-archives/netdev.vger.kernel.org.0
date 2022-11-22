Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9766344FF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiKVT4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 14:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiKVTzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:55:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41188A7C13
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=gmfIxnGAuQCydQQ3WML234U2BFt2PZzCBf5SiR9B9WU=; b=Ou
        Bm/udoNw9t6xRaM3M4cZ/MCvz5ruqV+qJrdlU3fFFZdzO63aGazIX0w8WasAYXEkv0KWnljOtLGI7
        GQVcxmGDl4tq4LzU091lBku2WsLd/iA92IERqaA923OG5g/k6MNqMjrD4YqLmETRf4SRj3fFTfKqJ
        bMDVZAP7RgLMBAo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxZM7-0039bR-DY; Tue, 22 Nov 2022 20:54:55 +0100
Date:   Tue, 22 Nov 2022 20:54:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steve Williams <steve.williams@getcruise.com>,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        xiaoliang.yang_1@nxp.com
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
Message-ID: <Y30pD0B6t4MmUht9@lunn.ch>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org>
 <20221122113412.dg4diiu5ngmulih2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221122113412.dg4diiu5ngmulih2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ../drivers/net/hanic/hanic_sysfs.c:83:31: error: ‘struct hanic_netns’ has no member named ‘class_attr_sandlan_interfaces’; did you mean ‘class_attr_hanic_interfaces’?
>    83 |         sysfs_attr_init(&xns->class_attr_sandlan_interfaces.attr);

There was another submission over the weekend adding a network
emulation system called sandlan. The cover latter for this patchset
should of at minimum said there was a dependency between the two. But
in practice, there should not be any dependency at all. It is unclear
if sandlan will get merged.

   Andrew
