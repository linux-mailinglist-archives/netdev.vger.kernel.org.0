Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F57396CD9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhFAFcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232924AbhFAFct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DC361042;
        Tue,  1 Jun 2021 05:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622525468;
        bh=HYlWGTbG+cIR7OURreivMrFPacFuOuovZjKJpTmLybE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LUWar4J7zFhuI8c+tox3UA60YIgQZg6zpH7t9zn/BNQjBNMfKg8ufIZ/9al1ZGg7d
         Oie+XnbDF6+E8mss/RvF/F+aPGxPnkiTD/mbe7K1+OKeKLmUsDyODhese9WMFq8YOU
         VhR0Kg/dveE5s3dlemdKu8WWygAL+Kj2HnwgKySItsLqwUN17rFgKjbh5zk97kFxqY
         247A5HW2cNd1TmiNj92Mkg2Unjs5DIrODn64TMTEsi+hC4oPDwLLXlIMgfqkuWU02r
         LEpQbRVKcoCYL6a//xCsUkkjhAU1r+aa70kA2/1OoIM40YMKWVU+Z/actREP2v3Eig
         MiKwyU+ljsRBg==
Date:   Mon, 31 May 2021 22:31:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next v2 4/8] nfp: flower-ct: add zone table entry
 when handling pre/post_ct flows
Message-ID: <20210531223107.59e15a09@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210531124607.29602-5-simon.horman@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
        <20210531124607.29602-5-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 14:46:03 +0200 Simon Horman wrote:
> From: Louis Peens <louis.peens@corigine.com>
> 
> Start populating the pre/post_ct handler functions. Add a zone entry
> to the zone table, based on the zone information from the flow. In
> the case of a post_ct flow which has a wildcarded match on the zone
> create a special entry.
> 
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

drivers/net/ethernet/netronome/nfp/flower/conntrack.c:17: warning: Function parameter or member 'key' not described in 'get_hashentry'
