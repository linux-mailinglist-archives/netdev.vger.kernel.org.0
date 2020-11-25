Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3A42C458B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbgKYQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:45:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgKYQpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 11:45:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABB382083E;
        Wed, 25 Nov 2020 16:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606322706;
        bh=kYfNPvb2dwosh8y/MWAsihzlZt0U2BNjpxs+NTn4wDw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XAc0Ta0OoyIP5Dn+EJFdOWFX/ZjVub2HMoJ9ehwoiFlcJTEy6cwUYZE3Bt/r5b9HY
         tTfL2x1l/GqjvUidvzbbDQuG1oFDvu5lHY1hE1x0sGWOx01I5wVwyVbeQbM0Pcoj0Z
         Hiwhy5Km91g6lvwB08OsNMymhBCLk7N/o3WQsee0=
Date:   Wed, 25 Nov 2020 08:45:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marco Elver <elver@google.com>
Cc:     davem@davemloft.net, johannes@sipsolutions.net,
        akpm@linux-foundation.org, a.nogikh@gmail.com, edumazet@google.com,
        andreyknvl@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, idosch@idosch.org, fw@strlen.de,
        willemb@google.com
Subject: Re: [PATCH v6 0/3] net, mac80211, kernel: enable KCOV remote
 coverage collection for 802.11 frame handling
Message-ID: <20201125084504.1030ffe4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125162455.1690502-1-elver@google.com>
References: <20201125162455.1690502-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 17:24:52 +0100 Marco Elver wrote:
> This patch series enables remote KCOV coverage collection during 802.11
> frames processing. These changes make it possible to perform
> coverage-guided fuzzing in search of remotely triggerable bugs.

Hi Marco, this stuff is only present in net-next, and were not reverted.

You need to rebase and replace the existing implementation.
