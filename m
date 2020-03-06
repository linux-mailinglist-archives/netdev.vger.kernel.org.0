Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57CBF17C59E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgCFSoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:44:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgCFSoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:44:32 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD673206E2;
        Fri,  6 Mar 2020 18:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583520272;
        bh=0vIrdUxz1eQTd/O7Hq6//dkTM0rWOSi0mbdcE/5p3Go=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X372WFRKzJstUmBICeZV+kNIFO8vRHXms6DkZO49OL7UXWhAiNUvFXCnEKDkAtE2q
         O8uwFktioQR0XpgMaQlJYc0mGm3/SZ48eAxpGKNdPtBZAGlViXS6PzgXlYJG0kkMfR
         xGApFrkqcWKh3ZRp0KlZU9y74B1+sQ+99hmgQ2Kg=
Date:   Fri, 6 Mar 2020 10:44:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: Re: [PATCH net-next 0/2] s390/qeth: updates 2020-03-06
Message-ID: <20200306104430.712ea933@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306081311.50635-1-jwi@linux.ibm.com>
References: <20200306081311.50635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Mar 2020 09:13:09 +0100 Julian Wiedmann wrote:
> Hi Dave,
> 
> please apply the following patch series for qeth to netdev's net-next
> tree.
> 
> Just a small update to take care of a regression wrt to IRQ handling in
> net-next, reported by Qian Cai. The fix needs some qdio layer changes,
> so you will find Vasily's Acked-by in that patch.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
