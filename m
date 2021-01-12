Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8A62F2628
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbhALCPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbhALCPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 21:15:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B2122510;
        Tue, 12 Jan 2021 02:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610417694;
        bh=wVFbzVvFYTEMfIkqviaJMP0T5ojYrAFh/NIlVAzZAOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A0Fgwo5mU45bMpYdPARle9T8kKbUoojwOpk30wEIalMUAcdFqRmE5LtT75kKMeJ7o
         P+bYmssVouZR4ODrflvLIVRrBRg3qWpQgsun2ekUZJX1CDz2zFSTqq49LOIp43n/Y2
         blRA+E+LL+nk3wqZ5Nl9J0PkDfqC8mD1la4OpxL3a2+4VAH1DVeP58/30JQcN4oVXl
         m1Qq7Y8w1Et7zehg0GTiBUQSCF2+ZqbGBR0Zwp26AcaRfafanwQnvnPM+d/2/6AADa
         G2bSeydhvTITHs9TFTEL78oyzg2ERj0XkpFFPAqCwRMV1rUGADC/2+C7oYf0BbSrjf
         VwBIX1ubuAYaQ==
Date:   Mon, 11 Jan 2021 18:14:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH net V2] cxgb4/chtls: Fix tid stuck due to wrong update
 of qid
Message-ID: <20210111181453.4e86301a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210109025106.21488-1-ayush.sawal@chelsio.com>
References: <20210109025106.21488-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 Jan 2021 08:21:06 +0530 Ayush Sawal wrote:
> +	if (skb)
> +		kfree_skb(skb);

kfree_skb() handles NULL just fine
