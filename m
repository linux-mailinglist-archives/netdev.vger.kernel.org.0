Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF1C24937B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHSDkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 23:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgHSDkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 23:40:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B862063A;
        Wed, 19 Aug 2020 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597808415;
        bh=t4Ga3z/4dESIVxQyMK7fLHj3xMDtp3jA7eu1NuNssQE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pxlLgoS/K092lky6RdBf8UwFMPvA4ye4f4xjxOMJ4AyxAKUn5+Ld0MRh8wjlS+3Tr
         A14AoK3RN38rabQTl3qe8pxRWuSyU6Yh5x5PjSRZVuYJp9CGn8xS3Zg2LsE21Mx4em
         HtOsWgji9IjxbH6Y+QeYRXBjFvRxcquwCpo6b2QI=
Date:   Tue, 18 Aug 2020 20:40:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 18/18] gve: Bump version to 1.1.0.
Message-ID: <20200818204013.4f6ae297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818194417.2003932-19-awogbemila@google.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-19-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 12:44:17 -0700 David Awogbemila wrote:
> Update the driver version reported to the device and ethtool.
> 
> Signed-off-by: David Awogbemila <awogbemila@google.com>

Please remove the driver version, we're working on getting rid of it in
all networking drivers.
