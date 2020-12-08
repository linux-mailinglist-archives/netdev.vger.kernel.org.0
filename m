Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB32D1FD6
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 02:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgLHBOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:14:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgLHBOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 20:14:21 -0500
Date:   Mon, 7 Dec 2020 17:13:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607390021;
        bh=EEGXebL0RD9B2ZL1/JnWU4z/5sy/B0kbh2AgwxLogiM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=V0nhMRbAIqERxCSx+f3YrFrbvvKXN/e54Gr2EwK/tPfnX/sQ/QYDqxyFvM6sMFRA+
         dheZ9LYbw6nE8r/DxGvbAQk+svc7aodIlFU5POCmq3DqI7d17CN6ZXNMbU6cXDQ8aJ
         emHSrJWaatI2kVzbQSiPtBdhajgS/GLQbjJZ+zQ3NqGEQQoZ43+32h8fDIsQmRf/wS
         K8UKvfVgRrPXkLOJGjnSXetl50/cjUODMbdNzafqMyX6Qg4ot5JKl5iqDvGXs7ZN3m
         C4t83rmODJ1TtE0yxkggnacOGQEXEVKZamyAGO5+Nn+8bkAKhtFQCtgW0kkdXydUSx
         Wms7boA/ekbvQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH net-next v3 1/1] ibmvnic: add some debugs
Message-ID: <20201207171339.4dc03875@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205022235.2414110-1-sukadev@linux.ibm.com>
References: <20201205022235.2414110-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 18:22:35 -0800 Sukadev Bhattiprolu wrote:
> We sometimes run into situations where a soft/hard reset of the adapter
> takes a long time or fails to complete. Having additional messages that
> include important adapter state info will hopefully help understand what
> is happening, reduce the guess work and minimize requests to reproduce
> problems with debug patches.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Applied, thanks!
