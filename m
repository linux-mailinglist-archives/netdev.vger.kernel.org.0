Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D04240CDC
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgHJSU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgHJSU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 14:20:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D4B207FF;
        Mon, 10 Aug 2020 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597083627;
        bh=RfnvddbXs67O3oANFnS11BjPH1/O5YLPIMd2VCPzBX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zedml/KW8R7fTSARLI7t3npnpQH4znnxA2jY40g/JmPcMKxGuO68OHz/gj8kI96XX
         sgHvL83XU0d5nIHtIRMwMGsKaUq0Yo4SWaOzTtmed8nuswpDYOAK42RzG9x+PWQLYg
         eebhtcBApvosckI33Vix5cPZsCPJvcu5nls8uW2Q=
Date:   Mon, 10 Aug 2020 11:20:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jonathan Adams <jwadams@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
Message-ID: <20200810112025.05825daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <191cb2fc-387a-006e-62fd-177096ac480e@gmail.com>
References: <20200807212916.2883031-1-jwadams@google.com>
        <20200808020617.GD2028541@lunn.ch>
        <191cb2fc-387a-006e-62fd-177096ac480e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Aug 2020 09:59:34 -0600 David Ahern wrote:
> On 8/7/20 8:06 PM, Andrew Lunn wrote:
> > So i personally don't think netdev statistics is a good idea, i doubt
> > it scales.  
> 
> +1

+1

Please stop using networking as the example for this.

We don't want file interfaces for stats, and we already made that very
clear last time.
