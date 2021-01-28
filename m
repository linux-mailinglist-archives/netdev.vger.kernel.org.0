Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28830306A99
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhA1Bn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:43:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhA1BnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:43:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B1960C40;
        Thu, 28 Jan 2021 01:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611798147;
        bh=4vLfmeyK9AuDFxkUBs0MB1PAHNzPTWLRrZAfsUxxuhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f/qYBVMaB8KKg7rQbGniI96CxgU6uiTi1mzhuP+uWQ/h2IW6HVX3RG1+kY2EcEuhy
         jrQbp/jteSR+5EFzqAxiY3erQifVlTyERtWEMf1cyijsf3j+sWvYtyaghDHaFHRo48
         Ap4flzMUqNk0421/SO6YlarmETgB88Ajub0CzItNt3y7SfDVZXty3oX5XyhvUpMeHd
         uUl3umrmGD3qWc8JWD21vbj3gM9hDbBY49McVAwhJOraX6mp3t2FVCY4d1JoGOJTTF
         j4ktdoRstVNqx+h7snM1PoxDuBvCGfDlGFU+YF2JV/wnigZlQ/AuvPOTLkQLek1zJa
         1UkHqc4xBJyrQ==
Date:   Wed, 27 Jan 2021 17:42:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] net: bridge: multicast: per-port EHT
 hosts limit
Message-ID: <20210127174226.4d29f454@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126093533.441338-1-razor@blackwall.org>
References: <20210126093533.441338-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 11:35:31 +0200 Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set adds a simple configurable per-port EHT tracked hosts limit.
> Patch 01 adds a default limit of 512 tracked hosts per-port, since the EHT
> changes are still only in net-next that shouldn't be a problem. Then
> patch 02 adds the ability to configure and retrieve the hosts limit
> and to retrieve the current number of tracked hosts per port.
> Let's be on the safe side and limit the number of tracked hosts by
> default while allowing the user to increase that limit if needed.

Applied, thanks!

I'm curious that you add those per-port sysfs files, is this a matter
of policy for the bridge? Seems a bit like a waste of memory at this
point.
