Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B1946D672
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhLHPMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbhLHPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:12:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666BEC061746;
        Wed,  8 Dec 2021 07:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AEC9ECE2204;
        Wed,  8 Dec 2021 15:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAB6C00446;
        Wed,  8 Dec 2021 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638976119;
        bh=ywKjLn27Q6Oh1nBhf+3mln3+BMCyTjnFwGC0TcO+TkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dr8Ac2LstfRkIamrj60wdve4k9bqFfwdVTS/MWc6rqjFkkasHR1nCoX+J+oGEdpRh
         HKRK7sCTV2oE9MaeCDZ+QrFDJ58kOCX07lyk/iWRQv8ygnXY8csobsQZWiNlBTyq/g
         SiWNz51IxlhusDB3h3jUPFfQHbDWfK4jNwrMRYWRRTN8dwee8V8clwW/W5At0hzi/t
         nlqqZks3/i+80DpPJtnug0iBSbj6s+CDt8xyA/8AgujsRM/lnN5uz4Ziam3tesuHLB
         1GzfKH5ZQXcp2DNXfAmgmYZN1gjENdKC4otwzDEgfOMY3diiJrGCeWTdexQnha85zD
         VhnY+KOK89eEQ==
Date:   Wed, 8 Dec 2021 07:08:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
Message-ID: <20211208070838.53892e8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207144211.A9949C341C1@smtp.kernel.org>
        <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87tufjfrw0.fsf@codeaurora.org>
        <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 06:50:25 -0800 Jakub Kicinski wrote:
> drivers/net/wireless/intel/iwlwifi/mvm/ops.c:684:12: warning: context imbalance in 'iwl_mvm_start_get_nvm' - wrong count at exit

I haven't looked at the code, but sparse is not great at understanding
locking so this one may be ignorable. 
