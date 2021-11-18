Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394DB4560AF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhKRQlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhKRQlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:41:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD6F61175;
        Thu, 18 Nov 2021 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637253515;
        bh=mArgnRfcSnN8b/ojn8BR4nw9zNy3hAJuT1DaSGX+/S0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LOpF3U+RhD3PYGhvtNjhix49h84nEdkx6qfhXRJ0tLrPRHUEMnhW4zAxj7EDOBp0C
         KP2yIQA9MjKuyAlrKnNMQ7YSw5Ycvjvz6JH93VcBX1CSOj9cV5OeKC+1EWrVsX2Xck
         Uhc5VR57cKbTMbpIZYs2ah24Oa0KiYwfZt+nFP0MH8digYPABLtuE8NW7hdotaKudO
         t1TZnUNhcDI9nYgc2L68noRfjJWx/rUCnEJLSLDPNarqNvhzboPyAAzzNbNzMdeaMW
         tiIwvcu01DEz755z3618qWlFzWwYE0mltcoE57ufNH1aeXU1x9vIKia2fv+g2wqEX9
         1R3nsaJQZub6Q==
Date:   Thu, 18 Nov 2021 08:38:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     David Miller <davem@davemloft.net>, elver@google.com,
        nathan@kernel.org, ndesaulniers@google.com,
        jonathan.lemon@gmail.com, alobakin@pm.me, willemb@google.com,
        pabeni@redhat.com, cong.wang@bytedance.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        keescook@chromium.org, edumazet@google.com
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
Message-ID: <20211118083833.3c2805d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <90fece34-14af-8c91-98f5-daf6fad1825b@linaro.org>
References: <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
        <931f1038-d7ab-f236-8052-c5e5b9753b18@linaro.org>
        <20211111095444.461b900e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211112.154238.1786308722975241620.davem@davemloft.net>
        <90fece34-14af-8c91-98f5-daf6fad1825b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 08:05:01 -0800 Tadeusz Struk wrote:
> On 11/12/21 07:42, David Miller wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Date: Thu, 11 Nov 2021 09:54:44 -0800
> >   
> >> I'm not sure if that stalled due to lack of time or some fundamental
> >> problems.  
> > 
> > ran out of time, then had a stroke...
> >   
> >> Seems like finishing that would let us clean up such misuses?  
> > 
> > yes it would
> 
> so since there is not better way of suppressing the issue atm are
> you ok with taking this fix for now?

I vote no on sprinkling ugly tags around to silence some random
checkers warning. We already have too many of them. They are 
meaningless and confusing to people reading the code.

This is not a fundamental problem, the solution is clear.
