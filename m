Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976D92FE32E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbhAUGqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbhAUGpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 01:45:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F9822396D;
        Thu, 21 Jan 2021 06:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611211500;
        bh=t98VKbAytk4/Jdb+mLnBEeEBWuAWMas4Xkdwp5U+xtA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l4QNSxsUuJUlrN77Wb5PKcW1bmTB9ZSpAMM5AjokKdF97cRihiKoVKiMzVhKamaRP
         Y4RXaS+x6SviMdLXgbFJTVd8UIGMkVQ+R3avhBFV8YvXhduTKXuUg/7a8x/ORCGjDz
         ipe6O9YxaxbKVVb/KsbLSUPudw8CJsYI5AwthlNNdDOevmygC7VlEG3jj2VSt2zDvc
         SQpV+DDGyV7ie1SmREmLplJmKRY7j5A/2fPJsuLss5au7C/6U9Ok4ZyQ2LYMN5idL9
         0J2Ep2Yp4vkmAsZHroj6GPToEm6jJp/FKp5DlRaEK5oEhHUZrPB9atrTbCxGudmeLx
         bx8jEGzLbASGA==
Message-ID: <a1e52f492339f611d42bdd7f761150ba3b6964d5.camel@kernel.org>
Subject: Re: [net-next V8 03/14] devlink: Support add and delete devlink port
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, sridhar.samudrala@intel.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Date:   Wed, 20 Jan 2021 22:44:58 -0800
In-Reply-To: <20210120090531.49553-4-saeed@kernel.org>
References: <20210120090531.49553-1-saeed@kernel.org>
         <20210120090531.49553-4-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-20 at 01:05 -0800, Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
[...]
> +	/**
> +	 * @port_new: Port add function.
> +	 *
> +	 * Should be used by device drivers to add a new port of a
> specified
> 

Sorry about the mess, this is not exactly what Jakub asked for.
I will re-spin and send V9.



