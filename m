Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8726767C
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgIKXSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbgIKXSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:18:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48E6E221F0;
        Fri, 11 Sep 2020 23:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599866313;
        bh=otjbW3KXJAc1KvWhaAhzF050Zo+6jIkfo+KgbxbqvKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F+Nwz9gQr5y9FEMWAOCNG9Ys0aFkQ/gzVdJH+DVEbCwtzJGt9eCGWlYGiBAew8Jsn
         mguNsOnzOzJb8Z1pCzLohQXs811U0rH1UDooFb5dCCgn6AjSEABJ9DRyMRcw1vCgj6
         mYyrn2FRMiQVULBpX3reR5mOOXfbunX1+DbEH2DM=
Date:   Fri, 11 Sep 2020 16:18:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-09-09
Message-ID: <20200911161831.49d7cc36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <63501c55d7e60ef914dfd08defa36c0a4f1a1bb9.camel@intel.com>
References: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
        <20200910074838.72c842aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <63501c55d7e60ef914dfd08defa36c0a4f1a1bb9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 23:09:57 +0000 Nguyen, Anthony L wrote:
> > How are my patches?  
> 
> Sorry for the delay, we've had key people out on summer
> vacations/sabbaticals. I'm working on pulling people back and engaging
> others to get them tested/reviewed. Please give us a couple of weeks.

Okay, one or two weeks tops, please. This really needs to be in place
before the merge window. I posted it in time for 5.9, we're onto 5.10
already and waiting.. :(
