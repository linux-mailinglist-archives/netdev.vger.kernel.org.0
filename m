Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF5A46454C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 04:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241375AbhLADP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhLADP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:15:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AA1C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 19:12:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5F1AB81827
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 03:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A316C53FC7;
        Wed,  1 Dec 2021 03:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638328356;
        bh=JbBPXjyTHGdcBHhGhVnAzsOoNjAW3l2Raalf5iEeo78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aVwDjFApfQLWrE0xZ9yhXILxnD/Wvn/6OklLPBfDM1S5mvuLDYFKAM+/vI/oAr745
         7gFs6UDqx6s6GTYEVBdQbOErHE+ch6LcPjsMYLeZhZ/sv/89M2b0Fkdq9OX7aCEibU
         PybnxsoGDfLcVKa13WGfLJ8UUmyxMQt/EFSlciYaFzVgQmjnCqLT//UUBelWa7M+GV
         LXoCy880xpdJorSt1JhfCvY8uPsJFOqBild/B4kllUotow70aZDKoUyGGEtXRRtaYm
         qh286Yv9ybH3331d4GaFDiLb707X+KLvnLNZtiMo94tfsLwOJMzsHarRD/6mywSL3/
         EnLI2uSwXj5Pw==
Date:   Tue, 30 Nov 2021 19:12:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Sudhakar Rani <sunrani@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
        <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 22:17:29 +0000 Sunil Sudhakar Rani wrote:
> > On Mon, 22 Nov 2021 16:43:06 +0200 Sunil Rani wrote:  
> > > The device/firmware decides how to define privileges and access to resources.
> > 
> > Great API definition. Nack  
>
> Sorry for the late response. We agree that the current definition is vague.
> 
> What we meant is that the enforcement is done by device/FW.
> We simply want to allow VF/SF to access privileged or restricted resource such as physical port counters.
> So how about defining the api such that:
> This knob allows the VF/SF to access restricted resource such as physical port counters.

You need to say more about the use case, I don't understand 
what you're doing.
