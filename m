Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4E96093D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfGEPY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:24:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53243 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfGEPY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:24:59 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so9446979wms.2
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=776FeSmsIvO9BAuOMfeYFd0GoNy4MOugdcwM/WuTqsg=;
        b=PBgHa7BQApvEk3m/50z6wziaw2Yv01CO3uBItHINnz4ARhdSYZX/h/XULODQ7roknM
         NqXltRZuqAO6z2id1WpdesjpwtCY04gypErUOUmV5gKFajMA67bCIZ3vA1AB5OqhuK3N
         HgCHq9gQwesyRZ3Ov/OjAyMct5QUJeHySzX6dhh+f/WPco6uM/3JWEehGRyry/l/1TLL
         wqS2IauQSempUSqAoOw4K9yN+wepHNjVmxhAka9uBfUfOlpSSoqYEFb7Z1CASVzNAc8h
         XPIdkNm2jMJplehxOjzNqY4i4WKqYPR6DDfU3Aj1paFwNKVSAGg8xVdf6eEw3uKDSMOs
         CjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=776FeSmsIvO9BAuOMfeYFd0GoNy4MOugdcwM/WuTqsg=;
        b=BhwLkiCYrOGYFIqCPM5fORfC70fcbbBcyE8Z/FPXg+C46TaqiUr/eb69qrBNdxuaDs
         z5QIuY60PvKfqEjH3+XvMuQVSdeAfi8/CcuxaJbIK/ZhHU528FwvKt+W6Jvb+mjO348r
         /SuAS3wnJfC4gRSGC8ppK4yyqvyTsaNMt/vMYMqFIjxnALGIpCU1KypjdDMOsPtdKpLo
         lJC9tzd7YlF8I45I5FFOw+O9QMciZD8+WeCqUWIW4+AhLs6WZ4g5S1UKP2UssZMUKJqN
         PpBEGR5YsSJfsxlB32bFxCEVaXMqSpLuz4GTHHXglS5/lQWBnDwxTb0yo+dz/YaBZyzR
         157w==
X-Gm-Message-State: APjAAAXLGlJu9bC+zrf0LT7ibGvAqN1v3I39D7v++8eTJqF2dHhMnUiz
        RCOlLpYSuEOkN6dsMnPmNx2VtA==
X-Google-Smtp-Source: APXvYqwIn+CAMTXhiaR2OhdbdPqYr3i7rcxaiDbB1iTdnKqBy7Yo87Yv81S7nEiWLwHuACvpF1sKxA==
X-Received: by 2002:a7b:c84c:: with SMTP id c12mr3851618wml.70.1562340297200;
        Fri, 05 Jul 2019 08:24:57 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id c30sm789893wrb.15.2019.07.05.08.24.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:24:56 -0700 (PDT)
Date:   Fri, 5 Jul 2019 18:24:53 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next v3 3/3] net: stmmac: Introducing support for
 Page Pool
Message-ID: <20190705152453.GA24683@apalos>
References: <cover.1562311299.git.joabreu@synopsys.com>
 <384dab52828c4b65596ef4202562a574eed93b91.1562311299.git.joabreu@synopsys.com>
 <20190705132905.GA15433@apalos>
 <BN8PR12MB32666359FABD7D7E55FE4761D3F50@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32666359FABD7D7E55FE4761D3F50@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose, 

On Fri, Jul 05, 2019 at 03:21:16PM +0000, Jose Abreu wrote:
> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> 
> > I think this look ok for now. One request though, on page_pool_free 
> 
> Thanks for the review!
> 
> > A patch currently under review will slightly change that [1] and [2]
> > Can you defer this a bit till that one gets merged?
> > The only thing you'll have to do is respin this and replace page_pool_free()
> > with page_pool_destroy()
> 
> As we are in end of release cycle net-next may close soon so maybe this 
> can be merged and I can send a follow-up patch later if that's okay by 
> you and David ?
Well ideally we'd like to get the change in before the merge window ourselves,
since we dont want to remove->re-add the same function in stable kernels. If
that doesn't go in i am fine fixing it in the next merge window i guess, since
it offers substantial speedups


Thanks
/Ilias
