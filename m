Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB145D269
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244980AbhKYBXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238282AbhKYBVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:21:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DEE6610C8;
        Thu, 25 Nov 2021 01:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637803120;
        bh=S6/dYfL8C+gVawnxKyb76wzs7aqcdtjHlBozVIAFfYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d9iyHi0yuU1M13/CRLP+/aRJqbzc5XjJhIl7Tg806MecOiJ6RK7YEgRl8Tjw+zk1Z
         pc6L0tvhaCc7zeBFrXMyVNk4ZyN3PO1opX2s3dnlKBQw4f16e3BxBHPzf0vyBN5rWz
         sgtwweRrYxpOcFR/hjoqN7CCcnEMct7d8ocNCIkGcgo7KHlIag6XDx5EGrO5eTsrDc
         oWMOrBk3pI4Wcrx/Rpaj5/oN9i/mErIKsuNjagjoO1SdqZ6yFIF8Jy6bj7ZTmvxBEw
         KDSO2BKgICyK03OvFsab2vAdzmD9VjW7J+ef8ncaIPBBOu69kR9R5H0rfgH2sot5+2
         sav8MoftB/dlA==
Date:   Wed, 24 Nov 2021 17:18:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 net-next] Bonding: add arp_missed_max option
Message-ID: <20211124171839.09e31044@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123101854.1366731-1-liuhangbin@gmail.com>
References: <20211123101854.1366731-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 18:18:53 +0800 Hangbin Liu wrote:
> Currently, we use hard code number to verify if we are in the
> arp_interval timeslice. But some user may want to reduce/extend
> the verify timeslice. With the similar team option 'missed_max'
> the uers could change that number based on their own environment.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> ---
> v2: set IFLA_BOND_MISSED_MAX to NLA_U8, and limit the values to 1-255
> v3: rename the option name to arp_missed_max

Jay, looks good now?
