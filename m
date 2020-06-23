Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B560720454E
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbgFWA3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731222AbgFWA3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 20:29:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2BAA20706;
        Tue, 23 Jun 2020 00:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592872171;
        bh=VZo9GdkKeMB8BOpvXmOaBiHaEYYXHNQsLT1Dm5in3BE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pzq1o1+QFv2fVZ3J2PT72Ju5jKgdF6n+vvwsDrOad3Y889ZdaZEupswO90nbnyuaj
         +soqaPBfCwLDh9lGc0OJsf8B4On6IFTMJeWPZfVO1kv4dzj4vsPZwN+GBzbKIJItHb
         AX68pIiUGWEJcXfOXe1D9ZrMjfgBLUydvPIo90aA=
Date:   Mon, 22 Jun 2020 17:29:29 -0700
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
Message-ID: <20200622172929.0a7c29d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D9404498731F8F@ORSMSX112.amr.corp.intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
        <20200622221817.2287549-5-jeffrey.t.kirsher@intel.com>
        <20200622165552.13ebc666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <61CC2BC414934749BD9F5BF3D5D9404498731F8F@ORSMSX112.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 00:18:08 +0000 Kirsher, Jeffrey T wrote:
> > There is no need to use the inline keyword in C sources. Compiler will inline
> > small static functions, anyway.
> > 
> > Same thing in patch 8.  
> 
> I am prepping a v2, are these the only issues?  Want to make sure
> before send out a v2 and thank you Jakub!

Since you asked :) - I couldn't really grasp what the 8th patch does.
Quite a bit of code gets moved around in a way that doesn't clearly
address any locking issues. Perhaps the commit message could be
improved (or even patch split into two - move code, change code)?
