Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D132B4C92
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbgKPRWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731001AbgKPRWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:22:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095B5221F9;
        Mon, 16 Nov 2020 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605547368;
        bh=XkOI4omX6oPfPnsf9mxNu0c5CYfQPJyu61HxkwQ6oHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WqRLGp6N8JtxTRNfka/uJjWh4rO33g1kbf16TuvTrferfZneopDlZeenuPDWLi8B6
         tO+yBbmCm1ZD+moqEAq4sO1Vddx27/kdl9wNbth0/85W2GbM3z7LUvlTa72bpGdhI5
         /VMqxErV4BB38KZ/Sj3uoCKrco2IqDxse4xo9/6I=
Date:   Mon, 16 Nov 2020 09:22:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     laniel_francis@privacyrequired.com
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, keescook@chromium.org
Subject: Re: [RESEND,net-next,PATCH v5 0/3] Fix inefficiences and rename
 nla_strlcpy
Message-ID: <20201116092247.608b4f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201115170806.3578-1-laniel_francis@privacyrequired.com>
References: <20201115170806.3578-1-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 18:08:03 +0100 laniel_francis@privacyrequired.com
wrote:
> This patch set answers to first three issues listed in:
> https://github.com/KSPP/linux/issues/110
> 
> To sum up, the patch contributions are the following:
> 1. the first patch fixes an inefficiency where some bytes in dst were written
> twice, one with 0 the other with src content.
> 2. The second one modifies nla_strlcpy to return the same value as strscpy,
> i.e. number of bytes written or -E2BIG if src was truncated.
> It also modifies code that calls nla_strlcpy and checks for its return value.
> 3. The third renames nla_strlcpy to nla_strscpy.
> 
> Unfortunately, I did not find how to create struct nlattr objects so I tested
> my modifications on simple char* and with GDB using tc to get to
> tcf_proto_check_kind.
> 
> If you see any way to improve the code or have any remark, feel free to comment.
> 
> 
> Best regards and take care of yourselves.

Applied, thank you!
