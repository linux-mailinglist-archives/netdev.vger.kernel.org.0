Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD813ED9AB
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhHPPP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232181AbhHPPP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 11:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1479C606A5;
        Mon, 16 Aug 2021 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629126897;
        bh=GdelUoMdjZaOPCUuGaHuqLf1VjOiRgqibpFFTXdC/OU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qOPrdOj7yBBI9oGwGxjaOSZBW2SOZYyee/BBdNi2ElJ/r5QIE5jwdt/a2iPkD8+eD
         nu4KqXaOG5ovONdg/hf3TUMutmIAJzvYLbnhLUadmT+ZpA7SQGU16Inx9MiS3er3Me
         oS8d13pjqTaGPgajANciGZparbEcK7eTjiZodcjq5NEzaWcGumeGzgv7e76nqH0yUF
         M+QWbP7O8aLZSBm94pkKNudpdXvip8ZwgWzB0UPP8mCNXU+81tXi9Fwq0jnLoo+5VH
         2VzyLH77QPF410Ka5G9Nm1S1gZ8JO9aYITkkazhcNMQyssMBw3I/X0kBmWhuPu5sOY
         9rIGVb1T4wowQ==
Date:   Mon, 16 Aug 2021 08:14:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [Bug 213943] New: Poor network speed with 10G NIC with kernel
 5.13 (Intel X710-T2L)
Message-ID: <20210816081456.46d2730c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812092513.3e5ed199@hermes.local>
References: <20210812092513.3e5ed199@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Aug 2021 09:25:13 -0700 Stephen Hemminger wrote:
> Begin forwarded message:
> 
> Date: Mon, 02 Aug 2021 14:05:30 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 213943] New: Poor network speed with 10G NIC with kernel 5.13 (Intel X710-T2L)
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=213943
> 
>             Bug ID: 213943
>            Summary: Poor network speed with 10G NIC with kernel 5.13
>                     (Intel X710-T2L)
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.13.x
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: ealrann@gmail.com
>         Regression: No
> 
> Hello,
> 
> On a server, I use to receive files (parallel cp with NFS4) with a 10g NIC
> (Intel X710-T2L). I can usually achieve a total speed close to 1 GB/s
> (generally 4 cp at the same time, targeted to 4 different HDD).
> 
> Switching to kernel 5.13 (Archlinux) with the exact same configuration, my
> speed is now limited at 250MB/s. Rolling back to a previous kernel fix the
> speed. 
> 
> The problem is maybe in the last Intel driver i40e, but I don't really know how
> to investigate more.
> 
> 
> The problem still appear in 5.13.7 (last one at the moment).

Jesse, are you aware of anything that could cause this?
