Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A785D1A3DA7
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 03:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgDJBRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 21:17:12 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45997 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDJBRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 21:17:12 -0400
Received: by mail-qv1-f68.google.com with SMTP id g4so303623qvo.12
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 18:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hwptylitsKMB8jaDzafBlSMcMnLPn1JKtxkfFuXkDtA=;
        b=p/jqSnxxO9pKAiJNAPiryvCX/ZfmqqPMJQaE/ToqjJeUnY/yXC8rE0IvcEvE9PZZuV
         JsncZRppjamoMvaP7SL58FibmANPA7etUBpItWYw3CFL3lHnZZj7+H6+kt6lwlCfBViy
         uyh7fJWDha2+EAiUhcQqg+5/jeYE8gPiHOYX2Im85oUmqsIF7IWTouQY6BdpC01P42vE
         zVE9KG8291ORlABgl5lFKBhDx+bD4CH/yHdGeup3sTtYe6O9FU/e4TpRY9ZLzGy9A6t6
         vOp6huoyghAdUyRCY79MkqvVP5SvSE68rHYdXFKZlujOlC3EOBo8jq0jqIMfRpllZztw
         MpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hwptylitsKMB8jaDzafBlSMcMnLPn1JKtxkfFuXkDtA=;
        b=HcKzHcFYyjtbjpmeFXza15LmpV9Z0346q3ARwa83DjMjyODW7w9iPzsl7yCOzclUVA
         OoWASQb8IGezldRC/JBDa2tCGkpQZUbtc0PUjYxMG+OL+tCWnr+5yR8RXy2CUmabchCE
         b714+WlhGdzWUfBPO38nyrVEP79CFlLEsBO5erBFyURcyksEHEfA2Y+Xo5pFD5wHUr1m
         Ji3vmBwH9JEROz29BCKGOz1FYtf97SE4q0JpcptZgtuCe4oncrgO6hluNg6sIcTmgwno
         d+uI371//bWB/HWaaonYM+7vBrrbaVSP9Vi531lyeraJY2xWK2d+bKRky7x5efgX3E7E
         B4sA==
X-Gm-Message-State: AGi0PuYbkM4iE6ShSapyEAt2Kduc1FljL3Cb7w9UG2JjlZBb8o+RLMkL
        lqnkllbTjKV7Talx+mHWJzE=
X-Google-Smtp-Source: APiQypJ3bYjO3mW+5AJaCscOhAEUr5qT2PedVuUpAZ5N0J+qxyBoNp3fEdG3teR2qW7N7cmKt/cNhg==
X-Received: by 2002:a0c:ff06:: with SMTP id w6mr3000463qvt.143.1586481432007;
        Thu, 09 Apr 2020 18:17:12 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d17sm498911qtb.74.2020.04.09.18.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 18:17:11 -0700 (PDT)
Date:   Fri, 10 Apr 2020 09:17:05 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        yoshfuji@linux-ipv6.org, thaller@redhat.com
Subject: Re: [PATCH net] net/ipv6: allow token to be set when accept_ra
 disabled
Message-ID: <20200410011704.GH2159@dhcp-12-139.nay.redhat.com>
References: <20200409065604.817-1-liuhangbin@gmail.com>
 <20200409.101355.534685961785562180.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409.101355.534685961785562180.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 10:13:55AM -0700, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Thu,  9 Apr 2020 14:56:04 +0800
> 
> > The token setting should not depend on whether accept_ra is enabled or
> > disabled. The user could set the token at any time. Enable or disable
> > accept_ra only affects when the token address take effective.
> > 
> > On the other hand, we didn't remove the token setting when disable
> > accept_ra. So let's just remove the accept_ra checking when user want
> > to set token address.
> > 
> > Fixes: f53adae4eae5 ("net: ipv6: add tokenized interface identifier support")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> It is dangerous to change this, because now people can write bootup
> and configuration scripts that will work with newer kernels yet fail
> unexpectedly in older kernels.

Hmm, this makes sense to me. Thanks for the explanation.

Regards
Hangbin

> 
> I think requiring that RA be enabled in order to set the token is
> an absolutely reasonable requirement.
