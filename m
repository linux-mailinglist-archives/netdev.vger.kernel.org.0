Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AA932C3E7
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354458AbhCDAIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383201AbhCCHTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 02:19:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C37CF64ECE;
        Wed,  3 Mar 2021 07:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614755933;
        bh=4vVVHamDlqu1I17garzJuqfMIjvLp27q4Y6sRtg5exY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a425FmTbSdrjc2JoMvhyukaheXq1A4N7o64GcakWhFpuVmF0DP4BiiEE4NBOGBg+j
         M+Tn878WtKhbyavYpzFkpK2Ij/lEgXwkc99Jz8Jcix7NWDOd+EPQZxto5tjISTg6AJ
         2HkwTKB0ZU0nkkySiS7xvRFwkP1BT/dsbzXkjWiE=
Date:   Wed, 3 Mar 2021 08:18:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: networking: drop special stable handling
Message-ID: <YD84WnwX19boOZTY@kroah.com>
References: <20210303024643.1076846-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303024643.1076846-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 06:46:43PM -0800, Jakub Kicinski wrote:
> Leave it to Greg.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


