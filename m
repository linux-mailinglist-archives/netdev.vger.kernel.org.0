Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E8A54EFB2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379656AbiFQDYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiFQDYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:24:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43C864BDB
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 20:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C010B826F9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0350BC3411C;
        Fri, 17 Jun 2022 03:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655436287;
        bh=1DagKBUhCUSPYrZZeXYgKRjvuZGSVJ+ipuiOEP7/ikM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mPRUBxtSI2WFB9cy6gmtVz47LaEe1MiXZoao1SMEbWE10pEVRjH+t8eWJHpdsvcws
         TQGXtow1vbh0PyrCXdO7pSm832R+PeViAkOTl/B5YwBxKmY+WAUILHIL/ZZD/f91Ec
         2xtgpMtKIs0a5FqzpPZuKzt5XPPNGX58++bIWNLxuMwhOtjgUnJUmv9okDhTs4hyII
         7QMJzoP2NsFCPSpeWi9qX6+ga5u9b/5QSuumJcZWAgU7/yK8QYeUidiVZGcNhsmk1t
         ms7+3/ztMd3L/ThyQ0L9Vr4A9IYWfD124iLNsS8sLQvkSXEUFgTlf0XcbFIAVsaJEE
         19H2bGLuLQbgg==
Date:   Thu, 16 Jun 2022 20:24:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     HighW4y2H3ll <huzh@nyu.edu>, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix Fortify String build warnings caused by the memcpy
 check in hinic_devlink.c.
Message-ID: <20220616202445.559b95c9@kernel.org>
In-Reply-To: <20220616201216.2eefad10@hermes.local>
References: <20220616235727.36546-1-huzh@nyu.edu>
        <20220616201216.2eefad10@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 20:12:16 -0700 Stephen Hemminger wrote:
> Patch is missing signed-of-by
> 
> Using [0] inside union will cause warnings in future since you are referencing
> outside of bounds of array.
> 
> Also indentation is wrong, you need to indent the union

BTW there's already a fix from Kees pending for this.
