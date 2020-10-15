Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0257A28F6AF
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389525AbgJOQ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388357AbgJOQ3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:29:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C53D122240;
        Thu, 15 Oct 2020 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602779388;
        bh=1aTJ9XeNZNffXHG+WGn6F+xS+hP1hWCioxFTlDYyDcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1rwVIVhiI/5FOG5TDnmsoN7nrqTmh7dkUI25iVO5BzDA3Z3MdDLbNZoqV071r4KZQ
         9W+oynrCBm3TL176ZdNZsFaZbHvQujoUPV3YA06dzNE7egIDpZDnfBMI+7CyNZMqjw
         ZrMFPusoPNj3/tlGao7gPDKBQc/5/OnnNBz0ReEk=
Date:   Thu, 15 Oct 2020 09:29:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next V3] cxgb4/ch_ipsec: Replace the module name to
 ch_ipsec from chcr
Message-ID: <20201015092946.71f12159@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014100806.23598-1-ayush.sawal@chelsio.com>
References: <20201014100806.23598-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 15:38:06 +0530 Ayush Sawal wrote:
> This patch changes the module name to "ch_ipsec" and prepends
> "ch_ipsec" string instead of "chcr" in all debug messages and
> function names.
> 
> V1->V2:
> -Removed inline keyword from functions.
> -Removed CH_IPSEC prefix from pr_debug.
> -Used proper indentation for the continuation line of the function
> arguments.
> 
> V2->V3:
> Fix the checkpatch.pl warnings.
> 
> Fixes: 1b77be463929 ("crypto/chcr: Moving chelsio's inline ipsec functionality to /drivers/net")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Applied, thanks.
