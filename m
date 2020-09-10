Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C46264EFC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgIJTcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgIJTb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 15:31:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95DCF21D81;
        Thu, 10 Sep 2020 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599766315;
        bh=JssddEusQdGBFmpL/oPUGSXtUAtkheCJ9/nhuF7mibU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jCBkdoNMeOD17gwZxnHkylw/eCYNU7zuDXn/vAYiKvvjbsYGh9QZOZabN5Cvb3/JN
         3k+9ztEnJXVN4g5dkZc8u+KzASOD3qV97Cy+gihby5tR5PmbfeCaX63EQs8mY35IIs
         JPX9V4gvzQ49VBW5qNGyINZ5XLJsukrNwixKSZ58=
Date:   Thu, 10 Sep 2020 12:31:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        nikolay@nvidia.com, roopa@nvidia.com,
        vasundhara-v.volam@broadcom.com, jtoppins@redhat.com,
        michael.chan@broadcom.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net 0/2] net: Fix bridge enslavement failure
Message-ID: <20200910123152.2c7d5c9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910110127.3113683-1-idosch@idosch.org>
References: <20200910110127.3113683-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 14:01:25 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 fixes an issue in which an upper netdev cannot be enslaved to a
> bridge when it has multiple netdevs with different parent identifiers
> beneath it.
> 
> Patch #2 adds a test case using two netdevsim instances.

Awesome, thanks Ido!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
