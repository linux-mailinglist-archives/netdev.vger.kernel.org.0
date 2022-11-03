Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECEB618B2F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiKCWMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiKCWMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:12:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E385712E;
        Thu,  3 Nov 2022 15:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NY6p2Rzf+pmkS1Ogdqk7s0bJFhngznBVPOEAmTXlfEo=; b=ylh7oMG7JATG0caXDDwbjH/NTJ
        YuLBfKaq7XIW8igbiECtGP9Kptwo5X2W47zN8SYJ0A7tRGRJLvQxiuwkxuxstOzpzcikXZzvTAHZX
        JMMs+fR/ris2nLJWPndnoQEVcY8TQ8+ywglH/EXxZacnTCMWUkqND2S7CeQvphH42bR8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqiRI-001M2E-A8; Thu, 03 Nov 2022 23:11:56 +0100
Date:   Thu, 3 Nov 2022 23:11:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, git@amd.com, harini.katakam@amd.com,
        radhey.shyam.pandey@amd.com, michal.simek@amd.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/2] include: uapi: Add new ioctl
 definitions to support Frame Preemption
Message-ID: <Y2Q8rOLtXDu9LSo2@lunn.ch>
References: <20221103113348.17378-1-pranavi.somisetty@amd.com>
 <20221103113348.17378-2-pranavi.somisetty@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103113348.17378-2-pranavi.somisetty@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 05:33:47AM -0600, Pranavi Somisetty wrote:
> Add new ioctl definitions, SIOC_PREEMPTION_EN, SIOC_PREEMPTION_CTRL,
> SIOC_PREEMPTION_STS, SIOC_PREEMPTION_COUNTER, to support IEEE 802.3br.

Please justify using an IOCTL when everything else in the network
stack is configured using netlink.

      Andrew
