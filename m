Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83AE2F5882
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhANCgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbhANCgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 21:36:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4592235FA;
        Thu, 14 Jan 2021 02:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610591754;
        bh=OnrEzauNIUmRoTePTl/di2SdI5/HWt+oHV9ERTTYpHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cf6rChqUsRowWZtFyN5DQ4NEB0ojvM8pRPVvGqjlj7lRHIyCp0tThuAnSPeUnEe10
         nMw6QeuBYpLSdFqHIusats0zGv3jyOCxP9zB/DeHsq6kZLm8SvHxsAx5VUsZRKKwL8
         o97SCGnNS9EF3+fTKFb1WDq4xQlchR8AkwmH2wO5Wz+e600erG1l6iTJUpVVflmG6q
         0FvyuDLcqE2xmEWU6oSZyG4CW1jQAyAIpJDSnk5VDeDQcvxq+ssVjkZXqs6bVkAxMf
         XXjdfMAD2pbOtWnuT8xP+gE1q7ay4yNdoSaxvskHCqEpc4TwzjzjZzHT45Silb4oGL
         f9v1FRAJ+j5mg==
Date:   Wed, 13 Jan 2021 18:35:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Dany Madden <drt@linux.ibm.com>,
        Daris A Nevil <dnevil@snmc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Erik Stahlman <erik@vt.edu>,
        Geoff Levand <geoff@infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Allen <jallen@linux.vnet.ibm.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Lijun Pan <ljp@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, Paul Durrant <paul@xen.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Cammaert <pc@denkart.be>,
        Russell King <rmk@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Santiago Leon <santi_leon@yahoo.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Wei Liu <wei.liu@kernel.org>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 0/7] Rid W=1 warnings in Ethernet
Message-ID: <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113164123.1334116-1-lee.jones@linaro.org>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 16:41:16 +0000 Lee Jones wrote:
> Resending the stragglers again.                                                                                  
> 
> This set is part of a larger effort attempting to clean-up W=1                                                   
> kernel builds, which are currently overwhelmingly riddled with                                                   
> niggly little warnings.                                                                                          
>                                                                                                                  
> v2:                                                                                                              
>  - Squashed IBM patches                                                                                      
>  - Fixed real issue in SMSC
>  - Added Andrew's Reviewed-by tags on remainder

Does not apply, please rebase on net-next/master.
