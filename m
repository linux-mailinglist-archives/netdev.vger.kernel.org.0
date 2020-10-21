Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE7929472E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411915AbgJUESL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411911AbgJUESL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 00:18:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C979221FC;
        Wed, 21 Oct 2020 04:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603253890;
        bh=ACz5OGB45xDaoHkseMZjhNZd3N8lHTTUqwCx7Wg5LHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WDKlE4jmPsEXA2fx5EmGj5AoO2dg5RBLisylpMQsYYFOctkHKYQTP3q1hLp0O4i0Y
         5Kkqtw4M7D/Ooq64j/TcQqra0trU+DIvfY9o5d/x0f7dcaEBbR3DKvhTHbA10ja2Lm
         1n2pLgFEclN2j+2I9MMWHw9UBdSKRMKb5E0yM57Q=
Date:   Tue, 20 Oct 2020 21:18:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexander Ovechkin <ovov@yandex-team.ru>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] mpls: load mpls_gso after mpls_iptunnel
Message-ID: <20201020211809.432035bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8d95a3f7-6839-5cf8-f844-2b0b14e50890@gmail.com>
References: <20201020114333.26866-1-ovov@yandex-team.ru>
        <8d95a3f7-6839-5cf8-f844-2b0b14e50890@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 20:28:25 -0600 David Ahern wrote:
> On 10/20/20 5:43 AM, Alexander Ovechkin wrote:
> > mpls_iptunnel is used only for mpls encapsuation, and if encaplusated
> > packet is larger than MTU we need mpls_gso for segmentation.
> > 
> > Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> > Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
> 
> Reviewed-by: David Ahern <dsahern@gmail.com>

Applied, thank you!
