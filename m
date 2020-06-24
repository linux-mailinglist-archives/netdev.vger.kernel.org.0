Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35432068E5
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbgFXAMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387693AbgFXAMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:12:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C912078E;
        Wed, 24 Jun 2020 00:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592957566;
        bh=/jrmwucixqzK0ionOJGD//pHrxb17NQdO9kWZG+1YIo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gi4qW6TeuKQSdAzy75iD7ojeri1C59K87f2MGEOTg79SpIE5MHSorzGA5G+pUQ72V
         XRNbmULaI5LkgrU8upGKI+IceZQ1S8RC7HwIxIsNn/UdkSRQqzDccH0Kb+csZzWo+v
         fCFqJEyJSCww/uhvhZ6MSYYnZpoe9O2ay/40ZG6w=
Date:   Tue, 23 Jun 2020 17:12:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 0/5] Eliminate the term slave in iproute2
Message-ID: <20200623171244.54bd980c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623235307.9216-1-stephen@networkplumber.org>
References: <20200623235307.9216-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 16:53:02 -0700 Stephen Hemminger wrote:
> These patches remove the term slave from the iproute2 visible
> command line, documentation, and variable naming.
> 
> This needs doing despite the fact it will cause cosmetic
> changes to visible outputs.

And non-cosmetic changes in machine-readable (JSON) output :(
