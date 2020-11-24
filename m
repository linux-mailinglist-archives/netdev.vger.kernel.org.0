Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06682C284F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbgKXNjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388459AbgKXNjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 08:39:53 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73754C0613D6;
        Tue, 24 Nov 2020 05:39:53 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id e8so6611830pfh.2;
        Tue, 24 Nov 2020 05:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z2mGDpaSXN2gDvSIKnNUDnQuTQrrtOklYo6c+3lCrEE=;
        b=gjSMwLwu5klWgdX8jLjfka1l0hbnhQkhgz12Ny095RrCHHhk0Gc8jNxRvJuIul5Hpy
         v0K9R1hTsW2ZptqffmXtK8cjpVoX9r8B52bhIl//YFzPFRvNxBsyEIbQtmPXS3qkMPkS
         J1HBIcx7dqcY8klHy93LVUDNEmRono6HBxLKyHptIpjUSKJiIQv+mQfckZy2WZyhZFmF
         zy7nL6sJiIRI5Fh0VZVM+oLG2B6jnz8Q8XwThquZtgGWnl5JQf13gURL0V0t+/F6MfYm
         f+4Tjd0IBm9NJG++RegoYDJDfnNJ5V7WLtamHVls/LNM81W7TQ5FThQeYnKdo85Q45/N
         FJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z2mGDpaSXN2gDvSIKnNUDnQuTQrrtOklYo6c+3lCrEE=;
        b=BCTG39v8qmPsRt1D73JwAIzOYpGHsn97Mp4bQBkwl7UNy6EJWtPuUqMHavtXfo+UFM
         TPCAIlmiJkd02CSFgZtrOisnqfgfRRjd+b0QXlAgayICm9zUfK21cVJTajoM8bkeJI3w
         RWE25OmTU5YiENFDQKhq3EF+0lt2dIg6WUYO76+ZcXQKvfXffkoyGAtASpzXSbfD1wdx
         rM/76n8JYCYPZLg43GTOceRjhHoopThleUDQfW0bJDpbdjxry/4ktEAhYBDtK1GsVpbh
         gGgz7j2JaL3ikWb4nzhLETteuMc+b65nSkLLNDNTpDVv46w1ez2S6XOQGiPe30PhKByk
         NCww==
X-Gm-Message-State: AOAM532XEX5TV0MTaYlnPfr4qP/BDh3H7XJ+dnP1u+eYFTGWA2X14/Nr
        NbYRriL/iZq+lSPLsEjubv8=
X-Google-Smtp-Source: ABdhPJyfiWkk87V09E5vWc6HfinMlfgqhPz2A86smBKPeboGn4hvg2dVSLly2lR0mLT2TFU5by5mkw==
X-Received: by 2002:aa7:8297:0:b029:198:15b2:ed0a with SMTP id s23-20020aa782970000b029019815b2ed0amr4132235pfm.47.1606225193026;
        Tue, 24 Nov 2020 05:39:53 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a2sm1500351pfo.117.2020.11.24.05.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 05:39:52 -0800 (PST)
Date:   Tue, 24 Nov 2020 05:39:49 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: ptp: use common defines for PTP
 message types in further drivers
Message-ID: <20201124133949.GA16578@hoboy.vegasvil.org>
References: <20201124074418.2609-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124074418.2609-1-ceggers@arri.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 08:44:15AM +0100, Christian Eggers wrote:
> Changes in v2:
> ----------------
> - resend, as v1 was sent before the prerequisites were merged
> - removed mismatch between From: and Signed-off-by:
> - [2/3] Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> - [3/3] Reviewed-by: Antoine Tenart <atenart@kernel.org>
> - [3/3] removed dead email addresses from Cc:
> 
> 
> This series replaces further driver internal enumeration / uses of magic
> numbers with the newly introduced PTP_MSGTYPE_* defines.

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
