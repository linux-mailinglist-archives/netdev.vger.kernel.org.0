Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7E043E454
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhJ1O6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhJ1O6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D88F661040;
        Thu, 28 Oct 2021 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635432945;
        bh=wywZcnIPMQn6jXuJbmOEJtlKLNH5E6uEBOolphOrQ/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LJ6nA1cDfWTFHv8P1huhwae4v8Lk77uApc/SnVrVilLDBvunv6Ggk6Q3PNPKTCjXJ
         K2RL+9jjd2p6wwk0urZ5xH65jAdmOFcKVjQk2+S5YxJafVT40plnn3nRgHwQlz9rt2
         QgksVEC4/JDIIa5mhaNVYbFJIfetObPS1h355WCah1WTr5Kp7LaXcwQhqZdmMrEkOy
         sEWq4N0ygYup3Dxn8edVrsRI0zurKx5BtfqYBsPmTP0A4MhHsVE5Got86kIFudwdwN
         Ctn9VjcS+Q7vYq4PjY6EsFDL1z1NXfdj5Mz+W85YoyckhQ847FrWdahifo8FIeO5l6
         jRxYs2nor1r7Q==
Date:   Thu, 28 Oct 2021 07:55:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH ipsec-next v2] sky2: Remove redundant assignment and
 parentheses
Message-ID: <20211028075543.587a7848@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028031551.11209-1-luo.penghao@zte.com.cn>
References: <20211028031551.11209-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 03:15:51 +0000 luo penghao wrote:
> The variable err will be reassigned on subsequent branches, and this
> assignment does not perform related value operations. This will cause
> the double parentheses to be redundant, so the inner parentheses should
> be deleted.

Why the "ipsec-next" in the subject? :)
