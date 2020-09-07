Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5259B260609
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgIGVHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIGVHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 17:07:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CFAD2137B;
        Mon,  7 Sep 2020 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599512873;
        bh=6xNg0yfoVNSSPTtnpVDfBA21vc45Sg4LmgMww2uLPac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u7of7Tur84T/QvReKnxtJDCOA2TiDP+0TUp1KnQrmsfQ2wjRBNZk69exD7rwCJk6E
         0qWAuHay/ySgOqWUwLM0kfwd84bTI8ouGrkp+iGfDHQv8o3IhjW66TVFHNVmuGph88
         CCa7LvS/iemg5CEEEuZarUpe64P0yeioQSnqi2WY=
Date:   Mon, 7 Sep 2020 14:07:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mmc@linux.vnet.ibm.com, drt@linux.ibm.com,
        tlfalcon@linux.ibm.com, jallen@linux.ibm.com
Subject: Re: [PATCH net] ibmvnic: add missing parenthesis in do_reset()
Message-ID: <20200907140751.299c82ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905040749.2450572-1-kuba@kernel.org>
References: <20200905040749.2450572-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Sep 2020 21:07:49 -0700 Jakub Kicinski wrote:
> Indentation and logic clearly show that this code is missing
> parenthesis.
> 
> Fixes: 9f1345737790 ("ibmvnic fix NULL tx_pools and rx_tools issue at do_reset")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied now.
