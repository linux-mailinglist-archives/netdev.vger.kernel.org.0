Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D225E58A290
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 22:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbiHDUtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiHDUty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 16:49:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0DF6E2F9
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ukZgTs7SRXdN51RQer1HVdBDS05o9tBBZgSNlIVO8I4=; b=nUtDo2frdIcG77V6+LtGsZeWYH
        k/sHt5HW/7u16nGKiPLvDZp4E3cxpsLVJlZy2wlq8X+XJ5MXISGImrmx2spy0j3j3XRo6fANOfckU
        OByysgpUUa6ka8X0eNosVX7YcMApUe4GfUlSQDmuoe/3hQbm1Np4xFqxNVy2EuH7QhVo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oJhmx-00CSRD-Mo; Thu, 04 Aug 2022 22:49:51 +0200
Date:   Thu, 4 Aug 2022 22:49:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC 0/1] Move IFF_LIVE_ADDR_CHANGE to public flag
Message-ID: <Yuww7/SSl+sN5mBl@lunn.ch>
References: <20220804174307.448527-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804174307.448527-1-prestwoj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>   net: move IFF_LIVE_ADDR_CHANGE to public flag

If this concept is accepted, i would actually change the flag name a
little. That will help developers know the semantics of the flag have
changed when their code fails to compile. Maybe make the public flag
IFF_ADDR_CHANGE_LIVE?

	Andrew
