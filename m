Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90299357435
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355211AbhDGS0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236413AbhDGS0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:26:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 153C861132;
        Wed,  7 Apr 2021 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617819970;
        bh=PukHujzwkNktQl8p/DN+953D5Ib0oOHvCvz2vWLLqk4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lWHVxycEks2AOfQVTSUO7o4PAaxgDpXcnu/K3bSQC7z0Ef1uT3RbKzrPtY3Zc/ebp
         ue9b/S8hy5YcGENTa1ytmBjWPNEMooXCEm07AhVucgTsQOWN8ScUwdjczz9NuG3q3d
         f2I+WGr539zi0K5jwMDGIMYs0g29CcMbzD80vPBbi1GVFTuduOnjs1ci3p3d6X/Sw+
         7qJNe6YuilLMAWlZMp0gme6S62rG/rDk70ULZOnQLsI8aCM1Mryjbwf9POB7HdriJX
         M10IzBDv5vsOdXxMNAWnx48VlOs9xGVPR5dkIAonjuIcGA2NdF0YJstnS6DRS9P8hg
         SlJ3T9OJ4ePBg==
Date:   Wed, 7 Apr 2021 11:26:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: introduce nla_policy for IFLA_NEW_IFINDEX
Message-ID: <20210407112609.55c50b6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210407064003.248047-1-avagin@gmail.com>
References: <20210407064003.248047-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Apr 2021 23:40:03 -0700 Andrei Vagin wrote:
> In this case, we don't need to check that new_ifindex is positive in
> validate_linkmsg.
> 
> Fixes: eeb85a14ee34 ("net: Allow to specify ifindex when device is moved to another namespace")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
