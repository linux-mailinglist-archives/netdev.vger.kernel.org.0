Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEFF2CDE64
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgLCTDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCTDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 14:03:10 -0500
Date:   Thu, 3 Dec 2020 11:02:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607022150;
        bh=2UgzL0yiy1bTOgL/Jg8kSYXa5V+etYdM2HleY7qQOOw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZAQe9qh0FwQc/JQY8PD/XGwNLMEo63WfL+1ju4urk55daC+7ZecgAvdEMwDKPmzK4
         y1bLneErVM9FOwzAX7imtxevegycgFxJx+d9PtvSMxUHaTOaztFgjCMWJUbJ46PkIL
         lQWLpMem6ApXBxC1sIDEkFzzSdCo8cegV2EvmElETCDq9LQbRGJDhSzSyBYp6QzQan
         pBgPqlLSs+xQWZxEXnYF9oMfK/8eqnadgsPpL3HfP5AUFf3L6yPyK6SB7qfx6KY/O6
         PKpDveVHepL8JpvaWdhPackXmnUoLRGfRrSkLtnFdOq47qjnpyQh3M/M6oFA5jRU+l
         TkGfia5cPY+vw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2020-12-03
Message-ID: <20201203110228.09299313@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203183408.EE88AC43461@smtp.codeaurora.org>
References: <20201203183408.EE88AC43461@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 18:34:08 +0000 (UTC) Kalle Valo wrote:
> wireless-drivers fixes for v5.10
> 
> Second, and most likely final, set of fixes for v5.10. Small fixes and
> PCI id addtions.
> 
> iwlwifi
> 
> * PCI id additions
> 
> mt76
> 
> * fix a kernel crash during device removal
> 
> rtw88
> 
> * fix uninitialized memory in debugfs code

Pulled, thanks!
