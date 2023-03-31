Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACDA6D1818
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCaHHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjCaHHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:07:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A211D113D0;
        Fri, 31 Mar 2023 00:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E56B82C4E;
        Fri, 31 Mar 2023 07:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A6BC433EF;
        Fri, 31 Mar 2023 07:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680246409;
        bh=ULJ77i3uchejajK5v2aO4WTsezJ4pPJHEvLC0cSZhCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FCr8+tvTK0a8rSnfwpmC328FPikIIiP5ex/PV+wBccLatnNdw09PbC388JWAKPNnr
         sBNERi0mPawfDSu+gPs8Yg3Q03lC2msas0I5L8KOEIERyl4RRr4iJ6VZMa9ZTjKy6h
         lYs51WlrWWgX6VyHBb6yTESHE8d1XedCbCNJn19KPyRtQ8W+stPafQG2k4paPj4V9+
         KZkR7ApfBe+4zU5f/trtFA6THn7MU+zEQyepCjXSekb+lJtnkFHIh/UjQO1sVpDlxU
         2qjwW85z8hE+vlwFL2lz5PQoST9aW+5t1K1Cdc1t8EW2cwJV0AM+6Kf0+MCJzQNPdC
         iN23KmhP05CDw==
Date:   Fri, 31 Mar 2023 00:06:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <20230331000648.543f2a54@kernel.org>
In-Reply-To: <20230330205612.921134-1-johannes@sipsolutions.net>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 22:56:11 +0200 Johannes Berg wrote:
>  * hardware timestamping support for some devices/firwmares

Was Richard CCed on those patches? 
Would have been good to see his acks there.

Adding him here in case he wants to take a look 'post factum'.
