Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8E6476197
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344230AbhLOTWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344217AbhLOTWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 14:22:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE9FC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E18561A5C
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 19:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954B5C36AE2;
        Wed, 15 Dec 2021 19:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639596125;
        bh=rjom06UMO/FiHbsO29emDPyrOQdaG5UDpbsEzNgh7ZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IREVsvJ69A1HwwXJdJfFbzG0wurrN/751U9XKPjtgZBk938c7tmZxouPYiNEBpVLf
         YqfA4WpyMWDVzcCXmErPE2FM5coINxJ55fj4y+x/9F/16T7oBebmEeI6ee/U7h6vNS
         MlFvHFQrkocbIfMn4+QkNwDAE9CAv5HGn8EhEY9ybjwKTLQU9mAL7NrrdqOSiryLeV
         0QCPlMtIgmV4hKuySu1tLkqu62zgZ+PC72CD6iz8BSVcQFzW4V2EkKnF6w4l0mHuaf
         Gsb/GKVfGdCWlHppuB12fgCUoGkfjQiM+GfP2YKJkjbIy+jJPWdm/40BJ7JIT96WKh
         LDjI8f6ENNGQA==
Date:   Wed, 15 Dec 2021 11:22:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
        <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 18:19:16 +0000 Saeed Mahameed wrote:
> After some internal discussions, the plan is to not push new
> interfaces, but to utilize the existing devlink params interface for
> devlink port functions.
> 
> We will suggest a more fine grained parameters to control a port
> function (SF/VF) well-defined capabilities.
> 
> devlink port function param set/get DEV/PORT_INDEX name PARAMETER value
> VALUE cmode { runtime | driverinit | permanent }
> 
> Jiri is already on-board. Jakub I hope you are ok with this, let us
> know if you have any concerns before we start implementation.

You can use mail pigeon to configure this, my questions were about 
the feature itself not the interface.
