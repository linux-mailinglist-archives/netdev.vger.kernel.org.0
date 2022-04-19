Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C083F507C55
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 00:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351150AbiDSWC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 18:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbiDSWC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 18:02:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CDA2BB0B;
        Tue, 19 Apr 2022 15:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9fIn1WJ7W/honN+a6igcMi0VpTGTsUJF8kRurUwhuUE=; b=DDNnJPTiffeQpNAd/WjT9vgyLW
        9ou5KwqZm9sanH9Nu3gxmb9ldPBDqjzLr/Z/BGKILfsjfcnFTM8I0+M9Prk+Zt3L2tgN+IoPkr9sC
        qqLCAdNBSUhYDHZqFOeI33xikCNKlZtgVnG/yTp3U5vhUBGSGxcmttyDvqw4tzD2BKbU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngvtF-00GZwV-Oy; Wed, 20 Apr 2022 00:00:05 +0200
Date:   Wed, 20 Apr 2022 00:00:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next] PCI: add Corigine vendor ID into pci_ids.h
Message-ID: <Yl8w5XK54fB/rx9c@lunn.ch>
References: <1650362568-11119-1-git-send-email-yinjun.zhang@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650362568-11119-1-git-send-email-yinjun.zhang@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 06:02:48PM +0800, Yinjun Zhang wrote:
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/linux/pci_ids.h | 2 ++

The very top of this file says:

 *      Do not add new entries to this file unless the definitions
 *      are shared between multiple drivers.

Please add to the commit messages the two or more drivers which share
this definition.

Thanks

     Andrew
