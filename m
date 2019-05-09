Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF1B18FCC
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 20:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfEISAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 14:00:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36739 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfEISAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 14:00:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id j187so4292897wmj.1;
        Thu, 09 May 2019 11:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lDajNyiLeZkWi+ZncYbZJixPfPqjM2DrqCXv++hEGoM=;
        b=BF8p9vAI/DkpGGkA+R2sO/uMkxI/QjgKWD/sCLf7e9PBJD71Ms/6xub/zk2rlfW10v
         DhlDpsaqSwjjEfVUsx+gqyK7wz2eZ42JG9cb4oSATs9evrLB6dbVe1jQVLJAXpbhNelo
         cC1yxLeggdebmWPMpLZuSkcbi6ehfuIvxByw/5ycKbieuHBWY3ILJUPkgI0oWeJTpJ5p
         Jh17FiiuGHjpnJFzdocF0RCi0/DYPDp0BvUjK3X4TMtlnWTT4WcoMrFWFcTm9vWKw7U0
         1E/BKz7MbDFw/ZxrXHADMOBdYyoEUUet/S0Fd0w/FtItFmDnGnmgCZEfIniTDbB36L2q
         teXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lDajNyiLeZkWi+ZncYbZJixPfPqjM2DrqCXv++hEGoM=;
        b=mHpMPOuiEDPXDVjAkNizVH1fuqK7V60nzTsKr48TavsJU9V5PnnGfeYx8DCHckycAD
         JNFh9YvLEfAJGzp24MLQWnGKoaLkd//tBCBDEgMDP9C0oLUDJICQXWgbhEg6uqJzPPm2
         EmRqvzKo7feJHGc68eSw3jZzoZDiAnTo0wOTwOxoTidlKdJ4/Ijw6/AjQW51OKWD0/UQ
         2sMvYvasZ+mMFGhfZEpY+q2dKWWmL5gayBAaMO9PUkq0PJNJJq6jMp5Jnd0Ayi9rq6fa
         ngxV7I0x9s2YhBD0FkeCp4F7jsx/cBULRNbbRiC6WPX1VMcOkhOTwJAKloJAwkFeVRZl
         ncZg==
X-Gm-Message-State: APjAAAUhXFgD5J4vtJfRJMegTZPItnKEPnJTRVP41alwkP8cHXh8wvLK
        cCEGn+a6H3VhznEWJ2q8kYc=
X-Google-Smtp-Source: APXvYqx+MWwTxownaHVCQ8Qu4e22yDyu+r9Yg/DhLesxezeIeCdxYtyi/rwRUdm+FJpR6/rXpvfTjQ==
X-Received: by 2002:a1c:4087:: with SMTP id n129mr3885861wma.14.1557424807994;
        Thu, 09 May 2019 11:00:07 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id i127sm8173516wmg.21.2019.05.09.11.00.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 11:00:07 -0700 (PDT)
Date:   Thu, 9 May 2019 20:00:05 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 00/11] net: stmmac: Selftests
Message-ID: <20190509180005.GA16272@Red>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <20190509090416.GB1605@Red>
 <78EB27739596EE489E55E81C33FEC33A0B47AC7F@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B47AC7F@DE02WEMBXB.internal.synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 10:11:53AM +0000, Jose Abreu wrote:
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> Date: Thu, May 09, 2019 at 10:04:16
> 
> > What means 1 for "Perfect Filter UC" ?
> 
> Thank you for the testing :)
> 
> 1 means that either the expected packet was not received or that the 
> filter did not work.
> 
> For GMAC there is the need to set the HPF bit in order for the test to 
> pass. Do you have such bit in your HW ? It should be in EMAC_RX_FRM_FLT 
> register.

The problem was missing IFF_UNICAST_FLT, so netcore put the device in promiscous when adding an unicast address.

Next step will be to enable Flow Control, but I will start a new thread for that.

> 
> > I have added my patch below
> 
> Do you want me to add your patch to the series ? If you send me with 
> git-send-email I can apply it with your SoB.
> 

I will do.
I will send the patch for IFF_UNICAST_FLT appart since it fixes a bug.

Regards
