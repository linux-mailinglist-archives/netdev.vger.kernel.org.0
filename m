Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1B3B0A5E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFVQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFVQcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 12:32:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FBF560720;
        Tue, 22 Jun 2021 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624379407;
        bh=P5kFHivslj9SzVReWK7cgZaFDr6+rsA1/kirdgQOOdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IpAKIjcoT6fL9R2GJBExCBETjeGpl3Cdcw2SudCOe1nqBD7fGqFr8s/FiVra/CRcO
         /MY1PqhOoOz0ZD/whpR3EahsUzTCkiBH3ehoiZy/xuN+vfbQGuycf1F0LvQwvlll/k
         4SIMRSRREj6puHLfGiX7Utc3g1+iccxHhYhgvCzrY0e7KUB8IW+6r+3XXIk+AEmRGi
         DJ2Jz3lsg2V4Pizr1JQORg24GM9kOz9TJTLi515PMkXRz1TwE//WjqmtCnc1IU9eAN
         /wvbMKathTIFP5uPaQc6cltT9kFXdprU31pfb7JL4BkLLFTquHG8C4H8lO+QLOoDqe
         DAhjPKfqRl11Q==
Date:   Tue, 22 Jun 2021 09:30:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/7] ethtool: Module EEPROM API improvements
Message-ID: <20210622093005.23bda897@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 09:50:45 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains various improvements to recently introduced
> module EEPROM netlink API. Noticed these while adding module EEPROM
> write support.

Scary that 3/7 was not generating a warning.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
