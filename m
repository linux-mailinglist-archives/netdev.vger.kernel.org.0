Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB445ABC9F
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 05:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiICDkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 23:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiICDkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 23:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC0E3CBD1
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 20:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59016620BF
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 03:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56309C433C1;
        Sat,  3 Sep 2022 03:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662176411;
        bh=MRTJRyBCbPktgQolH6Y+uOCTXvU1VMspg5/Ys44l7xU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mY+wcsPyksTiy5n7oXVh+VVsKhJ55zpE601aUjxfhUX0z2Aj+KODPzijIpZZTQ1tS
         LcwB1WIiLM7ufAJRGW5iBIlFkPYw8QgOgKT4ZOOyc0sRy3/EbSCgh4WYxAo1qkV8U0
         FIaciNNCshqfOWUpiygX3z+KPQWFDH8wF725CZuAvm3oZJPz5Ji+JD5GJEjvHRb6NV
         WEWgJBDlABxjzMbj07UIZjyJ6NuvYXVZUUUFD+7g6YxsPwMTR0zvl5+FTesWXMNWFa
         ZMoNtFohwcYT2rMKRgP/GxihjxLUE6FkSmQhnXwyq6G+NuV1NhaQZwK5q0KmY02ZnE
         9jC8Gq2O/jKzg==
Date:   Fri, 2 Sep 2022 20:40:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net 0/3] bonding: fix lladdr finding and confirmation
Message-ID: <20220902204010.4ccbd369@kernel.org>
In-Reply-To: <20220830093722.153161-1-liuhangbin@gmail.com>
References: <20220830093722.153161-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 17:37:19 +0800 Hangbin Liu wrote:
> This patch set fixed 3 issues when setting lladdr as bonding IPv6 target.
> Please see each patch for the details.

Hi Jay, is this one still on your radar?
