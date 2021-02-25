Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA859325425
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbhBYQ57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhBYQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:57:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09DAC061756;
        Thu, 25 Feb 2021 08:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ISiwYeYz1ThrendcIDOxZOHXULejMX34yeK70uTiZaU=; b=HatSeii41iSCJ7/7WZYq+wGAD7
        s6DrnSFTS4AwL0/ZE1eitTkxsSB8LpJC3MDlUoZgZrVAom5SiHoo0G7WxgTtb2M6Hwz9DPPL5vojY
        OEKwpXJoTmx9mKIkFewQg0iCqdwobeBmFvCKGcEdqxsHcPQsJDvJ9vwbL0Y2nx/WLhJSyEjUwiZkJ
        F3qEEafobWbbCJYF0Zq2ZOgtabPrk1USvVBCaVbUwrpAP2D3tWjAMkhMGPRzV2CIDf/3btGqoaC8V
        I894jVW6jsNK2QI3vg3EuLyyR8Ec4maImZeiyYTt7vq4LSW2UKwcSO9OYOYPZ2eGcOI2PF6yYwPq1
        p44nCK3w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFJvm-00Avt2-KF; Thu, 25 Feb 2021 16:56:09 +0000
Date:   Thu, 25 Feb 2021 16:56:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] kallsyms: make arch_get_kallsym static
Message-ID: <20210225165602.GA2605031@infradead.org>
References: <1614236917-80472-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614236917-80472-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:08:37PM +0800, Jiapeng Chong wrote:
> Fix the following sparse warning:
> 
> kernel/kallsyms.c:457:12: warning: symbol 'arch_get_kallsym' was not
> declared. Should it be static?
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Please just remove the function entirely.
