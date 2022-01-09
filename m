Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29D8488CC2
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbiAIV7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbiAIV7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FE9C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A51BCB80E3D
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 21:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266F2C36AED;
        Sun,  9 Jan 2022 21:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641765537;
        bh=V+FyZ7IHSW8g2n1M3wWCAiwwqCyCGlELmG1omqT2lGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iD3JI5o8d+sYZWT25xF2VZIkkaDDNgEkaQdHw/dKLG5S9q7nj/oeIr6/g09Rgcm0n
         Y9tOVB9Fbio+Z9ONCpUqkqLbpbFo4E1ELkAe80+boveYrq4Y5+4vZ8efkHELBHfugs
         DSGDi9IL3Pin7VruEy0rAIU2b4NrbEP3jSeLpmBWClH8Ec0Qrjfucim3y/r2BF29Rz
         5tS3Lgzl1gsyFPkwqAaTTCIKoVE3xUgvKSNmMR/zJ7LmlJdTj1h3F7W0eBbQlY8mG0
         jEU4mLUE9to+cvNBWXV17DV6ahVFUqyNqx8NCvMBEq33qR3JJlh3tg7bRQn4E3Z+fR
         1uLp0HRMZNlqw==
Date:   Sun, 9 Jan 2022 13:58:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 4/4] bnxt_en: improve firmware timeout
 messaging
Message-ID: <20220109135856.6ffcffce@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1641692328-11477-5-git-send-email-michael.chan@broadcom.com>
References: <1641692328-11477-1-git-send-email-michael.chan@broadcom.com>
        <1641692328-11477-5-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  8 Jan 2022 20:38:48 -0500 Michael Chan wrote:
> +static inline bool

no static inline in C sources
