Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6761139FC2
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 04:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgANDLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 22:11:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbgANDLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 22:11:43 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5671214AF;
        Tue, 14 Jan 2020 03:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578971503;
        bh=/SfqBD92fICPQ2MJPlPDphMIEZBFgHMeIidu8S3fyNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S5OSfMyvw9IKZQe/EfS3bSv0NA/BCeviOd4MJrWF1a9pR9LwKfrdJdmotG5ZWyBrQ
         UUgkWCiBpSs6XfoVHVslE4AtqC+HH02ki6KrYIeP4D3i9xylr41kxY8M/iB985ITT9
         1YwzJ3DKQ0WwCD9u9GeGK7t7yUHgJWiba5zTtA8Q=
Date:   Mon, 13 Jan 2020 19:11:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [stable] i40e: prevent memory leak in i40e_setup_macvlans
Message-ID: <20200113191140.60360f61@cakuba>
In-Reply-To: <5cc1353038a8d71518710539312dc578693e5ab3.camel@codethink.co.uk>
References: <5cc1353038a8d71518710539312dc578693e5ab3.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 22:45:23 +0000, Ben Hutchings wrote:
> It looks like this fix is needed for 5.4 (but not any older stable
> branch):
> 
> commit 27d461333459d282ffa4a2bdb6b215a59d493a8f
> Author: Navid Emamdoost <navid.emamdoost@gmail.com>
> Date:   Wed Sep 25 10:48:30 2019 -0500
> 
>     i40e: prevent memory leak in i40e_setup_macvlans

Queued now.
