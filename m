Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D499224DE97
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHURfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgHURfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:35:34 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D6620658;
        Fri, 21 Aug 2020 17:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598031333;
        bh=Ur7pAVROweA0yMFOe8Ac75pq3QEwCZ/uV+SsFFgvizg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FidXo/euj0HXOw21bUWGqQrmlVjJ4Y8xyKeSWzw+CI15oJam8JkueoLBLkMf0YDAS
         JkUWY75LhDnUOtibyZ5te2FyNI/61yw4VT/HYMPKjMseZLMgURzQNjVkDFFgMZmZbK
         epw6J9FyEU2hCK2zn9ZsI3jdGl82bfDhYtEK0QtQ=
Date:   Fri, 21 Aug 2020 10:35:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 07/10] qed*: make use of devlink recovery
 infrastructure
Message-ID: <20200821103531.094d64e6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820185204.652-8-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
        <20200820185204.652-8-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 21:52:01 +0300 Igor Russkikh wrote:
> Remove forcible recovery trigger and put it as a normal devlink
> callback.
> 
> This allows user to enable/disable it via
> 
>     devlink health set pci/0000:03:00.0 reporter fw_fatal auto_recover false

Acked-by: Jakub Kicinski <kuba@kernel.org>
