Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571C43EBB81
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhHMRdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhHMRdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAFB060FC4;
        Fri, 13 Aug 2021 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628875964;
        bh=XnqgDuCedlf8/F7fn4NUZfJ56e03L1IOAlMKUGO0Kjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jDzBNO9xNuOb8GaWiNVIslzrnBYUd0KBTzbST70z7+ZfaHkR3yQr54x7Tz3Yd3evt
         yD8GD8kdGEviIvxFMedgnFDM82t1EfwtZ+QMtZmkSYGm+BpQW+D2HnHOtkkkk5rJnX
         xGy0jsPx2Eq/fgv/Bfl0nbMq7CbcPIa3A8bhU+IjTmnP3doQWQnF1+90Gl2w703VW1
         UHLNK9Ss9TIdjS/tHYnZETbzhyHLwnO2WmuCBgaCzyVJdLGAtdG69zLUmAIUpUs3Sr
         G2sZglhmD0nlFWEJwfXshwG5V+XSbxNLFDbxvcClZNN7xIbg+KC9nBODgeBKhRQkvx
         Ma3Ksi1fkNFdg==
Date:   Fri, 13 Aug 2021 10:32:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rao Shoaib <Rao.Shoaib@oracle.com>
Cc:     netdev@vger.kernel.org, viro@zeniv.linux.org.uk,
        edumazet@google.com
Subject: Re: [PATCH] af_unix: fix holding spinlock in oob handling
Message-ID: <20210813103243.51401dcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
References: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 15:06:52 -0700 Rao Shoaib wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> syzkaller found that OOB code was holding spinlock
> while calling a function in which it could sleep.
> 
> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
> 
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> 
> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>

IIUC issues pointed out by Eric are separate so I removed the spacing
between the tags and applied, thanks!
