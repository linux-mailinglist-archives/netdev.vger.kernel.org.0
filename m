Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68203998AC
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 05:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhFCDnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 23:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhFCDn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 23:43:29 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAE7C06174A
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 20:41:32 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id x196so4544341oif.10
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 20:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/4RveqbdvJbI+sL7P9RkQFOVproTadjUVoq0/2eMgIM=;
        b=bxXRTKN5tIA+Th/hbDhjVToq/rSlwq0dwchO9Ha/093fNLJJ5yQd1RE16Ftei7gtOM
         WTPOkq30/gZ2s04FQjMlQHmbpuldp1sdr+OU+ceRYJwuFkgpaCkSIQZMxBUElGRMXYge
         R+OL7a6dZTsWbvrooKNlToGzXF9UyoFqExgXPFvMMxeF7FOwvI311klqMK6H7emyK1/S
         TgFBHqfndfACaqLO/4SC6h6eVSUfVw/iXYu4IpWr0fiXyQSIRMvZC+JfJRBAXhr5mUw3
         fT5EltW5opE+jXTwG8iV5mAuLTBUJRLVY2DtXM0ONGkpj1HlKkZloWsNul4BtxlOlM7l
         v0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/4RveqbdvJbI+sL7P9RkQFOVproTadjUVoq0/2eMgIM=;
        b=K6u37SyLv7WPXE0vRrOl3Q7D93lxCWP+w53UWfVywHsboJ4h72tXguPrrfUYk1F2eN
         M5yEwcPogrC7AWvTXewbl1AALHSScFSiHsr3X19eCxKdDDGkyKs43SbvFy278hm1Ofty
         tNGxmf0CbxotrLj7SA67UGyxoq2EsnietT+uMYvxYAs0AgFZMpw2dVg7hTYPKG7dkFKP
         dUe+SkCg7RgscX+HSSAq7PS7RuHnQRXQ6ShcfiLAuXcY1QZs1oRb3VF4NHIG9S+zHHNA
         hY8TtDh1tQgzXYxi/CDErtePUeIg3/vgBmj2HEFyjk+moDoMq7v6qTJthz8sXhTP0Xss
         lFTg==
X-Gm-Message-State: AOAM530bAnqTJ31TeL4rYUezWb7KUm0v/FG9ANPRGXJUdx+Raju+1TLj
        1zJ8A+BkSDiJ03coNFAGH4cHlcGnNwQ=
X-Google-Smtp-Source: ABdhPJz3djwZeFkpk4d6Rj+kWeRbQSl7exYCwJgoEF5HrfMnDUucvDyno3dAme8eK5rZOojOnyjong==
X-Received: by 2002:aca:6207:: with SMTP id w7mr6094969oib.177.1622690925324;
        Wed, 02 Jun 2021 20:28:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id m66sm450311oia.28.2021.06.02.20.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 20:28:44 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/2] configure: convert global env to
 command-line options
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210531094740.2483122-1-haliu@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c39156f1-fda1-d7a9-146a-711131817971@gmail.com>
Date:   Wed, 2 Jun 2021 21:28:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531094740.2483122-1-haliu@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/21 3:47 AM, Hangbin Liu wrote:
> 
> This path set converts the global environment to command-line options
> to make it easier for users to learn or remember the config options.
> 
> I only convert environment INCLUDE, LIBBPF_DIR, LIBBPF_FORCE at first.
> The IPTC and IPTL are not converted as I don't know what they stand for.
> 
> Hangbin Liu (2):
>   configure: add options ability
>   configure: convert LIBBPF environment variables to command-line
>     options
> 
>  configure | 49 +++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 6 deletions(-)
> 

applied to iproute2-next. Thanks,
