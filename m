Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8722BC2A5
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKUXgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgKUXgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:36:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A093208C3;
        Sat, 21 Nov 2020 23:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606001771;
        bh=vE4eAZbWTsmHCn6zLv0gRSIGsOmeO9ynwjm4+1q2BeA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B+wCzrPtP/Ar9AQWsNNXMNQ9IJyD0k8lOStNnkAIMijVsoT3GtqGEIGKHRZ0105cv
         BNpRT20qjFanb0eCubIhfIJbamd/d1K5GkzwUU22k9erayAS8k1UHZ645e9xFsQdwL
         txykSg5qvDxXLE/E26NQ3oRInQ6k9F5Hym/KV2Jo=
Date:   Sat, 21 Nov 2020 15:36:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 01/15] ibmvnic: handle inconsistent login with reset
Message-ID: <20201121153605.00862a91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120224049.46933-2-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
        <20201120224049.46933-2-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 16:40:35 -0600 Lijun Pan wrote:
> From: Dany Madden <drt@linux.ibm.com>
> 
> Inconsistent login with the vnicserver is causing the device to be
> removed. This does not give the device a chance to recover from error
> state. This patch schedules a FATAL reset instead to bring the adapter
> up.
> 
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

Please provide fixes tags for all the patches.
