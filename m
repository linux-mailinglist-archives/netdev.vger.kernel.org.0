Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECA7294245
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437564AbgJTSlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437561AbgJTSlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 14:41:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55C0021D7B;
        Tue, 20 Oct 2020 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603219303;
        bh=RvCdwZNTANrHz6+/ZR94HmQJXwfylrF/TfsxkFLfkzQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ty2sGOkxa2ZkSTpxMwZ6MHqwJogJ5w4af9pIuLHvfw1PAvQ/NFFxsfdVpYlz2m1+X
         UdHyj2UrCKzmbtSougpfUA/oX/cShOIfDUxN9cUkumgw/0iKpSSma5DgU282HZeHi9
         msA9qx+0b4mWxWS47id2onK/NNPNc+mhUfP/JVkA=
Date:   Tue, 20 Oct 2020 11:41:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 15/15] dcb: Add a subtool for the DCB ETS
 object
Message-ID: <20201020114141.53391942@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c2bd8a2525a0686618ba247e43f2694c01e76a94.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
        <c2bd8a2525a0686618ba247e43f2694c01e76a94.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 02:58:23 +0200 Petr Machata wrote:
> +static void dcb_ets_print_cbs(FILE *fp, const struct ieee_ets *ets)
> +{
> +	print_string(PRINT_ANY, "cbs", "cbs %s ", ets->cbs ? "on" : "off");
> +}

I'd personally lean in the direction ethtool is taking and try to limit
string values in json output as much as possible. This would be a good
fit for bool.
