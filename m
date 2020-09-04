Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DACF25E3C6
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgIDWhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgIDWhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 18:37:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30C9B2083B;
        Fri,  4 Sep 2020 22:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599259073;
        bh=BuMxqvOBIWVktRGkHZ7UqG587bQO293E7TWSTxjeje0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wyuXlWrw+QYnGXxvidjL5uirkBa6BpC0bsBRvJtPsTXLgG8ybZLv/VYUMllouQuAq
         BV2f+etfLgYBIu0+deci0rhEvI2bPMIwx5FHnFj1zfvzHBGbY5nrD94aU7GODFu89J
         +oQmiQg0TE+8hvvmNREgbT7jZWscqqNQvRyMHkNY=
Date:   Fri, 4 Sep 2020 15:37:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: Exposing device ACL setting through devlink
Message-ID: <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904083141.GE2997@nanopsycho.orion>
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
        <20200904083141.GE2997@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
> Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
> >Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
> >VNIC devices to administrators through devlink (originally through
> >sysfs files, but that was rejected in favor of devlink). Could you
> >give any tips on how you might go about doing this?  
> 
> Tom, I believe you need to provide more info about what exactly do you
> need to setup. But from what you wrote, it seems like you are looking
> for bridge/tc offload. The infra is already in place and drivers are
> implementing it. See mlxsw for example.

I think Tom's use case is effectively exposing the the VF which VLANs
and what MAC addrs it can use. Plus it's pvid. See:

https://www.spinics.net/lists/netdev/msg679750.html
