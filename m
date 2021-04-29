Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CEC36E45A
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 06:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhD2Ezi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 00:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhD2Ezg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 00:55:36 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46988C06138B;
        Wed, 28 Apr 2021 21:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2rJqAv56RKqBO0YOecD45PBPS97bFl27b9mE+aV7O6U=; b=fFBfXjeQJN35K7kXA05WxbWUND
        uJWlmizBI75gVO1Sybxu8uX1wsueWbwZqnmQlqWh8ngfr2UYh6y6Y0LhMOZhn4ofj3QmKillOr0x2
        IRPT9n8/qo5trhi8j8uysbJ+4+G9ayTe4eSbxj9Y+f1fTWDIaFPsHVPbc6t289hcZGyY=;
Received: from p4ff13bc6.dip0.t-ipconnect.de ([79.241.59.198] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lbyhL-0001aj-0W; Thu, 29 Apr 2021 06:54:47 +0200
Subject: Re: pull-request: wireless-drivers-next-2021-04-23
To:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <20210423120248.248EBC4338A@smtp.codeaurora.org>
 <20210428172411.78473936@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <c801ab6d-538e-836e-4857-3802f4793ab4@nbd.name>
Date:   Thu, 29 Apr 2021 06:54:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210428172411.78473936@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-29 02:24, Jakub Kicinski wrote:
> On Fri, 23 Apr 2021 12:02:48 +0000 (UTC) Kalle Valo wrote:
>> mt76: debugfs: introduce napi_threaded node
> 
> Folks, why is the sysfs knob not sufficient?
Because mt76 has to use a dummy netdev for NAPI, which does not show up
in sysfs.

- Felix
