Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6012417E9B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 02:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345646AbhIYA1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 20:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhIYA1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 20:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B04E610F7;
        Sat, 25 Sep 2021 00:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632529548;
        bh=x3lRi6G9QXYVnxKIGpMgMRYG0PA6I6tZDApGmDDduek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qfo0O0Kwwp/e3VyarcIKfj06CpEnHIAZFkkXCQPchqN1B6aHFXPxAwZqktLoOX6wU
         kZdgsTro2vug+svIHXmxZaaNFckNxtSWyDYOYn7cTLcED4FJKTofw7zPlXk8poBOb3
         dAkcR5GQH17Gre9kv/lEyu3b+Bf4A7I+xLonBkyBk4QaM4SC9DGCJOy45GwVT+n/iu
         tolbDJFGNBrA7uG1LwIRoy+UQwmoQxduGcoc5ekyGYkDyRrIollflUthmOH7qJfsnC
         hI2ctE6YsqV/vOI2BUsT2Z8nBwi6kHuH6Aa0AD2uOfacuJXRW/RSXw0Zz9G6ohyLUB
         HjYGouq8+PkPQ==
Date:   Fri, 24 Sep 2021 17:25:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next 00/12] mlx5 updates 2021-09-24
Message-ID: <20210924172547.22c10afd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 11:47:56 -0700 Saeed Mahameed wrote:
> 1) Roi Dayan provided some cleanups in mlx5e TC module, and some
>    code improvements to fwd/drop actions handling.
> 
> 2) Tariq, Add TX max rate support for MQPRIO channel mode

Tariq's change does not appear to be here.

> 3) Dima adds the support for TC egress/ingress offload of macvlan
>    interfaces

This probably deserves 24h on the list, so not pulling just yet.

> 4) misc cleanup
