Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAFD254E9D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 21:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH0TcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 15:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgH0TcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 15:32:19 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D869D2087E;
        Thu, 27 Aug 2020 19:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598556738;
        bh=ZKQfzne1WFKttW9vipb+mAV6h2B+5JojspE+z3uNiw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=duYXyUVoGSEPD8hKaa5AUIOeOnEBc4HbTKS4eb3MfA2afGgb9gViPBJVRI+PhNGkp
         Bhf6VdPmd82ErRjsx1wYzMTvFDU9ulQmsxd904eW3urjlYS6yEkv/fNAqsoIM8UC+O
         u0YIk2yiY8Z04glW8DFo4RsRfqHpLMTsVK+P2k8Q=
Date:   Thu, 27 Aug 2020 14:38:20 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] atmel: Use fallthrough pseudo-keyword
Message-ID: <20200827193820.GE2671@embeddedor>
References: <20200821065355.GA25808@embeddedor>
 <20200827130933.EC07CC43391@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827130933.EC07CC43391@smtp.codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 01:09:33PM +0000, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:
> 
> > Replace the existing /* fall through */ comments and its variants with
> > the new pseudo-keyword macro fallthrough[1].
> > 
> > [1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through
> > 
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 

Thanks, Kalle.

--
Gustavo
