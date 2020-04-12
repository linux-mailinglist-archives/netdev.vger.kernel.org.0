Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A121A5FAD
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgDLSNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgDLSNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:13:33 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93575C0A3BF2
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 11:13:33 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 351E7206DA;
        Sun, 12 Apr 2020 18:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586715213;
        bh=erQLqQSHOK8pQa0dXjDiMm377qh692sdK4J/aCDg3VA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CYNpHp5xwfgb67WA+ebLzG7tJh47whI7YbASldGjVSjDIZlL39Ac0voFofK6QxCPK
         gFHEAgq3NPQVcBvzDttsh/J+J0/Z3ovb6ObNDmIqmDD9yFUScIUhnwdJ+Wd2/td6pd
         Tp3E2Hzrbi5V99W6/apaBgdg7naxtGSwErxOOre8=
Date:   Sun, 12 Apr 2020 11:13:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lauri Jakku <lauri.jakku@pp.inet.fi>
Cc:     netdev@vger.kernel.org
Subject: Re: NET: r8169 driver fix/enchansments
Message-ID: <20200412111331.0bea714b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <43733c62-7d0b-258a-93c0-93788c05e475@pp.inet.fi>
References: <43733c62-7d0b-258a-93c0-93788c05e475@pp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Apr 2020 15:55:20 +0300 Lauri Jakku wrote:
> Hi,
> 
> 
> I've made r8169 driver improvements & fixes, please see attachments.

Please try to use git to handle the changes and send them out, this
should help:

https://kernelnewbies.org/FirstKernelPatch

Please make sure you remove the debug prints, and CC the maintainers 
of the driver.
