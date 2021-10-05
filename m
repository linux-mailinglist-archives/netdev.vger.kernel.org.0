Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C703423015
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbhJESgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhJESgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 14:36:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4907D611C3;
        Tue,  5 Oct 2021 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633458892;
        bh=FLlhvLXgH7FD3pxc7iUBp2jhA3ZLLW18mvEjHUc2CIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q0r+XRiR6fH3p18aYVFtH40DXiK7mJQGYnqhhECIHucW8Sl9Duj8av/5DBDVZ2Z5j
         iHEWATVsxfmYExMeGFKVp6weE1vV8UbcyhYhbljSQ3Yi9jUBAARaLvugljjSicC1O+
         +qkDTD2kN39np85sBgHYxa6OSDZ+MqGHqGzri3ynIYWbZRNH2LtZ0b5Dec+C+TMZ81
         U4Fdc6iz2+y9kFgzsIuH8QgCKHMfNF6z3dM5OmIrHxFxHflKNXJnUIcFxgXv88OEec
         CsYQRnN40mbEmP4Lbq8/k3vP+J228EMk8DLpr9wRlnA+6Gb7BubHGwr/V5c4tsCPRs
         BBhSKrDyw04QQ==
Date:   Tue, 5 Oct 2021 11:34:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
Message-ID: <20211005113451.75b72c19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163344731953.4226.7213722603777320810@kwain>
References: <20210928125500.167943-1-atenart@kernel.org>
        <20210928125500.167943-9-atenart@kernel.org>
        <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <163290399584.3047.8100336131824633098@kwain>
        <20210929063126.4a702dbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <163344731953.4226.7213722603777320810@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Oct 2021 17:21:59 +0200 Antoine Tenart wrote:
> BTW, what are your thoughts on patch 1? It is not strictly linked to the
> others (or to other solutions that might arise).

IMO perfectly reasonable, just needs a standalone repost.
