Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E791270297
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIRQwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgIRQwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 12:52:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A5A220848;
        Fri, 18 Sep 2020 16:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600447934;
        bh=Jx+jaBEQYwrMFY7LQXQHWAm3LlRH5wMZXJc7uVyAz6k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yN4d3Rf0lSYpVcwxeIXNTtvzsBLMPaLIcsZYTKPN76LO35O+IdzdopU8CpJ9qDJh1
         sSn5OjTEp6kBgmjXLCIetTuCdOwMrc1i8/NHR5OGEV8UOVIRbAjhOqDiIWDoyPjqAu
         XhjvS+hgIehIEElzMatSPnKjMUrydP73eT8lgY6M=
Date:   Fri, 18 Sep 2020 09:52:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Message-ID: <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917172020.26484-1-parav@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 20:20:12 +0300 Parav Pandit wrote:
> Hi Dave, Jakub,
> 
> Similar to PCI VF, PCI SF represents portion of the device.
> PCI SF is represented using a new devlink port flavour.
> 
> This short series implements small part of the RFC described in detail at [1] and [2].
> 
> It extends
> (a) devlink core to expose new devlink port flavour 'pcisf'.
> (b) Expose new user interface to add/delete devlink port.
> (c) Extends netdevsim driver to simulate PCI PF and SF ports
> (d) Add port function state attribute

Is this an RFC? It doesn't add any in-tree users.
