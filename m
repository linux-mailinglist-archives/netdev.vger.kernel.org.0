Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509E0641452
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiLCFbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiLCFas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:30:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BEAE61D5;
        Fri,  2 Dec 2022 21:30:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CD01B81AD6;
        Sat,  3 Dec 2022 05:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CC8C433D6;
        Sat,  3 Dec 2022 05:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670045427;
        bh=dYDlJsW1uB1yl7U6H35pRoLE04dtyokG7NHl00zLZo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gsVHrMPCgfuH72NJRaCK2qUpnIFN5YofUW8LDZB5f93C4VznJj1nb9z9PhmS+Dkok
         dqBTrl2rbzjgN18NtfNsvjlk4bHfe6MEa2XU4gIHGct8RqcGYz1P4bPLwDRLsGgu6/
         ZEheQng/N2DeHvqSXca5UVOlUTFHS5fwoqjfkYKcpzJsmls7dO84h0eXPvsAY1tUE7
         1x8MCk4cxtpbgZ+eIaiBS4pmDizxagJZoJWQRYMulrPBvcUGh+iQuRCpmv3Y1WKjAc
         JGynbCdU46snZyYmOtMUYoeyov6Ym6ZXgpvGgyWOBnWDzB+jtmbbrQszmLeGEvnCfa
         UFjI6N8z2aGRw==
Date:   Fri, 2 Dec 2022 21:30:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <Steen.Hegelund@microchip.com>, <lars.povlsen@microchip.com>,
        <daniel.machon@microchip.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 0/4] net: lan966x: Enable PTP on bridge
 interfaces
Message-ID: <20221202213026.11d898d0@kernel.org>
In-Reply-To: <20221202075621.1504908-1-horatiu.vultur@microchip.com>
References: <20221202075621.1504908-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 08:56:17 +0100 Horatiu Vultur wrote:
> Before it was not allowed to run ptp on ports that are part of a bridge
> because in case of transparent clock the HW will still forward the frames
> so there would be duplicate frames.
> Now that there is VCAP support, it is possible to add entries in the VCAP
> to trap frames to the CPU and the CPU will forward these frames.
> The first part of the patch series, extends the VCAP support to be able to
> modify and get the rule, while the last patch uses the VCAP to trap the ptp
> frames.

This no longer applies, probably the fix from Dan..

