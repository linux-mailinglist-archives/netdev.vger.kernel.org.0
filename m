Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784ED5101DC
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352262AbiDZP2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352241AbiDZP2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:28:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3749221275
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3C122ciisb4mthLAFdN+mdqNK636RbkbbuhW+rwhpmQ=; b=jeeDB8NlD2Z6T+fnTFM/KK5yDL
        yxFy5jvhAma7ucizskPaRjnxnebNiQuUB7OqXM8kkwXOr14GnmLb+C0mT3c+SjyUrEctuhfH1qQn/
        3wtE5QWGEVfP79QVQvSlo1xG0GqbjqDjHrUri4C05zlyJAypwVpg75OwSpratMDsCutY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njN3R-00HZeR-2v; Tue, 26 Apr 2022 17:24:41 +0200
Date:   Tue, 26 Apr 2022 17:24:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmgOuUPy9Digezvh@lunn.ch>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
 <20220426054130.7d997821@kernel.org>
 <Ymf66h5dMNOLun8k@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymf66h5dMNOLun8k@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Does not make sense to me at all. Line cards are detachable PHY sets in
> essence, very basic functionality. They does not have buffers, health
> and params, I don't think so. 

Ido recently added support to ethtool to upgrade the flash in SFPs.
They are far from simple devices. Some of the GPON ones have linux
running in them, that you can log in to.

The real question is, can you do everything you need to do via
existing uAPIs like ethtool and hwmon.

	Andrew
