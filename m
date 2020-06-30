Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4653320E9F8
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgF3AJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgF3AJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:09:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACBB320780;
        Tue, 30 Jun 2020 00:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593475754;
        bh=qWOHGgpcP/+e/wuOBkP4VH0IjHDw9w2ffR+dS1tYc/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y9EYGWXG2LBIlQFHESd5r0hHX5j5SIX5rF0YBNAFKftpr5COq6AlUg536oV4ofxrv
         ndf8Ug61ANgtNlDI8H09C7an1ECADL4FkTNMa1lCuAf8mKM0WupKBBYEHkls2BawGI
         YkuqHcZjJNIi+7wRoBKZLE+Iw0WKJZdvqSJdBDm0=
Date:   Mon, 29 Jun 2020 17:09:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: ipa: always report GSI state errors
Message-ID: <20200629170912.39188c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200629213738.1180618-2-elder@linaro.org>
References: <20200629213738.1180618-1-elder@linaro.org>
        <20200629213738.1180618-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 16:37:36 -0500 Alex Elder wrote:
> We check the state of an event ring or channel both before and after
> any GSI command issued that will change that state.  In most--but
> not all--cases, if the state is something different than expected we
> report an error message.
> 
> Add error messages where missing, so that all unexpected states
> provide information about what went wrong.  Drop the parentheses
> around the state value shown in all cases.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

nit:

CHECK: Alignment should match open parenthesis
#105: FILE: drivers/net/ipa/gsi.c:1673:
+		dev_warn(dev,
+			"limiting to %u channels; hardware supports %u\n",

CHECK: Alignment should match open parenthesis
#120: FILE: drivers/net/ipa/gsi.c:1685:
+		dev_warn(dev,
+			"limiting to %u event rings; hardware supports %u\n",

