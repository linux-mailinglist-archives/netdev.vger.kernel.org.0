Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E1D24C2E9
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgHTQGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728802AbgHTQGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:06:08 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD072072D;
        Thu, 20 Aug 2020 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597939567;
        bh=0MXfLjq0TNJXfAuFLZJ6WujPeI1RVoOyDuDt/t24uQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KOCYq/XBSpw1cvL//USvaZkNpnumw1ualW1BRMBQGgwYn+bPBrhw/xqPh/GTLpguV
         T9wtberdmGgbqmBz0aTFdJeS09LLuYxoTwCcRijZ84AKLMZMR7joy7Lyw0DWWsb9Hj
         OZHXPFs1zsnY3Bc67b90AEj8Aj+TRAnLa63jI27I=
Date:   Thu, 20 Aug 2020 09:06:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/2] nfp: flower: add support for QinQ matching
Message-ID: <20200820090606.72dff5c7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820143938.21199-1-simon.horman@netronome.com>
References: <20200820143938.21199-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 16:39:36 +0200 Simon Horman wrote:
> Louis says:
> 
> Add new feature to the Netronome flower driver to enable QinQ offload.
> This needed a bit of gymnastics in order to not break compatibility with
> older firmware as the flow key sent to the firmware had to be updated
> in order to make space for the extra field.

Acked-by: Jakub Kicinski <kuba@kernel.org>
