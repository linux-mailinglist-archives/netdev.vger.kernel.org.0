Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F05A2F3FF5
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391399AbhALXI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbhALXI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 18:08:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DD3A23123;
        Tue, 12 Jan 2021 23:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610492867;
        bh=t62Q+mOmAE1B5NrSoErOf17IxrFhtozdbYjt1zRyl5o=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=ZHp4DyAPhW56WsJjZaWIOL29JDBOaIeoIVEn/50uMMXGdtzL5EHKOjMWWjZiHOEDP
         JsAISe0b94PA4txGuOeVRwyDeeHR6HNjJ30h2HmNb3Y/rCNKvnRw/zekhpFDlqiJAy
         sJg6kZ9jDIguMkjORLfot36krwFr0gYkOlUqmY72cPBpxFEhlKrYJiha6V1afhTww0
         5AP8h3T+QCU3EOtDFa1WrRxlW+vSlBAAvny0ogG7KMx+guc05VucChj8fcxr7fRePO
         SD4BHojleYHkShly947TDd1VmHNuICYhbtlccSBZazzoCSzorMEertBEpzf/W5/crb
         WAFL5+5nvmaaQ==
Message-ID: <00f385ace950a575f86018eda51d7fb769855e13.camel@kernel.org>
Subject: Re: [PATCH net-next 0/7] a set of fixes of coding style
From:   Saeed Mahameed <saeed@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>, netdev@vger.kernel.org
Date:   Tue, 12 Jan 2021 15:07:45 -0800
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 00:42 -0600, Lijun Pan wrote:
> This series address several coding style problems.
> 
> Lijun Pan (7):
>   ibmvnic: prefer 'unsigned long' over 'unsigned long int'
>   ibmvnic: fix block comments
>   ibmvnic: fix braces
>   ibmvnic: avoid multiple line dereference
>   ibmvnic: fix miscellaneous checks
>   ibmvnic: add comments for spinlock_t definitions
>   ibmvnic: remove unused spinlock_t stats_lock definition
> 
>  drivers/net/ethernet/ibm/ibmvnic.c | 65 +++++++++++++---------------
> --
>  drivers/net/ethernet/ibm/ibmvnic.h | 11 ++---
>  2 files changed, 35 insertions(+), 41 deletions(-)
> 
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

