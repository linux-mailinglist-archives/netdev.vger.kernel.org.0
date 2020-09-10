Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E232A264F37
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgIJTiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgIJTiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 15:38:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3798021556;
        Thu, 10 Sep 2020 19:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599766682;
        bh=bdD2AYYqs+4x4expaBzr59fx8t7eVErHy3jZh2ZesWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UE0SO8vij6S15zbtG8SZosXnDHdOzmUk/Z/lk88WjWOr2bj0csGGnFZgq3ve6j2jl
         YdPe5Fo3VLOAI4PfM9mwP+I4QjcsyNXo6AmXSlxVPoo5KTaAoa5NvpNcCUZjB0lkd9
         7PtV2/bzAVQVWsya/9hkRLeR/fX0JxqYUVbCbR+Q=
Date:   Thu, 10 Sep 2020 12:38:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] Fix some kernel-doc warnings for
 e1000/e1000e
Message-ID: <20200910123800.74865996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910150429.31912-1-wanghai38@huawei.com>
References: <20200910150429.31912-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 23:04:26 +0800 Wang Hai wrote:
> Wang Hai (3):
>   e1000e: Fix some kernel-doc warnings in ich8lan.c
>   e1000e: Fix some kernel-doc warnings in netdev.c
>   e1000: Fix a bunch of kerneldoc parameter issues in e1000_hw.c

You should put some text here but I can confirm this set removes 17
warnings.
