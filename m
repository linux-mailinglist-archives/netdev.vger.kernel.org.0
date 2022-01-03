Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52014483509
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 17:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiACQnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 11:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiACQnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 11:43:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD952C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 08:43:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 639B261177
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 16:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4DEC36AEB;
        Mon,  3 Jan 2022 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641228202;
        bh=HMA84ttD4f5GBhNdWbOmjsvVfgjtPFAWeP76OyQCxvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sx9AlcT5Gt6kdIUd9fcPaoT1XQFUSo80lQXlHS6CwIyT7hu6cLMAnfY02H8/mKdOG
         i/D8c5hNJtxnD1zjPw81SGLChIOqHE3UVMfhIHc6T8f2Ln/XKw0DYoTnCJoFb96fKJ
         Ri7yaTKapM0tqHXBiY/kxl2kbWK6bA8YgK6M66JFckeLvNb+lg8MnSG6KRMvJg7O3A
         IMPLIRXiSE5cJR+ryZ5HijE6RPQetLNtCRL2kvgjHiv7DffzM+sNdlNyzSfiG/thxp
         FGQS4jc/G295zzVqVeZyPPv12m1Rh9Ta9pCZ7Bxz36T/036MKx4u7r53spZ/VuebLO
         52tc0zJVzXJAQ==
Date:   Mon, 3 Jan 2022 08:43:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH net-next] net: vertexcom: default to disabled on kbuild
Message-ID: <20220103084321.48236cfa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220102221126.354332-1-saeed@kernel.org>
References: <20220102221126.354332-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Jan 2022 14:11:26 -0800 Saeed Mahameed wrote:
> Sorry for being rude but new vendors/drivers are supposed to be disabled
> by default, otherwise we will have to manually keep track of all vendors
> we are not interested in building.

Vendors default to y, drivers default to n. Vendors don't build
anything, hence the somewhat unusual convention. Are you saying
you want to change all the Kconfigs... including Mellanox?
