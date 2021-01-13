Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1146B2F4D64
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 15:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbhAMOkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 09:40:22 -0500
Received: from smtp.sysclose.org ([69.164.214.230]:58096 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbhAMOkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 09:40:21 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2021 09:40:21 EST
Received: from localhost (unknown [45.71.105.148])
        by sysclose.org (Postfix) with ESMTPSA id 6CBF2261A;
        Wed, 13 Jan 2021 14:30:14 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org 6CBF2261A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1610548214;
        bh=HZFaMFS9ncl2NQg8qz1I9x6cM4K8fU1EzcrsMQR3CWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BuIGFORZFkWmdCbSkreorMdaB3yT7D7mpGGvHR+nn3VROba8n2y4nj5cJv/4R10bT
         /vtUmv6nQMaryucl1Pf6zEYH9VE6Cqk6hF9oBM90zIsAC+V1evqYRxyukHNPjxjTEm
         w0xINeAITfBMWt9NlrRQUgIlmYLkmX8Tp2FWMb4gmOF/7MyPt0UzmnFizEJE6gJFhp
         KVftoro0sQ4FCw5qN9cmbDfEt9YU+l9etYaJ6ot51z26XwtAROynMgz/Xb4vg1IAqF
         bxp4Dc2wcUpVOx9LUxQvXkNJB50bEbyuX8BoqRHqdFpOEKZt9ukdCdNZjPb3kqme4t
         87LVOzpfakjRg==
Date:   Wed, 13 Jan 2021 11:29:34 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pshelar@ovn.org, bindiyakurle@gmail.com
Subject: Re: [PATCH net-next] net: openvswitch: add log message for error case
Message-ID: <20210113142934.GI116837@p50.lan>
References: <161054576573.26637.18396634650212670580.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161054576573.26637.18396634650212670580.stgit@ebuild>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 02:50:00PM +0100, Eelco Chaudron wrote:
> As requested by upstream OVS, added some error messages in the
> validate_and_copy_dec_ttl function.
> 
> Includes a small cleanup, which removes an unnecessary parameter
> from the dec_ttl_exception_handler() function.
> 
> Reported-by: Flavio Leitner <fbl@sysclose.org>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

Acked-by: Flavio Leitner <fbl@sysclose.org>

