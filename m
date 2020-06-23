Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE78A206038
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392270AbgFWUkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392261AbgFWUki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 16:40:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB8D2053B;
        Tue, 23 Jun 2020 20:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944839;
        bh=baFmiFeMvPYM1cdYgE9xxA6ACRvSD3pGTe8W4TBTj+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qDj+CdDeBXavXfi0DuOYeGNycoBsYTlqNH7BXiRr0gko/fbXupzBxMCUyFmCKz0lY
         qiEytT04DtNZFio+AUt0ofEpJkGGravj4VghelyZdtjSpSuTwPCuGKQt2qVPOagA+1
         8Wj9G1z2CSHrPczIURR39twmoyx+jZkNtUyr0Vhc=
Date:   Tue, 23 Jun 2020 13:40:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "Kwapulinski, Piotr" <piotr.kwapulinski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 4/9] i40e: detect and log info about pre-recovery
 mode
Message-ID: <20200623134037.3cde6263@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D94044987324EF@ORSMSX112.amr.corp.intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
        <20200622221817.2287549-5-jeffrey.t.kirsher@intel.com>
        <20200622165552.13ebc666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61CC2BC414934749BD9F5BF3D5D94044987324EF@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 03:13:35 +0000 Kirsher, Jeffrey T wrote:
> In patch 8, the functions are not so small and simple.  Are you sure
> the compiler would inline them if we did not explicitly 'inline'
> them?  I want to make sure before making that change.

I'm not, but why are they supposed to be inlined - programming promisc
seems hardly to be so performance sensitive we can't take a function
call...

Also can the functions be reordered there so no forward declarations
are needed?
