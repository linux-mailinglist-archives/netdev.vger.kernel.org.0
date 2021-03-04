Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F1D32DD13
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhCDWdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:33:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhCDWdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:33:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A92E64FEA;
        Thu,  4 Mar 2021 22:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614897182;
        bh=2cT/45u+HTHpywFreqnSM8/ZpheiSbzvRRU3M8Ug8ds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGXFa+uE+MMfrDJt69p7O2WLC6tQWvpHFANp8q0Y9ClTlIWFaadDvkBHdErpYbmUy
         px2cA+HRZ7K+gCL4UW/y703PHRaerEujR2Le0VuQ+49HCcnhwqC6fw6iorHwtNnufV
         8zRUW+ygm9S+RwhA7oPFfKh47mcU3vWX4w0Du0qKROx6bxj5PBEGSpEjvUEuJQjH2t
         4cxHz1qYGZv+Z1MmQprLHdsNDPkoGustAI9rL/hE/Wp5/eJ9c/FWflwMMC5qOPqX6c
         wy0lh9afy322iMZlXf6u/uaP/HfLQUmSngzfd7OWJDehOB3d7Hf6bdDi9jhgqkZASB
         WSokL+0Yyp7jQ==
Date:   Thu, 4 Mar 2021 17:33:01 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 16/67] net: sfp: add mode quirk for GPON
 module Ubiquiti U-Fiber Instant
Message-ID: <YEFgHQt6bp7yBjH/@sashalap>
References: <20210224125026.481804-16-sashal@kernel.org>
 <20210224125212.482485-12-sashal@kernel.org>
 <20210225190306.65jnl557vvs6d7o3@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210225190306.65jnl557vvs6d7o3@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 08:03:06PM +0100, Pali Rohár wrote:
>On Wednesday 24 February 2021 07:49:34 Sasha Levin wrote:
>> From: Pali Rohár <pali@kernel.org>
>>
>> [ Upstream commit f0b4f847673299577c29b71d3f3acd3c313d81b7 ]
>
>Hello! This commit requires also commit~1 from that patch series:
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=426c6cbc409cbda9ab1a9dbf15d3c2ef947eb8c1
>
>Without it kernel cannot read EEPROM from Ubiquiti U-Fiber Instant
>module and therefore the hook based on EEPROM data which is below would
>not be applied.

Looks like that commit is already in, thanks!

-- 
Thanks,
Sasha
