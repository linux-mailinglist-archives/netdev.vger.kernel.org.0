Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557E20FCEE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgF3TqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgF3TqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 15:46:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F057206B6;
        Tue, 30 Jun 2020 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593546362;
        bh=QMyCzvGFsLO9Q1LIK+HEWCjd4MbNixcUFuoCig4zNlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sdBn33KKTKLrPFnOuLiQowbvqd1qdlofSKeHKxyqKrG8GlDEaVkia9uR1TShG78E4
         Lvi0rd14tycxNOpiIH+rQHdcO83Ynr8FOyDDrMsr0POvf7gf58CynrHrDC9GpeUzG3
         XPb1Xgl0PvNmZs6dl472AFLHPjox29EcZ2Aava/0=
Date:   Tue, 30 Jun 2020 12:46:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v3 0/3] cxgb4: add mirror action support for
 TC-MATCHALL
Message-ID: <20200630124601.548a52f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 18:41:27 +0530 Rahul Lakkireddy wrote:
> This series of patches add support to mirror all ingress traffic
> for TC-MATCHALL ingress offload.
> 
> Patch 1 adds support to dynamically create a mirror Virtual Interface
> (VI) that accepts all mirror ingress traffic when mirror action is
> set in TC-MATCHALL offload.
> 
> Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
> mirror VI.
> 
> Patch 3 adds support to replicate all the main VI configuration to
> mirror VI. This includes replicating MTU, promiscuous mode,
> all-multicast mode, and enabled netdev Rx feature offloads.

Based on what you described:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

:)
