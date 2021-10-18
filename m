Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3164328E9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhJRVRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRVRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:17:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 802AD6112D;
        Mon, 18 Oct 2021 21:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591693;
        bh=EWaVbvXwPOfOJaJ7PODosMCA0CEx1uJeH4dhO1/nBAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HjAbFjoEzwcMFpkYfB9go++lcHB6GCAHM+Hqi9fuLfp0pNj3rgoGQVkmFmqg03ODE
         95Adu0msWYYd/6ziLpBOACC3e2uJTPSho3A4nk6wL3ASwOuQoFhxgR0RIaS8d5GFiv
         KTyNP1Vio8rqvReJTD7Oz/XJVoCl4JvcQs6l+DHDAxen6rc+iOW1frKATzGj51aGgL
         qq/V1YovIi0fRD0Qw2k1WL4PjKBb3boCE/nRtDriDdGmRBgxP8rkDKHvKN47VFdyhg
         qHd+qcOrWAFCzkwnmHvlrfFww8VAEsH8VG8NgqoTz5ikcJDWwFJSgESz9LPd84PgjW
         9TV2w+G8UqKeg==
Date:   Mon, 18 Oct 2021 14:14:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     h.morris@cascoda.com, alex.aring@gmail.com, davem@davemloft.net,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ieee802154: Remove redundant 'flush_workqueue()' calls
Message-ID: <20211018141452.544931a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0a080522-a30b-8b78-86d2-66c1c1a5f604@datenfreihafen.org>
References: <fedb57c4f6d4373e0d6888d13ad2de3a1d315d81.1634235880.git.christophe.jaillet@wanadoo.fr>
        <0a080522-a30b-8b78-86d2-66c1c1a5f604@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Oct 2021 22:54:52 +0200 Stefan Schmidt wrote:
> I have nothing else in my ieee802154 tree for net right now so it would 
> be great if you could take it directly. 

Do you mean net or net-next? This looks like net-next material.

Just to be sure, applying directly is not a problem.
