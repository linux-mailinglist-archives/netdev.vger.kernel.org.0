Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA5D42C4BB
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhJMPZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhJMPZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 11:25:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D1160FDA;
        Wed, 13 Oct 2021 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634138628;
        bh=Ggf19QGaw5mpQjgIfY/upPopDvTm8p6Y8YzPY/l9K94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DCu+uaF97rlOtz3PPrEHFRqTJTeYP3igeubiF1HwaTSQLlIPxfIIvh/1jKeiFJq3e
         Jz2CM8PwlDXOWWTBBbeR20YJ8IfNwTOdwYW6yuM9HtTjU5YV8E3kzIApjpFXJPNqVZ
         abJVAJ8FU+OJvK60DPcwaJpQXkIzyrTSLj5IXOK9zlQ7Pa8eyPbD+MLL6OnmRrW4yY
         HaH6Iw+Wq5XopO04n85rBPi0S2VPw6xA8F/N9um/b92YsSRq380qpupIAYsVw2ORfz
         3vYl7WODuMky1DA3qbBvbXWE7m2iIUZVpOlkHspgBZSpf4Y/nuys7Kbe7nHkU14Af+
         mmup/Qiu0eIaw==
Date:   Wed, 13 Oct 2021 08:23:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Combine nvmem_get_mac_address() and
 of_get_mac_addr_nvmem() together
Message-ID: <20211013082347.376c3f81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013082507.537-1-yajun.deng@linux.dev>
References: <20211013082507.537-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 16:25:07 +0800 Yajun Deng wrote:
> Patch1: move nvmem_get_mac_address() into of_get_mac_addr_nvmem()
> Patch2: remove nvmem_get_mac_address()

Please leave the mac address operations alone for a few releases, 
as I have told you I have a lot of code pending here. Thanks.
