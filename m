Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332E22F04F8
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbhAJDih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbhAJDig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:38:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10B7822BE8;
        Sun, 10 Jan 2021 03:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610249876;
        bh=fkpbPudBUOaqRgEY8XQLmICypZuc62vmH/tpffEFHB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pglq8hvWqc63IRv1z8ZGmaNSBkbr+Xicg0P5jfOqjIy1ngxDIQ9Rm2VCSDqDNkyeh
         D8is2E+ORwUN6Edfml7C5sUsSv+Zak92e6z6RbcrZYe0KSH7KvYSc5VxdIj0NfCMdt
         5aRTZxD6hptYT+KFtjnectEzehYajGj2IgWroI8578AIn5O6CxQRoUEbmrHFWb8/An
         +SkPEGmDJSnOIV+sav/weGZ5ksRk2zscxHDMzNULJbxgHfQis3yweUOlNta+3ptIVP
         OsvpUrxfGFsWXJ4q38BSzs8Xj+5Cs+DGvcoqDSzrsv4MMcRzMGZjSJc8xv/G33KP22
         H78mFAUg1FziQ==
Date:   Sat, 9 Jan 2021 19:37:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH 2/7] ibmvnic: update reset function prototypes
Message-ID: <20210109193755.606a4aef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108071236.123769-3-sukadev@linux.ibm.com>
References: <20210108071236.123769-1-sukadev@linux.ibm.com>
        <20210108071236.123769-3-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 23:12:31 -0800 Sukadev Bhattiprolu wrote:
> The reset functions need just the 'reset reason' parameter and not
> the ibmvnic_rwi list element. Update the functions so we can simplify
> the handling of the ->rwi_list in a follow-on patch.
> 
> Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
> 

No empty lines after Fixes tags, please. They should also not be
wrapped.

> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Are these patches for net or net-next? It looks like they are fixing
races, but at the same time they are rather large. Can you please
produce minimal fixes, e.g. patch 3 should just fix the existing leaks
rather than refactor the code to not do allocations. 130+ LoC is a lot
for a fix.
